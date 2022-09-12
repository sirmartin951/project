import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project/models/location_model.dart';
import 'package:project/provider/location_provider.dart';
import 'package:project/shared_widgets/users_drawer.dart';
import 'package:provider/provider.dart';

import 'global/global.dart';

class GoogleMapPage extends StatefulWidget {
  final Locations? model;
  const GoogleMapPage({Key? key, this.model}) : super(key: key);

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  final String? name = sharedPreferences!.getString('name');
  @override
  void initState() {
    super.initState();
    Provider.of<LocationProvider>(context, listen: false).initialization();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: UsersDrawer(),
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
          "Welcome Back: " + (name).toString(),
          style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        backgroundColor: Color.fromARGB(255, 2, 80, 31),
      ),
      body: googleMapUI(),
    );
  }

  Widget googleMapUI() {
    return Consumer<LocationProvider>(builder: (context, model, child) {
      return Column(
        children: const [
          Expanded(
            child: GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: CameraPosition(
                  target:
                      LatLng(7.322210, -2.316623),
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
