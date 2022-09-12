import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/google_map_page.dart';
import 'package:project/models/location_model.dart';
import 'package:project/places.dart';
import 'package:project/splashscreen/splash_screen.dart';
import 'package:project/upload_screens/update_location.dart';

import '../global/global.dart';

class InfoDesignWidget extends StatefulWidget {
  Locations? model;
  BuildContext? context;

  InfoDesignWidget({this.model, this.context});

  @override
  State<InfoDesignWidget> createState() => _InfoDesignWidgetState();
}

class _InfoDesignWidgetState extends State<InfoDesignWidget> {
  deleteLocation(String userUID) {
    FirebaseFirestore.instance.collection("places").doc(userUID).delete();
    Fluttertoast.showToast(msg: "This Location has been deleted successfully");
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (c) => Places(model: widget.model!)));
      },
      splashColor: Colors.amber,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          height: MediaQuery.of(context).size.height * .35,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Image.network(
                  widget.model!.thumbnailUrl!,
                  scale: 2.0,
                  width: MediaQuery.of(context).size.width * 0.9,
                  fit: BoxFit.cover,
                ),
              ),
              Text(
                widget.model!.nameOfLocation!,
                style: const TextStyle(
                    color: Color.fromARGB(255, 100, 4, 19), fontSize: 20),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(widget.model!.description!),
              if (adminkey != "")
                Row(children: [
                   sharedPreferences!.getString('adminTextKey') != ""?
                  IconButton(
                    color: Color.fromARGB(255, 3, 97, 38),
                    onPressed: () {},
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (c) =>
                    //           UpdateLocation(widget.model!.locationID!),
                    //     ),
                    //   );
                    // },
                    icon: const Icon(Icons.edit),
                  ):SizedBox(),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                  ),
                  sharedPreferences!.getString('adminTextKey') != ""
                      ? IconButton(
                          color: Color.fromARGB(255, 146, 17, 8),
                          onPressed: () {
                            //DeleteLocation Method Called
                            deleteLocation(widget.model!.locationID!);
                          },
                          icon: const Icon(Icons.delete),
                        )
                      : SizedBox()
                ])
            ],
          ),
        ),
      ),
    );
  }
}
