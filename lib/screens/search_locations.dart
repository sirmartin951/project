import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project/provider/location_provider.dart';
//import 'package:project/screens/register.dart';
import 'package:provider/provider.dart';

class Location_search extends StatefulWidget {
  const Location_search({Key? key}) : super(key: key);

  @override
  State<Location_search> createState() => _Location_searchState();
}

class _Location_searchState extends State<Location_search> {
  int index = 0;
  final screens = const [
    //Register(),
  ];
  @override
  void initState() {
    super.initState();
    Provider.of<LocationProvider>(context, listen: false).initialization();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(25),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                fillColor: Colors.red,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                hintText: "Search for Location",
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
      body: googleMapUI(),
    );
  }

  Widget googleMapUI() {
    return Consumer<LocationProvider>(builder: (context, model, child) {
      return Column(
        children: [
          Expanded(
            child: GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition:
                  CameraPosition(target: model.locationPosition, zoom: 18),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
          ),
        ],
      );
    });
  }
}
