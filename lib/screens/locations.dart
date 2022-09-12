import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:project/models/location_model.dart';
import 'package:project/shared_widgets/admin_drawer.dart';
import 'package:project/shared_widgets/location_details.dart';

import '../global/global.dart';
import '../shared_widgets/info_design.dart';
import '../shared_widgets/progress_bar.dart';
import '../upload_screens/upload_location.dart';

class LocationsDesign extends StatefulWidget {
  Locations? model;
  BuildContext? context;

  LocationsDesign({this.model, this.context});

  @override
  State<LocationsDesign> createState() => _LocationsDesignState();
}

class _LocationsDesignState extends State<LocationsDesign> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Places"),
        automaticallyImplyLeading: true,
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
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: ListTile(
              title: Text("All Places"),
            ),
            //   SliverPersistentHeader(
            //   pinned: true,
            //   delegate: TextWidgetHeader(title: "My Menus"),
            // ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("places").snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: circularProgress(),
                      ),
                    )
                  : SliverAlignedGrid.count(
                      itemBuilder: (context, index) {
                        Locations model = Locations.fromJson(
                            snapshot.data!.docs[index].data()!
                                as Map<String, dynamic>);

                        return InfoDesignWidget(model: model, context: context);
                      },
                      crossAxisCount: 1,
                      itemCount: snapshot.data!.docs.length,
                    );
            },
          )
        ],
      ),
    );
  }
}

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  CollectionReference _locrefrence =
      FirebaseFirestore.instance.collection("places");
  late Stream<QuerySnapshot> _streamPlacesList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _streamPlacesList = _locrefrence.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _streamPlacesList,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        if (snapshot.connectionState == ConnectionState.active) {
          QuerySnapshot querySnapshot = snapshot.data;
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
