import 'dart:async';
import 'package:flutter/material.dart';
import 'Home_Page.dart';
import 'Login.dart';
import 'package:flutter/services.dart' as rootbundle;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Record_Management.dart';

class Employee extends StatefulWidget {
  static const String id = 'Employee';

  @override
  State<Employee> createState() => _EmployeeState();
}

class _EmployeeState extends State<Employee> {
  @override
  Widget build(BuildContext context) {
    late CollectionReference _AllData =
        FirebaseFirestore.instance.collection('users');

    // Retrieve messages based on user role
    Stream<QuerySnapshot> _getDataStream() {
      return _AllData.snapshots();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Employee'),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecordManagement(
                        RecordID: '03',
                      ),
                    ),
                  );
                },
                child: Text('Manage Brand Ambassador Record'),
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
    );
  }
}
