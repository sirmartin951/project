import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project/provider/location_provider.dart';
import 'package:project/shared_widgets/admin_drawer.dart';
import 'package:project/upload_screens/upload_location.dart';
import 'package:provider/provider.dart';

import 'global/global.dart';

class AdminGoogleMapPage extends StatefulWidget {
  const AdminGoogleMapPage({Key? key}) : super(key: key);

  @override
  State<AdminGoogleMapPage> createState() => _AdminGoogleMapPageState();
}

class _AdminGoogleMapPageState extends State<AdminGoogleMapPage> {
  final String? name = sharedPreferences!.getString('name');
  @override
  void initState() {
    super.initState();
    Provider.of<LocationProvider>(context, listen: false).initialization();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AdminDrawer(),
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
        title: const Text(
          "Welcome Backto Admin Dashboard",
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => const UploadPlaces(),
                ),
              );
            },
            icon: const Icon(Icons.post_add),
          )
        ],
        backgroundColor: const Color.fromARGB(255, 2, 80, 31),
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
              initialCameraPosition:
                  CameraPosition(target: LatLng(7.322210, -2.316623), zoom: 18),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
          ),
        ],
      );
    });
  }
}
