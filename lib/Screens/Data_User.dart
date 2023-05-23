import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoescannerapp/All_Data.dart';
import 'package:shoescannerapp/Screens/Product.dart';
import 'package:shoescannerapp/Screens/Welcome_Screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Layout/Colors.dart';
import 'Home_Page.dart';
import 'Login.dart';
import 'package:flutter/services.dart' as rootbundle;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Data_User extends StatefulWidget {
  static const String id = 'Data_User';

  @override
  State<Data_User> createState() => _Data_UserState();
}

class _Data_UserState extends State<Data_User> {
  late String _userId;
  String firstName = '';
  String lastName = '';
  String email = '';
  String password = '';
  String my_role = '';

  late FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    final User? user = _auth.currentUser;
    setState(() {
      _userId = user!.uid;
      firstName = user!.displayName!.split(" ")[0];
      lastName = user!.displayName!.split(" ")[1];
      email = user.email!;
      print(_userId);
      print(firstName);
      print(lastName);
      print(email);
    });
    final userDoc =
    await FirebaseFirestore.instance.collection('users').doc(email).get();
    if (userDoc.exists) {
      setState(() {
        my_role = userDoc.data()?['role'] ?? '';
        print(my_role);
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Data'),
        leading: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/user.png'),
              radius: 60.0,
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Name',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  '$firstName $lastName',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'User ID',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  '$_userId',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Email',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  '$email',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Password',
                  style: TextStyle(fontSize: 16.0),
                ),
                const Text(
                  '********',
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Role',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  '$my_role',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
