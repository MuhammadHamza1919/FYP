import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:shoescannerapp/All_Data.dart';
import 'package:shoescannerapp/Screens/Data_User.dart';
import 'package:shoescannerapp/Screens/Delete_Brand_Ambassador.dart';
import 'package:shoescannerapp/Screens/Home_Page.dart';
import 'package:shoescannerapp/Screens/Indiv_chat.dart';
import 'package:shoescannerapp/Screens/Product.dart';
import 'package:shoescannerapp/Screens/SignUp_Brand_Ambassador.dart';
import 'package:shoescannerapp/Screens/User_Cart.dart';
import 'package:shoescannerapp/Screens/Welcome_Screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Layout/Colors.dart';
import 'Login.dart';
import 'package:flutter/services.dart' as rootbundle;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Record_Management.dart';

class Admin extends StatefulWidget {
  static const String id = 'Admin';

  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Administrator'),
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
      body: Center(
        child: Column(
          children: [
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecordManagement(
                        RecordID: '01',
                      ),
                    ),
                  );
                },
                child: Text('Manage Admin Record'),
              ),
            ],
          ),
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecordManagement(
                        RecordID: '02',
                      ),
                    ),
                  );
                },
                child: Text('Manage Employee Record'),
              ),
            ],
          ),
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecordManagement(
                        RecordID: '04',
                      ),
                    ),
                  );
                },
                child: Text('View Orders'),
              ),
            ],
          ),
          ],
        ),
      ),
    );
  }
}
