import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_polyline_new/google_map_polyline_new.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project/models/get_lat_lng.dart';
import 'package:project/models/location_model.dart';
import 'package:project/provider/location_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'global/global.dart';

class Places extends StatefulWidget {
  final Locations? model;
  const Places({Key? key, this.model}) : super(key: key);

  @override
  State<Places> createState() => _PlacesState();
}

class _PlacesState extends State<Places> {
  late GoogleMapController mapController;
  final String? name = sharedPreferences!.getString('name');
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  GoogleMapPolyline googleMapPolyline =
      GoogleMapPolyline(apiKey: "AIzaSyDO70UvC0LZQAimmtXd2CazRLwCyTSRC3o");


  List<Placemark>? placeMarks;
  late var lat = widget.model!.latitude;
  late var lng = widget.model!.longitude;
  late var curLat;
  late var curLng;

  @override
  void initState() {
    super.initState();
    Provider.of<LocationProvider>(context, listen: false).initialization();
    /// origin marker
    _addMarker(LatLng(GetCoordinates.lat, GetCoordinates.lng), "origin",
        BitmapDescriptor.defaultMarker);

    /// destination marker
    _addMarker(LatLng(widget.model!.longitude!, widget.model!.longitude!), "destination",
        BitmapDescriptor.defaultMarkerWithHue(90),);
    _getPolyline();
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
  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

   _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

    _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        'AIzaSyDO70UvC0LZQAimmtXd2CazRLwCyTSRC3o',
        PointLatLng(GetCoordinates.lat, GetCoordinates.lng),
        PointLatLng(widget.model!.latitude!, widget.model!.longitude!),
        travelMode: TravelMode.walking
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  @override
  Widget build(BuildContext context) {
    _getCurrentLocation();
    final Marker _kGooglePlexMarker = Marker(
        markerId: const MarkerId("_kGooglePlex"),
        infoWindow:  InfoWindow(title: widget.model!.nameOfLocation.toString(),snippet: "Your destination"),
        icon: BitmapDescriptor.defaultMarker,
        position: LatLng(lat!, lng!));

    final Marker _destMarker = Marker(
        markerId: const MarkerId("_kGooglePlex"),
        infoWindow: const InfoWindow(title: "Origin",snippet: "This is your starting point"),
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
                mapType: MapType.hybrid,
              initialCameraPosition: CameraPosition(
                  target: LatLng(GetCoordinates.lat, GetCoordinates.lng), zoom: 15),
              myLocationEnabled: true,
              tiltGesturesEnabled: true,
              compassEnabled: true,
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
              onMapCreated: _onMapCreated,
              markers: {_destMarker,_kGooglePlexMarker},
              polylines: Set<Polyline>.of(polylines.values),
            )
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
