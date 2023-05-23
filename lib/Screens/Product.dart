import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoescannerapp/Screens/User_Cart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import '../All_Data.dart';
import '../Layout/Colors.dart';
import 'Filters.dart';
import 'Home_Page.dart';
import 'Login.dart';

class Product extends StatefulWidget {
  static const String id = 'ProductPage';
  final String productUrl;
  const Product({
    Key? key,
    required this.productUrl,
  }) : super(key: key);

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  String UserID = '';
  String UserEmail = '';
  String ProductID = '';
  String my_role = '';
  String seller ='';
  String ProductName ='';
  String ImageUrl ='';
  String ProductPrice ='';
  String orderId= Uuid().v4();
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
    final userDocs =await FirebaseFirestore.instance.collection('users').doc(UserEmail).get();
    if (userDocs.exists) {
      setState(() {
        my_role = userDocs.data()?['role'] ?? '';
        print(my_role);
      });
    };
    print(widget.productUrl);
    final userDoc = await FirebaseFirestore.instance.collection('All Data').doc(widget.productUrl).get();
    if (userDoc.exists) {
      setState(() {
        print(userDoc);
        seller = userDoc.data()?['Seller'];
        ProductPrice = userDoc.data()?['Full_prices'];
        ProductName = userDoc.data()?['Name'];
        ImageUrl = userDoc.data()?['Image'];
        print(seller);
      });
    }
  }

  void addToCart() async {
    await FirebaseFirestore.instance.collection('Cart').doc(orderId).set({
      'OrderID' : orderId,
      'UserID': UserID,
      'UserEmail': UserEmail,
      'ProductID': widget.productUrl,
      'ProductName':ProductName,
      'ProductPrice': ProductPrice,
      'ImageUrl': ImageUrl,
      'Seller': seller.toString(),
      'OrderStatus': 'Pending',
    });
    await FirebaseFirestore.instance.collection('Orders').doc(orderId).set({
      'OrderID' : orderId,
      'UserID': UserID,
      'UserEmail': UserEmail,
      'ProductID': widget.productUrl,
      'ProductName':ProductName,
      'ProductPrice': ProductPrice,
      'ImageUrl': ImageUrl,
      'Seller': seller.toString(),
      'OrderStatus': 'Pending',
    });
    Navigator.pushNamed(context, User_Cart.id);
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<All_Data>>(
      future: readFirestoreData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          final productData = data.firstWhere(
                (item) => item.Link == widget.productUrl,
            orElse: () => All_Data(),
          );
          return LayoutBuilder(builder: (context, constraints) {
            return Scaffold(
              appBar: AppBar(
                title: Text(productData.Name.toString()),
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
              body: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 300,
                      child: PageView.builder(
                        itemBuilder: (context, index) {
                          return Image.network(
                            productData.Image.toString(),
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productData.Name.toString(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            productData.Gender.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Price: ${productData.Full_prices.toString()}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Colors Available: ${productData.Color}',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            productData.Description.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (productData.Seller=='01')
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (await canLaunch(productData.Link.toString())) {
                                        await launch(productData.Link.toString());
                                      }
                                    },
                                    child: const Text('Go To Website Now'),
                                  ),
                                ),
                              if(productData.Seller!='01' && my_role == 'Customer')
                                Center(
                                  child: ElevatedButton(
                                    onPressed: addToCart,
                                    child: const Text('Buy Now'),
                                  ),
                                ),
                              const SizedBox(width: 10),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Recommended Products',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(HomePage.id);
                            },
                            child: const Text(
                              'View All',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 250,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final product = data[index];
                          if (product.Type != productData.Type) {
                            return SizedBox.shrink(); // Skip items with different types
                          }
                          if (product.Link == widget.productUrl) {
                            return const SizedBox.shrink();
                          }
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Product(
                                    productUrl: product.Link.toString(),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: 200,
                              margin: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Image.network(
                                      product.Image.toString(),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.Name.toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          product.Gender.toString(),
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${product.Full_prices.toString()}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            );
          });
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error Occured'),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
  Future<List<All_Data>> readFirestoreData() async {
    final QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('All Data')
    .get();
    return snapshot.docs
        .map((doc) => All_Data.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }
}

