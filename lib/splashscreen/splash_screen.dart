import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project/screens/admin_home.dart';

import '../authentication/auth_screen.dart';
import '../global/global.dart';
import '../screens/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

final String? email = sharedPreferences!.getString("email");
final String? adminTextkey = sharedPreferences!.getString("adminTextKey");
final String? adminkey = sharedPreferences!.getString("adminKey");

class _SplashScreenState extends State<SplashScreen> {
  startTimer() {
    Timer(const Duration(seconds: 2), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (c) => const AuthScreen()));
      if (firebaseAuth.currentUser != null) {
        if(adminTextkey!=null && adminTextkey==adminkey){
           Navigator.push(
            context,
            MaterialPageRoute(
              builder: (c) => const AdminHome(),
            ),
          );
        }else{
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (c) => const Home(),
            ),
          );
        }
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const AuthScreen()));
      }
    });
  }

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/dm.jpg'),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.all(18.0),
              child: Text(
                'WELCOME TO NSTU :)',
                style: TextStyle(
                  fontFamily: "Anton",
                  fontSize: 30,
                  letterSpacing: 3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
