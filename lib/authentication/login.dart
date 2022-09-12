// ignore_for_file: unrelated_type_equality_checks

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/screens/admin_home.dart';
import 'package:project/shared_widgets/progress_bar.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import '../global/global.dart';
import '../screens/home.dart';
import '../shared_widgets/custom_text_field.dart';
import '../shared_widgets/loading_dialog.dart';
import 'auth_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController adminKeyController = TextEditingController();
  User? currentUser;
  String adminKey = "ADMIN@NSTU104Y";
  bool uploading = false;

  loginValidator() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Email & Password fields are required!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromARGB(255, 124, 4, 4),
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      loginFunc();
    }
  }

  loginFunc() async {
    setState(() {
      uploading = true;
    });
    await firebaseAuth
        .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim())
        .then((auth) {
      currentUser = auth.user;
    }).catchError((onError) {
      Fluttertoast.showToast(
          msg: onError.message.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromARGB(255, 124, 4, 4),
          textColor: Colors.white,
          fontSize: 16.0);
    });
    if (currentUser != null) {
      setState(() {
        uploading = false;
      });
      Fluttertoast.showToast(
          msg: "Loging Success!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromARGB(255, 4, 124, 72),
          textColor: Colors.white,
          fontSize: 16.0);
      readDataAndSetDataLocally(currentUser!);
    }
    // if (currentUser != null) {
    //   Navigator.pop(context);

    //   Route newRoute = MaterialPageRoute(builder: (c) {
    //     return const HomeScreen();
    //   });
    //   Navigator.pushReplacement(context, newRoute);
    // } else {
    //   Navigator.pop(context);
    //   Route newRoute = MaterialPageRoute(builder: (c) {
    //     return const AuthScreen();
    //   });
    //   Navigator.pushReplacement(context, newRoute);
    // }
  }

  Future readDataAndSetDataLocally(User currentUser) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        await sharedPreferences!.setString("uid", currentUser.uid);
        await sharedPreferences!
            .setString("email", emailController.text.trim());
        await sharedPreferences!.setString("name", snapshot.data()!["name"]);
        await sharedPreferences!
            .setString("photoUrl", snapshot.data()!["photoUrl"]);
        await sharedPreferences!.setString("adminKey", adminKey);
        await sharedPreferences!
            .setString("adminTextKey", adminKeyController.text);
        if (adminKeyController.text.isNotEmpty &&
            adminKeyController.text == adminKey) {
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const AdminHome()));
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const Home()));
        }
      } else {
        Fluttertoast.showToast(
            msg: "NO records Exist for this Account!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Color.fromARGB(255, 124, 4, 4),
            textColor: Colors.white,
            fontSize: 16.0);
        firebaseAuth.signOut();
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const AuthScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            uploading ? linearProgress() : const Text(""),
            const SizedBox(
              height: 20,
            ),
            Image.asset('images/l.jpg'),
            CustomTextField(
              controller: emailController,
              data: Icons.email,
              isObscure: false,
              hintText: 'Email',
            ),
            CustomTextField(
              controller: passwordController,
              data: Icons.lock_open,
              isObscure: true,
              hintText: 'Password',
            ),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
              controller: adminKeyController,
              data: Icons.key_rounded,
              isObscure: false,
              hintText: 'If Admin, Enter Admin key (Optional)',
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () {
                loginValidator();
              },
              child: const Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 70, vertical: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
