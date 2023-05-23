import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shoescannerapp/Screens/Admin.dart';
import 'package:shoescannerapp/Screens/Brand_Ambassador.dart';
import 'package:shoescannerapp/Screens/Delete.dart';
import 'package:shoescannerapp/Screens/Delete_Admin.dart';
import 'package:shoescannerapp/Screens/Delete_Employee.dart';
import 'package:shoescannerapp/Screens/Employee.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Layout/Colors.dart';
import '../All_Data.dart';
import 'Data_User.dart';
import 'DeleteProduct.dart';
import 'Delete_Brand_Ambassador.dart';
import 'Home_Page.dart';
import 'Indiv_chat.dart';
import 'ModifyAmin.dart';
import 'ModifyEmployee.dart';
import 'OrderStatusChange.dart';
import 'Product.dart';
import 'SignUpAdmin.dart';
import 'SignUpEmployee.dart';
import 'SignUp_Brand_Ambassador.dart';
import 'User_Cart.dart';
import 'Welcome_Screen.dart';

class RecordManagement extends StatefulWidget {
  static const String id = 'RecordManagement';
  final String RecordID;

  const RecordManagement({
    Key? key,
    required this.RecordID,
  }) : super(key: key);

  @override
  _RecordManagement createState() => _RecordManagement();
}

class _RecordManagement extends State<RecordManagement> {
  String UserID = '';
  String UserEmail = '';
  String my_role = '';

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
    final userDoc =
    await FirebaseFirestore.instance.collection('users').doc(UserEmail).get();
    if (userDoc.exists) {
      setState(() {
        my_role = userDoc.data()?['role'] ?? '';
        print(my_role);
      });
    };
  }

  late CollectionReference _AllData =
      FirebaseFirestore.instance.collection('users');

  // Retrieve messages based on user role
  Stream<QuerySnapshot> _getDataStream() {
    return _AllData.snapshots();
  }
  late CollectionReference _AllProducts =
      FirebaseFirestore.instance.collection('All Data');

  // Retrieve messages based on user role
  Stream<QuerySnapshot> _getDataaStream() {
    return _AllProducts.snapshots();
  }

  late CollectionReference _Cart =
      FirebaseFirestore.instance.collection('Orders');

  // Retrieve messages based on user role
  Stream<QuerySnapshot> _getDatasStream() {
    return _Cart.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$my_role'),
        leading: InkWell(
          onTap: () {
            if (widget.RecordID == '01')
              Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Admin(),
              ),
            );
            if (widget.RecordID == '02')
              Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Admin(),
              ),
            );
            if (widget.RecordID == '03')
              Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Employee(),
              ),
            );
            if (widget.RecordID == '04')
              Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
            if (widget.RecordID == UserID||widget.RecordID == UserEmail)
              Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Brand_Ambassador(),
              ),
            );
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          if (widget.RecordID == '01')
            Container(
              // Add a container to set the background color of the heading
              color: Colors.blue,
              child: Center(
                child: Text(
                  'Admin Data',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Set the text color to white
                  ),
                ),
              ),
            ),
          const SizedBox(height: 20),
          if (widget.RecordID == '01')
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _getDataStream(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final data = snapshot.data!.docs;
                  final columns = [
                    DataColumn(label: Text('First Name')),
                    DataColumn(label: Text('Last Name')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Password')),
                    DataColumn(label: Text('Role')),
                  ];
                  final rows = data
                      .where((doc) => doc['role'] == 'Admin')
                      .map((doc) => DataRow(cells: [
                            DataCell(Text(doc['fname'])),
                            DataCell(Text(doc['lname'])),
                            DataCell(Text(doc['email'])),
                            DataCell(Text(doc['password'])),
                            DataCell(Text(doc['role'])),
                          ]))
                      .toList();

                  return Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: columns,
                        rows: rows,
                      ),
                    ),
                  );
                },
              ),
            ),
          if (widget.RecordID == '01')
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, SignupAdmin.id);
                  },
                  child: Text('Create Admin Account'),
                ),
              ],
            ),
          if (widget.RecordID == '01')
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Modify.id);
                  },
                  child: Text('Modify Admin Record'),
                ),
              ],
            ),
          if (widget.RecordID == '01')
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Delete_Admin.id);
                  },
                  child: Text('Delete Admin Account'),
                ),
              ],
            ),
          if (widget.RecordID == '01')
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Admin(),
                      ),
                    );
                  },
                  child: Text('Go Back'),
                ),
              ],
            ),
          if (widget.RecordID == '02')
            Container(
              // Add a container to set the background color of the heading
              color: Colors.blue,
              child: Center(
                child: Text(
                  'Employee Data',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Set the text color to white
                  ),
                ),
              ),
            ),
          const SizedBox(height: 20),
          if (widget.RecordID == '02')
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _getDataStream(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final data = snapshot.data!.docs;
                  final columns = [
                    DataColumn(label: Text('First Name')),
                    DataColumn(label: Text('Last Name')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Password')),
                    DataColumn(label: Text('Role')),
                  ];
                  final rows = data
                      .where((doc) => doc['role'] == 'Employee')
                      .map((doc) => DataRow(cells: [
                            DataCell(Text(doc['fname'])),
                            DataCell(Text(doc['lname'])),
                            DataCell(Text(doc['email'])),
                            DataCell(Text(doc['password'])),
                            DataCell(Text(doc['role'])),
                          ]))
                      .toList();

                  return Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: columns,
                        rows: rows,
                      ),
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 20),
          if (widget.RecordID == '02')
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, SignupEmployee.id);
                  },
                  child: Text('Create Employee Account'),
                ),
              ],
            ),
          if (widget.RecordID == '02')
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, ModifyE.id);
                  },
                  child: Text('Modify Employee Data'),
                ),
              ],
            ),
          if (widget.RecordID == '02')
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Delete_Employee.id);
                  },
                  child: Text('Delete Employee Account'),
                ),
              ],
            ),
          if (widget.RecordID == '02')
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Admin(),
                      ),
                    );
                  },
                  child: Text('Go Back'),
                ),
              ],
            ),
          if (widget.RecordID == '03')
            Container(
              // Add a container to set the background color of the heading
              color: Colors.blue,
              child: Center(
                child: Text(
                  'Create Brand Ambassador Data',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Set the text color to white
                  ),
                ),
              ),
            ),
          const SizedBox(height: 20),
          if (widget.RecordID == '03')
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _getDataStream(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final data = snapshot.data!.docs;
                  final columns = [
                    DataColumn(label: Text('First Name')),
                    DataColumn(label: Text('Last Name')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Password')),
                    DataColumn(label: Text('Role')),
                  ];
                  final rows = data
                      .where((doc) => doc['role'] == 'Brand Ambassador')
                      .map((doc) => DataRow(cells: [
                            DataCell(Text(doc['fname'])),
                            DataCell(Text(doc['lname'])),
                            DataCell(Text(doc['email'])),
                            DataCell(Text(doc['password'])),
                            DataCell(Text(doc['role'])),
                          ]))
                      .toList();

                  return Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: columns,
                        rows: rows,
                      ),
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 20),
          if (widget.RecordID == '03')
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, SignupBA.id);
                  },
                  child: Text('Create Brand Ambassador Account'),
                ),
              ],
            ),
          if (widget.RecordID == '03')
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Delete_Brand_Ambassador.id);
                  },
                  child: Text('Delete Brand Ambassador Account'),
                ),
              ],
            ),
          if (widget.RecordID == '03')
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Employee(),
                      ),
                    );
                  },
                  child: Text('Go Back'),
                ),
              ],
            ),
          if (widget.RecordID == UserID)
            Container(
              // Add a container to set the background color of the heading
              color: Colors.blue,
              child: Center(
                child: Text(
                  'Orders',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Set the text color to white
                  ),
                ),
              ),
            ),
          const SizedBox(height: 20),
          if (widget.RecordID == UserID)
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _getDatasStream(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final data = snapshot.data!.docs;
                  final columns = [
                    DataColumn(label: Text('Order ID')),
                    DataColumn(label: Text('User ID')),
                    DataColumn(label: Text('User Email')),
                    DataColumn(label: Text('Product ID')),
                    DataColumn(label: Text('Product Name')),
                    DataColumn(label: Text('Product Price')),
                    DataColumn(label: Text('Seller')),
                    DataColumn(label: Text('Order Status')),
                    DataColumn(label: Text('Change Order Status')),
                  ];
                  final rows = data
                      .where((doc) => doc['Seller'] == UserEmail)
                      .map((doc) => DataRow(cells: [
                    DataCell(Text(doc['OrderID'])),
                    DataCell(Text(doc['UserID'])),
                    DataCell(Text(doc['UserEmail'])),
                    DataCell(Text(doc['ProductID'])),
                    DataCell(Text(doc['ProductName'])),
                    DataCell(Text(doc['ProductPrice'])),
                    DataCell(Text(doc['Seller'])),
                    DataCell(Text(doc['OrderStatus'])),
                    DataCell(
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderStatusChange(
                                  OrderID:doc['OrderID']
                              ),
                            ),
                          );
                        },
                        child: Text('Change Order Status'),
                      ),
                    ),
                  ]))
                      .toList();
                  return Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: columns,
                        rows: rows,
                      ),
                    ),
                  );
                },
              ),
            ),
          if (widget.RecordID == UserEmail)
            Container(
              // Add a container to set the background color of the heading
              color: Colors.blue,
              child: Center(
                child: Text(
                  'Products',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Set the text color to white
                  ),
                ),
              ),
            ),
          const SizedBox(height: 20),
          if (widget.RecordID == UserEmail)
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _getDataaStream(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final data = snapshot.data!.docs;
                  final columns = [
                    DataColumn(label: Text('Product ID')),
                    DataColumn(label: Text('Product Name')),
                    DataColumn(label: Text('Product Price')),
                    DataColumn(label: Text('Gender')),
                    DataColumn(label: Text('Description')),
                    DataColumn(label: Text('Delete Product')),
                  ];
                  final rows = data
                      .where((doc) => doc['Seller'] == UserEmail)
                      .map((doc) => DataRow(cells: [
                    DataCell(Text(doc['Link'])),
                    DataCell(Text(doc['Name'])),
                    DataCell(Text(doc['Full_prices'])),
                    DataCell(Text(doc['Gender'])),
                    DataCell(Text(doc['Description'])),
                    DataCell(
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DeleteProductChange(
                                  OrderID:doc['Link']
                              ),
                            ),
                          );
                        },
                        child: Text('Delete Product'),
                      ),
                    ),
                  ]))
                      .toList();
                  return Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: columns,
                        rows: rows,
                      ),
                    ),
                  );
                },
              ),
            ),
          if (widget.RecordID == UserID)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Brand_Ambassador(),
                      ),
                    );
                  },
                  child: Text('Go Back'),
                ),
              ],
            ),
          if (widget.RecordID == '04')
            Container(
              // Add a container to set the background color of the heading
              color: Colors.blue,
              child: Center(
                child: Text(
                  'Orders',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Set the text color to white
                  ),
                ),
              ),
            ),
          const SizedBox(height: 20),
          if (widget.RecordID == '04')
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _getDatasStream(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final data = snapshot.data!.docs;
                  final columns = [
                    DataColumn(label: Text('User ID')),
                    DataColumn(label: Text('User Email')),
                    DataColumn(label: Text('Product ID')),
                    DataColumn(label: Text('Product Name')),
                    DataColumn(label: Text('Product Price')),
                    DataColumn(label: Text('Seller')),
                    DataColumn(label: Text('Order Status')),
                  ];
                  final rows = data
                      .map((doc) => DataRow(cells: [
                    DataCell(Text(doc['UserID'])),
                    DataCell(Text(doc['UserEmail'])),
                    DataCell(Text(doc['ProductID'])),
                    DataCell(Text(doc['ProductName'])),
                    DataCell(Text(doc['ProductPrice'])),
                    DataCell(Text(doc['Seller'])),
                    DataCell(Text(doc['OrderStatus'])),
                  ]))
                      .toList();
                  return Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: columns,
                        rows: rows,
                      ),
                    ),
                  );
                },
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if(my_role=='Admin')
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Admin(),
                      ),
                    );
                  },
                  child: Text('Go Back'),
                ),
              if(my_role=='Employee')
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Employee(),
                      ),
                    );
                  },
                  child: Text('Go Back'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
