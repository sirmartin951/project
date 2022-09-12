import 'package:flutter/material.dart';
import 'package:project/models/location_model.dart';

class LocationDetails extends StatefulWidget {
  Locations? model;
  BuildContext? context;

  LocationDetails({this.model, this.context});

  @override
  State<LocationDetails> createState() => _LocationDetailsState();
}

class _LocationDetailsState extends State<LocationDetails> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (c) => ItemsScreen(model: widget.model!)));
      },
      splashColor: Colors.amber,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          height: MediaQuery.of(context).size.height * .35,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Text(
                widget.model!.nameOfLocation!,
                style: const TextStyle(
                    color: Color.fromARGB(255, 100, 4, 19), fontSize: 20),
              ),
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
              const SizedBox(
                height: 10,
              ),
              Text(widget.model!.description!),
            ],
          ),
        ),
      ),
    );
  }
}
