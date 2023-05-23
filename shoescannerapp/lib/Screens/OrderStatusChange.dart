import 'package:flutter/material.dart';
import 'package:shoescannerapp/Layout/Colors.dart';
import 'package:shoescannerapp/Screens/Brand_Ambassador.dart';
import 'package:shoescannerapp/Screens/Employee.dart';
import 'package:shoescannerapp/Screens/Home_Page.dart';
import 'package:shoescannerapp/Screens/Record_Management.dart';
import 'Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderStatusChange extends StatefulWidget {
  static const String id = 'OrderStatusChange';
  final String OrderID;
  const OrderStatusChange({
    Key? key,
    required this.OrderID,
  }) : super(key: key);

  @override
  _OrderStatusChangeState createState() => _OrderStatusChangeState();
}

class _OrderStatusChangeState extends State<OrderStatusChange> {
  final _auth = FirebaseAuth.instance;
  List<String> _OderStatus = ['Pending', 'On Way', 'Delivered'];
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
      UserE= user!.email!;
    });
  }

  String _selectedStatus = 'Pending'; // Add
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _UserEmail = TextEditingController();

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
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedStatus,
                    items: _OderStatus.map((selectedStatus) {
                      return DropdownMenuItem<String>(
                        value: selectedStatus,
                        child: Text(selectedStatus),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedStatus = value!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Order Status',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState != null) {
                        await FirebaseFirestore.instance
                            .collection('Orders')
                            .doc(widget.OrderID)
                            .update({'OrderStatus': _selectedStatus});
                        await FirebaseFirestore.instance
                            .collection('Cart')
                            .doc(widget.OrderID)
                            .update({'OrderStatus': _selectedStatus});
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Brand_Ambassador(),
                          ),
                        );
                      }
                    },
                    child: const Text('Change Status'),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
