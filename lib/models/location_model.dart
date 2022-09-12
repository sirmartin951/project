import 'package:cloud_firestore/cloud_firestore.dart';

class Locations {
  String? locationID;
  double? longitude;
  double? latitude;
  String? userUID;
  Timestamp? publishedDate;
  String? thumbnailUrl;
  String? status;
  String? nameOfLocation;
  String? description;

  Locations(
      {this.locationID,
      this.longitude,
      this.latitude,
      this.publishedDate,
      this.userUID,
      this.status,
      this.thumbnailUrl});

  Locations.fromJson(Map<String, dynamic> json) {
    locationID = json['locationID'];
    longitude = json['longitude'];
    latitude = json['latittude'];
    nameOfLocation = json['nameOfLocation'];
    description = json['description'];
    publishedDate = json['publishedDate'];
    userUID = json['userUID'];
    status = json['status'];
    thumbnailUrl = json['thumbnailUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['locationID'] = locationID;
    data['nameOfLocation'] = nameOfLocation;
    data['description'] = description;
    data['longitude'] = longitude;
    data['latittude'] = latitude;
    data['publishedDate'] = publishedDate;
    data['userUID'] = userUID;
    data['status'] = status;
    data['thumbnailUrl'] = thumbnailUrl;
    return data;
  }
}
