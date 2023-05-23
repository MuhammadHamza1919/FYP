import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoescannerapp/All_Data.dart';
import 'package:shoescannerapp/Screens/Home_Page.dart';
import 'package:shoescannerapp/Screens/Product.dart';
import 'package:shoescannerapp/Screens/Welcome_Screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Layout/Colors.dart';
import 'Login.dart';
import 'package:flutter/services.dart' as rootbundle;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Add_Product.dart';

import 'Record_Management.dart';


class Brand_Ambassador extends StatefulWidget {
  static const String id = 'Brand_Ambassador';

  @override
  State<Brand_Ambassador> createState() => _Brand_AmbassadorState();
}

class _Brand_AmbassadorState extends State<Brand_Ambassador> {
  String UserID = '';
  String UserEmail = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    final User? user = _auth.currentUser;
    setState(() {
      UserID = user!.uid!;
      UserEmail = user!.email!;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Brand Ambassador'),
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
      body: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Add_Product.id);
                  },
                  child: Text('Add New Product'),
                ),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecordManagement(
                          RecordID: UserEmail,
                        ),
                      ),
                    );
                  },
                  child: Text('View My Products'),
                ),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecordManagement(
                          RecordID: UserID,
                        ),
                      ),
                    );
                  },
                  child: Text('View Orders'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
