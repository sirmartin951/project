import "package:flutter/material.dart";
import 'package:project/models/location_model.dart';
import '../authentication/auth_screen.dart';
import '../feeback_from_users.dart';
import '../global/global.dart';
import '../screens/admin_home.dart';
import '../screens/home.dart';
import '../screens/locations.dart';
import '../search_screen.dart';

class AdminDrawer extends StatefulWidget {
  // BuildContext? context;

  //AdminDrawer({this.model});

  @override
  State<AdminDrawer> createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer> {
  final String? photoUrl = sharedPreferences!.getString("photoUrl");
  final String? adminKey = sharedPreferences!.getString("adminKey");

  final String? name = sharedPreferences!.getString("name");

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Color.fromARGB(255, 3, 63, 33),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 25, bottom: 10),
              child: Column(children: [
                Material(
                  borderRadius: const BorderRadius.all(Radius.circular(80)),
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: CircleAvatar(
                      //backgroundColor: Colors.,
                      radius: 50,
                      backgroundImage: NetworkImage(
                        photoUrl!,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  name!,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 20,
                      fontFamily: "Train"),
                )
              ]),
            ),
            Container(
              color: Color.fromARGB(255, 3, 63, 33),
              padding: EdgeInsets.only(top: 1.0),
              child: Column(children: [
                const Divider(
                  height: 10,
                  color: Color.fromARGB(255, 255, 255, 255),
                  thickness: 3,
                ),
                ListTile(
                  leading: const Icon(Icons.home,
                      color: Color.fromARGB(255, 255, 255, 255)),
                  title: const Text(
                    "Home",
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                  onTap: () {
                     if (adminKey !="" && adminKey=="ADMIN@NSTU104Y") {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (c) => const AdminHome()));
                    } else {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (c) => const Home()));
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.search,
                      color: Color.fromARGB(255, 255, 255, 255)),
                  title: const Text(
                    "Search for Place",
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => SearchScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.location_city,
                      color: Color.fromARGB(255, 255, 255, 255)),
                  title: const Text(
                    "All Places",
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => LocationsDesign()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.feedback,
                      color: Color.fromARGB(255, 255, 255, 255)),
                  title: const Text(
                    "Feedback From Users",
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => FeedBackFromUsers()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.exit_to_app,
                      color: Color.fromARGB(255, 255, 255, 255)),
                  title: const Text(
                    "Sign Out",
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                  onTap: () {
                    firebaseAuth.signOut().then((value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => const AuthScreen()));
                    });
                  },
                ),
              ]),
            )
          ],
        ));
  }
}




//Api
//AIzaSyDO70UvC0LZQAimmtXd2CazRLwCyTSRC3o