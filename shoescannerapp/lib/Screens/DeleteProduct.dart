import 'package:flutter/material.dart';
import 'package:shoescannerapp/Layout/Colors.dart';
import 'package:shoescannerapp/Screens/Brand_Ambassador.dart';
import 'package:shoescannerapp/Screens/Employee.dart';
import 'package:shoescannerapp/Screens/Home_Page.dart';
import 'package:shoescannerapp/Screens/Record_Management.dart';
import 'Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteProductChange extends StatefulWidget {
  static const String id = 'DeleteProduct';
  final String OrderID;

  const DeleteProductChange({
    Key? key,
    required this.OrderID,
  }) : super(key: key);

  @override
  _DeleteProductState createState() => _DeleteProductState();
}

class _DeleteProductState extends State<DeleteProductChange> {
  final _auth = FirebaseAuth.instance;
  String UserID = '';
  String UserE = '';

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    final User? user = _auth.currentUser;
    setState(() {
      UserID = user!.uid!;
      UserE = user!.email!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/Logo.png',
                  height: 50,
                  width: 50,
                ),
                Container(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Shoe',
                          style: TextStyle(
                              color: AppColor.border,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Times New Roman'),
                        ),
                        TextSpan(
                            text: ' Scanner',
                            style: TextStyle(
                                color: AppColor.secondary,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Times New Roman'))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        body: Center(
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        {
                          {
                            await FirebaseFirestore.instance
                                .collection('All Data')
                                .doc(widget.OrderID)
                                .delete();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Brand_Ambassador()),
                            );
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text('Product Deleted'),
                                content: Text(
                                    'Your Product has been deleted successfully.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Brand_Ambassador()),
                                      );
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                      },
                      child: Text('Confirm Delete Product'),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
