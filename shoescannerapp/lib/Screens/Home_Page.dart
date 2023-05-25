import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:shoescannerapp/All_Data.dart';
import 'package:shoescannerapp/Screens/Admin.dart';
import 'package:shoescannerapp/Screens/Brand_Ambassador.dart';
import 'package:shoescannerapp/Screens/Data_User.dart';
import 'package:shoescannerapp/Screens/Delete.dart';
import 'package:shoescannerapp/Screens/Delete_Admin.dart';
import 'package:shoescannerapp/Screens/Delete_Brand_Ambassador.dart';
import 'package:shoescannerapp/Screens/Delete_Employee.dart';
import 'package:shoescannerapp/Screens/Employee.dart';
import 'package:shoescannerapp/Screens/Indiv_chat.dart';
import 'package:shoescannerapp/Screens/Product.dart';
import 'package:shoescannerapp/Screens/Sample.dart';
import 'package:shoescannerapp/Screens/User_Cart.dart';
import 'package:shoescannerapp/Screens/Welcome_Screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Layout/Colors.dart';
import 'Filters.dart';
import 'Login.dart';
import 'package:flutter/services.dart' as rootbundle;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  static const String id = 'Home_Page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String _userId;
  String firstName = '';
  String lastName = '';
  String email = '';
  String password = '';
  String my_role = '';
  String price = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;

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
      email = user!.email!;
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
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'logo',
                child: Container(
                  child: Image.asset(
                    'assets/images/Logo.png',
                    height: 50,
                    width: 50,
                  ),
                ),
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
                          fontFamily: 'Times New Roman',
                        ),
                      ),
                      TextSpan(
                        text: ' Scanner',
                        style: TextStyle(
                          color: AppColor.secondary,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Times New Roman',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/images/user.png'),
                      backgroundColor: Colors.white,
                      radius: 50.0,
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      '$firstName $lastName',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(height: 8.0),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
                title: Text('Home Page'),
                onTap: () {
                  Navigator.pushNamed(context, HomePage.id);
                }),
            if (my_role != 'User')
              ListTile(
                  title: Text('User Page'),
                  onTap: () {
                    Navigator.pushNamed(context, Data_User.id);
                  }),
            if (my_role == 'Customer')
              ListTile(
                title: Text('Orders'),
                onTap: () {
                  Navigator.pushNamed(context, User_Cart.id);
                },
              ),
            if (my_role == 'User' ||
                my_role == 'Customer' ||
                my_role == 'Employee' ||
                my_role == 'Brand Ambassador')
              ListTile(
                title: Text('Live Help'),
                onTap: () {
                  Navigator.pushNamed(context, Indiv_chat.id);
                },
              ),
            if (my_role == 'Admin')
              ListTile(
                title: Text('Admin Page'),
                onTap: () {
                  Navigator.pushNamed(context, Admin.id);
                },
              ),
            if (my_role == 'Employee')
              ListTile(
                title: Text('Employee Page'),
                onTap: () {
                  Navigator.pushNamed(context, Employee.id);
                },
              ),
            if (my_role == 'Brand Ambassador')
              ListTile(
                title: Text('Brand Ambassador Page'),
                onTap: () {
                  Navigator.pushNamed(context, Brand_Ambassador.id);
                },
              ),
            if (my_role == 'Admin')
              ListTile(
                title: Text('Delete Account'),
                onTap: () {
                  _auth.signOut();
                  Navigator.pushNamed(context, Delete_Admin.id);
                },
              ),
            if (my_role == 'Customer')
              ListTile(
                title: Text('Delete Account'),
                onTap: () {
                  _auth.signOut();
                  Navigator.pushNamed(context, Delete.id);
                },
              ),
            if (my_role == 'Employee')
              ListTile(
                title: Text('Delete Account'),
                onTap: () {
                  _auth.signOut();
                  Navigator.pushNamed(context, Delete_Employee.id);
                },
              ),
            if (my_role == 'Brand Ambassador')
              ListTile(
                title: Text('Delete Account'),
                onTap: () {
                  _auth.signOut();
                  Navigator.pushNamed(context, Delete_Brand_Ambassador.id);
                },
              ),
            if (my_role == 'Admin' ||
                my_role == 'Customer' ||
                my_role == 'Employee' ||
                my_role == 'Brand Ambassador')
              ListTile(
                title: Text('Logout'),
                onTap: () {
                  _auth.signOut();
                  Navigator.pushNamed(context, Login.id);
                },
              ),
            if (my_role == 'User')
              ListTile(
                title: Text('Login Now'),
                onTap: () {
                  Navigator.pushNamed(context, Login.id);
                },
              ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Card(
                            elevation: 2,
                            child: MaterialButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Filters(
                                      FilterID: 'New',
                                    ),
                                  ),
                                );
                              },
                              child: Image.asset(
                                'assets/icons/Logo.png',
                                color: AppColor.secondary,
                                width: 20,
                                height: 20,
                              ),
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Card(
                            elevation: 2,
                            child: MaterialButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                          'Please Enter Your Maximum Price'),
                                      content: TextField(
                                        onChanged: (value) {
                                          price = value;
                                        },
                                      ),
                                      actions: [
                                        TextButton(
                                          child: Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text('OK'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Filters(
                                                  FilterID: price,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Image.asset(
                                'assets/icons/cheap.png',
                                color: AppColor.secondary,
                                width: 20,
                                height: 20,
                              ),
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Card(
                            elevation: 2,
                            child: MaterialButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Filters(
                                      FilterID: 'Kid',
                                    ),
                                  ),
                                );
                              },
                              child: Image.asset(
                                'assets/icons/kids_shoes.png',
                                color: AppColor.secondary,
                                width: 20,
                                height: 20,
                              ),
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Card(
                            elevation: 2,
                            child: MaterialButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Filters(
                                      FilterID: 'Men',
                                    ),
                                  ),
                                );
                              },
                              child: Image.asset(
                                'assets/icons/men_shoes.png',
                                color: AppColor.secondary,
                                width: 20,
                                height: 20,
                              ),
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Card(
                            elevation: 2,
                            child: MaterialButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Filters(
                                      FilterID: 'Women',
                                    ),
                                  ),
                                );
                              },
                              child: Image.asset(
                                'assets/icons/women_shoes.png',
                                color: AppColor.secondary,
                                width: 20,
                                height: 20,
                              ),
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 9,
            child: FutureBuilder(
              future: readFirestoreData(),
              builder: (context, data) {
                if (data.hasError) {
                  //in case if error found
                  return Center(child: Text("${data.error}"));
                } else if (data.hasData) {
                  //once data is ready this else block will execute
                  // items will hold all the data of DataModel
                  //items[index].name can be used to fetch name of product as done below
                  var items = data.data as List<All_Data>;
                  return GridView.builder(
                    shrinkWrap: true,
                    itemCount: items.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 1.3),
                    ),
                    itemBuilder: (context, index) {
                      if (items != null && index < items.length) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Product(
                                  productUrl: items[index].Link.toString(),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            child: Card(
                              elevation: 5,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Product(
                                                productUrl: items[index]
                                                    .Link
                                                    .toString(),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Image(
                                          image: NetworkImage(
                                              items[index].Image.toString()),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      child: Text(
                                        items[index].Name.toString(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      child: Text(
                                        items[index].Gender.toString(),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      child: Text(
                                        '\$ ${items[index].Full_prices}',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return SizedBox
                            .shrink(); // or any other fallback widget
                      }
                    },
                  );
                } else {
                  // show circular progress while data is getting fetched from json file
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<All_Data>> readFirestoreData() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('All Data').get();
    return snapshot.docs
        .map((doc) => All_Data.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
