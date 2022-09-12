import 'package:flutter/material.dart';

import 'login.dart';
import 'register.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0XFFc8d6e5),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromARGB(255, 3, 63, 33),
          centerTitle: true,
          title: const Text(
            'Navigate STU',
            style: TextStyle(color: Colors.white, fontFamily: 'Anton'),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 4,
            tabs: [
              Tab(
                icon: Icon(Icons.lock),
                text: 'Login',
              ),
              Tab(
                icon: Icon(Icons.person),
                text: 'Register',
              )
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            SignInScreen(),
            SignUpScreen(),
          ],
        ),
      ),
    );
  }
}
