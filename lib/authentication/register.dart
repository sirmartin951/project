import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:fluttertoast/fluttertoast.dart';

import '../global/global.dart';
import '../screens/home.dart';
import '../shared_widgets/custom_text_field.dart';
import '../shared_widgets/progress_bar.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController nameController = TextEditingController();
  TextEditingController departmnetController = TextEditingController();
  TextEditingController schoolController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  XFile? imageXFile;
  bool uploading = false;

  final ImagePicker _picker = ImagePicker();

  String sellerImageUrl = '';

  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      imageXFile;
    });
  }

  Future<void> validation() async {
    setState(() {
      uploading = true;
    });
    if (imageXFile == null) {
      Fluttertoast.showToast(
          msg: "No Image has been Selected",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromARGB(255, 124, 4, 4),
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (passwordController.text != confirmPasswordController.text) {
      Fluttertoast.showToast(
          msg: "Your passwords do not match",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromARGB(255, 124, 4, 4),
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty ||
        nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        schoolController.text.isEmpty ||
        departmnetController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "All fields Are required!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromARGB(255, 124, 4, 4),
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      String fileName = DateTime.now().millisecond.toString();
      fStorage.Reference reference = fStorage.FirebaseStorage.instance
          .ref()
          .child('users')
          .child(fileName);
      fStorage.UploadTask uploadTask =
          reference.putFile(File(imageXFile!.path));
      fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      await taskSnapshot.ref.getDownloadURL().then((url) {
        sellerImageUrl = url;

        authenticateUserAndSignup();
      });
    }
  }
  //Authenticating and SigningUp User

  Future authenticateUserAndSignup() async {
    User? currentUser;

    await firebaseAuth
        .createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user;
    }).catchError((error) {
      Fluttertoast.showToast(
          msg: error.message.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromARGB(255, 124, 4, 4),
          textColor: Colors.white,
          fontSize: 16.0);
    });

    if (currentUser != null) {
      saveData(currentUser!).then((value) {
        Fluttertoast.showToast(
            msg: "Account Creation Success!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Color.fromARGB(255, 4, 124, 60),
            textColor: Colors.white,
            fontSize: 16.0);

        Route newRoute = MaterialPageRoute(builder: (c) {
          return const Home();
        });
        Navigator.pushReplacement(context, newRoute);
      });
    }
  }

  Future<void> saveData(User currentUser) async {
    FirebaseFirestore.instance.collection('users').doc(currentUser.uid).set({
      "uid": currentUser.uid,
      "email": currentUser.email,
      "name": nameController.text.trim(),
      "photoUrl": sellerImageUrl,
      "department": departmnetController.text.trim(),
      "program": schoolController.text.trim()
    });

    //Shared preferences

    await sharedPreferences!.setString("uid", currentUser.uid);
    await sharedPreferences!.setString("name", nameController.text.trim());
    await sharedPreferences!.setString("email", currentUser.email.toString());
    await sharedPreferences!.setString("photoUrl", sellerImageUrl);
    await sharedPreferences!
        .setString("department", departmnetController.text.trim());
    await sharedPreferences!.setString("school", schoolController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          uploading ? linearProgress() : const Text(''),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: InkWell(
              onTap: () {
                _getImage();
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: MediaQuery.of(context).size.width * 0.20,
                backgroundImage: imageXFile == null
                    ? null
                    : FileImage(File(imageXFile!.path)),
                child: imageXFile == null
                    ? Icon(
                        Icons.add_photo_alternate,
                        color: const Color(0XFFb33939),
                        size: MediaQuery.of(context).size.width * 0.20,
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Form(
            child: Column(
              children: [
                CustomTextField(
                  controller: nameController,
                  data: Icons.person,
                  isObscure: false,
                  hintText: 'Name',
                ),
                CustomTextField(
                  controller: departmnetController,
                  data: Icons.cast_for_education,
                  isObscure: false,
                  hintText: 'Department',
                ),
                CustomTextField(
                  controller: schoolController,
                  data: Icons.school,
                  isObscure: false,
                  hintText: 'Program of Study',
                ),
                CustomTextField(
                  controller: emailController,
                  data: Icons.email,
                  isObscure: false,
                  hintText: 'Email',
                ),
                CustomTextField(
                  controller: passwordController,
                  data: Icons.lock,
                  isObscure: true,
                  hintText: 'Password',
                ),
                CustomTextField(
                  controller: confirmPasswordController,
                  data: Icons.lock,
                  isObscure: true,
                  hintText: 'Confirm password',
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          ElevatedButton(
            onPressed: () {
              validation();
            },
            child: const Text(
              'Create Account',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
                primary: Colors.red,
                padding:
                    const EdgeInsets.symmetric(horizontal: 70, vertical: 20)),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
