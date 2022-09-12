import 'package:flutter/material.dart';
import 'package:project/admin_google_page_map.dart';
import 'package:project/google_map_page.dart';
import 'package:project/provider/location_provider.dart';
import 'package:provider/provider.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  // This widget is the root of your application.

  // int index = 0;
  // final screens = [
  //   GoogleMapPage(),
  //   Location_search(),
  //   Register(),
  // ];
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LocationProvider(),
          child: const GoogleMapPage(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Scaffold(
          body: AdminGoogleMapPage(),
        ),
      ),
    );
  }
}
