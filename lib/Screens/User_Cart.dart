import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoescannerapp/All_Data.dart';

import 'Home_Page.dart';
import 'Product.dart';

class User_Cart extends StatefulWidget {
  static const String id = 'User_Cart';

  @override
  _UserCartState createState() => _UserCartState();
}

class _UserCartState extends State<User_Cart> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _userId = '';
  String _useremail = '';
  String _Product = '';
  String _Name = '';
  String _Image =
      'https://cdn.dribbble.com/users/429792/screenshots/3649946/no_order.png';
  String _Seller = '';
  String _Price = '';
  String _Description = '';
  String _Gender = '';
  String _OrderStatus = '';

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    final User? user = _auth.currentUser;
    setState(() {
      _userId = user!.uid;
      _useremail = user!.email!;
      print(_useremail);
    });
  }

  late CollectionReference _Cart =
      FirebaseFirestore.instance.collection('Cart');

  // Retrieve messages based on user role
  Stream<QuerySnapshot> _getDatasStream() {
    return _Cart.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
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

                return Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      final doc = data[index];

                      return Card(
                        child: ListTile(
                          leading: Image.network(
                            doc['ImageUrl'],
                            width: 50,
                            height: 50,
                          ),
                          title: Text(doc['ProductName']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Product Price: \$${doc['ProductPrice']}'),
                              Text(
                                'Order Status: ${doc['OrderStatus']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          trailing: ElevatedButton(
                            onPressed: () async {
                              if (doc['OrderStatus'] == 'Pending') {
                                await FirebaseFirestore.instance
                                    .collection('Cart')
                                    .doc(doc['OrderID'])
                                    .delete();
                                await FirebaseFirestore.instance
                                    .collection('Orders')
                                    .doc(doc['OrderID'])
                                    .delete();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => User_Cart()),
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title:
                                          const Text('Unable To Remove Order'),
                                      content: Text(
                                        'Your Order is already confirmed, so you cannot remove it.',
                                      ),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            child: const Text('Remove Order'),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
