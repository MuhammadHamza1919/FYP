import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../All_Data.dart';
import '../Layout/Colors.dart';
import 'Home_Page.dart';
import 'Login.dart';
import 'Product.dart';

class Filters extends StatefulWidget {
  static const String id = 'FiltersPage';
  final String FilterID;

  const Filters({
    Key? key,
    required this.FilterID,
  }) : super(key: key);

  @override
  State<Filters> createState() => _filtersState();
}

class _filtersState extends State<Filters> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<All_Data>>(
      future: readFirestoreData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          final productData = data.firstWhere(
            (item) =>
                item.Sp_Filter != widget.FilterID ||
                item.Gender != widget.FilterID,
            orElse: () => All_Data(),
          );
          return LayoutBuilder(builder: (context, constraints) {
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
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
                      if (widget.FilterID == 'Kid' ||
                          widget.FilterID == 'Men' ||
                          widget.FilterID == 'Women' ||
                          widget.FilterID == 'New')
                        Container(
                          height: constraints.maxHeight,
                          child: GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: data
                                .where((product) =>
                                    product.Sp_Filter == widget.FilterID ||
                                    product.Gender == widget.FilterID)
                                .length,
                            itemBuilder: (context, index) {
                              final filteredData = data
                                  .where((product) =>
                                      product.Sp_Filter == widget.FilterID ||
                                      product.Gender == widget.FilterID)
                                  .toList();
                              final product = filteredData[index];

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
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              '\$ ${product.Full_prices.toString()}',
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
                      if (widget.FilterID != 'Kid' &&
                          widget.FilterID != 'Men' &&
                          widget.FilterID != 'Women' &&
                          widget.FilterID != 'New')
                        Container(
                          height: constraints.maxHeight,
                          child: GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: data
                                .where((product) =>
                                    double.parse(product.Full_prices!) <=
                                    double.parse(widget.FilterID))
                                .length,
                            itemBuilder: (context, index) {
                              final filteredData = data
                                  .where((product) =>
                                      double.parse(product.Full_prices!) <=
                                      double.parse(widget.FilterID))
                                  .toList();
                              final product = filteredData[index];

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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              '\$ ${product.Full_prices.toString()}',
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
        await FirebaseFirestore.instance.collection('All Data').get();
    return snapshot.docs
        .map((doc) => All_Data.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
