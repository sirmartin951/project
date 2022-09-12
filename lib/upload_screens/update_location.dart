//import 'dart:js';

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as storageRef;
import 'package:project/screens/admin_home.dart';
import '../global/global.dart';
import '../models/location_model.dart';
import '../screens/home.dart';
import '../shared_widgets/progress_bar.dart';

class UpdateLocation extends StatefulWidget {
  final Locations? model;
  UpdateLocation(String? locationID, {this.model, Locations? location});

  @override
  State<UpdateLocation> createState() => _UpdateLocationState();
}

class _UpdateLocationState extends State<UpdateLocation> {
  XFile? imageXFile;
  final String? adminKey = sharedPreferences!.getString('adminKey');
  String completeAddress = '';

  Position? position;
  List<Placemark>? placeMarks;
  final ImagePicker imagePicker = ImagePicker();
  TextEditingController shortInforController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController shortDescController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController longController = TextEditingController();
  TextEditingController latController = TextEditingController();
  bool uploading = false;
  String uniqueIdName = DateTime.now().microsecondsSinceEpoch.toString();
  takeImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              "Location Image",
              style: TextStyle(
                  color: Color.fromARGB(255, 28, 33, 183),
                  fontWeight: FontWeight.bold),
            ),
            children: [
              SimpleDialogOption(
                child: Text(
                  "Capture With Camera",
                  style: TextStyle(color: Color.fromARGB(255, 4, 134, 4)),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  imageXFile = await imagePicker.pickImage(
                    source: ImageSource.camera,
                    maxHeight: 720,
                    maxWidth: 1280,
                  );
                  setState(() {
                    imageXFile;
                  });
                },
              ),
              SimpleDialogOption(
                child: Text(
                  "Choose from Gallery",
                  style: TextStyle(color: Color.fromARGB(255, 57, 142, 8)),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  imageXFile = await imagePicker.pickImage(
                    source: ImageSource.gallery,
                    maxHeight: 720,
                    maxWidth: 1280,
                  );
                  setState(() {
                    imageXFile;
                  });
                },
              ),
              SimpleDialogOption(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                      color: Color.fromARGB(255, 142, 37, 8), fontSize: 30),
                ),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: 'Please Enable device location');
    }
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      Fluttertoast.showToast(msg: 'Location permission is denied');
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(msg: 'Location permission denied forever');
    }

    Position newPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    position = newPosition;
    placeMarks =
        await placemarkFromCoordinates(position!.latitude, position!.longitude);
    Placemark pMark = placeMarks![0];
    completeAddress =
        '${pMark.street!.trim()},${pMark.subThoroughfare}, ${pMark.thoroughfare}, ${pMark.subLocality}, ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea}, ${pMark.postalCode}, ${pMark.country}';
    setState(() {
      latController.text = position!.latitude.toString();
      longController.text = position!.longitude.toString();
    });
  }

  clearForm() {
    setState(() {
      shortInforController.clear();
      titleController.clear();
      latController.clear();
      longController.clear();
      imageXFile = null;
      uploading = false;
    });
  }

  createLocation() async {
    if (imageXFile == null) {
      Fluttertoast.showToast(
          msg: "Please select an Image",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromARGB(255, 124, 4, 4),
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (latController.text.isNotEmpty &&
        longController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        shortDescController.text.isNotEmpty) {
      setState(() {
        uploading = true;
      });

      //upload image
      String downloadUrl = await uploadImage(File(imageXFile!.path));
      //Save data
      saveInfo(downloadUrl);
    } else {
      Fluttertoast.showToast(
          msg: "All fields are required!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromARGB(255, 124, 4, 4),
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  saveInfo(String downloadUrl) {
    FirebaseFirestore.instance.collection("places").doc(uniqueIdName).set({
      "locationID": uniqueIdName,
      "userUID": sharedPreferences!.getString('uid'),
      "nameOfLocation": nameController.text.trim(),
      "description": shortDescController.text.trim(),
      "longitude": double.parse(longController.text),
      "latittude": double.parse(latController.text),
      "publishedDate": DateTime.now(),
      "thumbnailUrl": downloadUrl
    });

    clearForm();
    Fluttertoast.showToast(
        msg: "Location created Successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromARGB(255, 4, 124, 60),
        textColor: Colors.white,
        fontSize: 16.0);

    setState(() {
      uniqueIdName = DateTime.now().microsecondsSinceEpoch.toString();
      uploading = false;
    });
  }

  uploadImage(mImageFile) async {
    storageRef.Reference reference =
        storageRef.FirebaseStorage.instance.ref().child("locations");
    storageRef.UploadTask uploadTask =
        reference.child(uniqueIdName + ".jpg").putFile(mImageFile);
    storageRef.TaskSnapshot taskSnapshot =
        await uploadTask.whenComplete(() => null);
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: uploading ? null : () => createLocation(),
            child: const Text(
              "Post",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontFamily: "monospace"),
            ),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => clearForm(),
        ),
        title: Text(widget.model!.locationID!),
        automaticallyImplyLeading: true,
        backgroundColor: Color.fromARGB(255, 11, 111, 4),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          uploading ? linearProgress() : const Text(''),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 230,
            // child: Center(
            //   child: AspectRatio(
            //     child: Container(
            //       decoration: BoxDecoration(
            //         image: DecorationImage(
            //             image: FileImage(
            //               File(imageXFile!.path),
            //             ),
            //             fit: BoxFit.cover),
            //       ),
            //     ),
            //     aspectRatio: 16 / 9,
            //   ),
            // ),
          ),
          ListTile(
            leading: const Icon(Icons.text_fields),
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(
                  color: Color.fromARGB(255, 106, 14, 7),
                ),
                controller: nameController,
                decoration: const InputDecoration(
                    hintText: "Name of Location",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: Container(
              width: 250,
              child: TextField(
                keyboardType: TextInputType.text,
                style: const TextStyle(
                  color: Color.fromARGB(255, 106, 14, 7),
                ),
                controller: shortDescController,
                decoration: const InputDecoration(
                    hintText: "Short description",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.location_city),
            title: Container(
              width: 250,
              child: TextField(
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  color: Color.fromARGB(255, 106, 14, 7),
                ),
                controller: longController,
                decoration: const InputDecoration(
                    hintText: "Longitude (press the get coordinates button)",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            leading: const Icon(Icons.title),
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(
                  color: Color.fromARGB(255, 106, 14, 7),
                ),
                controller: latController,
                decoration: const InputDecoration(
                    hintText: "Lattitude (press the get coordinates button)",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              child: const Text(
                "get coordinates",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Color.fromARGB(255, 11, 111, 4)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              onPressed: () {
                getCurrentLocation();
              },
            ),
          ),
        ],
      ),
    );
  }
}
