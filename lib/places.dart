import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project/models/get_lat_lng.dart';
import 'package:project/models/location_model.dart';
import 'package:project/provider/location_provider.dart';
import 'package:provider/provider.dart';

import 'global/global.dart';

class Places extends StatefulWidget {
  final Locations? model;
  const Places({Key? key, this.model}) : super(key: key);

  @override
  State<Places> createState() => _PlacesState();
}

class _PlacesState extends State<Places> {
  final String? name = sharedPreferences!.getString('name');

  List<Placemark>? placeMarks;
  late var lat = widget.model!.latitude;
  late var lng = widget.model!.longitude;
  late var curLat;
  late var curLng;

  @override
  void initState() {
    super.initState();
    Provider.of<LocationProvider>(context, listen: false).initialization();
  }

  Future<void> _getCurrentLocation() async {
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

    setState(() {
      GetCoordinates.lat = newPosition.latitude;
      GetCoordinates.lng = newPosition.longitude;
    });
  }

  @override
  Widget build(BuildContext context) {
    _getCurrentLocation();
    final Marker _kGooglePlexMarker = Marker(
        markerId: const MarkerId("_kGooglePlex"),
        infoWindow: const InfoWindow(title: "Destination"),
        icon: BitmapDescriptor.defaultMarker,
        position: LatLng(lat!, lng!));

    final Marker _destMarker = Marker(
        markerId: const MarkerId("_kGooglePlex"),
        infoWindow: const InfoWindow(title: "Origin"),
        icon: BitmapDescriptor.defaultMarker,
        position: LatLng(GetCoordinates.lat, GetCoordinates.lng));

    final Polyline _kPolyline = Polyline(
      polylineId: PolylineId('_kPolyline'),
      visible: true,
      points: [
        LatLng(GetCoordinates.lat, GetCoordinates.lng),
        LatLng(lat!, lng!)
      ],
      width: 3,
      color: Colors.red,
      startCap: Cap.roundCap,
      endCap: Cap.buttCap,
    );
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(GetCoordinates.lat);
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        bottom: PreferredSize(
          child: Container(
            color: const Color.fromARGB(255, 255, 255, 255),
            height: 10.0,
          ),
          preferredSize: const Size.fromHeight(4.0),
        ),
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          (widget.model!.nameOfLocation).toString(),
          style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        backgroundColor: Color.fromARGB(255, 2, 80, 31),
      ),
      body: Consumer<LocationProvider>(builder: (context, model, child) {
        return Column(
          children: [
            Expanded(
              child: GoogleMap(
                polylines: {
                  _kPolyline,
                },
                mapType: MapType.hybrid,
                markers: {_destMarker, _kGooglePlexMarker},
                initialCameraPosition: CameraPosition(
                    target: LatLng(GetCoordinates.lat, GetCoordinates.lng),
                    zoom: 18),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget googleMapUI() {
    return Consumer<LocationProvider>(builder: (context, model, child) {
      return Column(
        children: [
          Expanded(
            child: GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: CameraPosition(
                  target:
                      LatLng(widget.model!.latitude!, widget.model!.longitude!),
                  zoom: 18),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
          ),
        ],
      );
    });
  }
}
