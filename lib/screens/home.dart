import 'package:flutter/material.dart';
import 'package:project/google_map_page.dart';
import 'package:project/provider/location_provider.dart';
import 'package:provider/provider.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
          body: GoogleMapPage(),
        ),
      ),
    );
  }
}
