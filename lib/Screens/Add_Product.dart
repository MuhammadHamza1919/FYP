import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'Brand_Ambassador.dart';
import 'package:shoescannerapp/Layout/Colors.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Add_Product extends StatefulWidget {
  static const String id = 'Add_Product';

  @override
  _Add_ProductState createState() => _Add_ProductState();
}

class _Add_ProductState extends State<Add_Product> {

  String uniqueId = Uuid().v4();
  final _formKey = GlobalKey<FormState>();
  String Seller = '';
  late TextEditingController _productDescription = TextEditingController();
  late TextEditingController _productName = TextEditingController();
  late TextEditingController _productPrice = TextEditingController();
  late TextEditingController _availableColors = TextEditingController();
  final List<String> _gender = [
    'Men',
    'Women',
    'Kid',
    'Big kid',
    'Little kid',
    'Toddler kid'
  ];
  final List<String> _SP_Filter = ['sale under 70', 'Best', 'sale under 100','New'];
  final List<String> _Type = [
    'LifeStyle shoes',
    'Jordan Shoes',
    'Air Max Shoes',
    'Air Force 1 Shoes',
    'Lion Shoes',
    ''
  ];
  String Company = ''; // Add this variable
  String _selectedGender = 'Men'; // Add this variable
  String _selectedSP_Filter = 'sale under 70'; // Add this variable
  String _selectedType = 'Jordan Shoes'; // Add this variable

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    final User? user = _auth.currentUser;
    setState(() {
      Seller = user!.email!;
      print(Seller);
    });
    final userDoc =
    await FirebaseFirestore.instance.collection('users').doc(Seller).get();
    if (userDoc.exists) {
      setState(() {
        Company = userDoc.data()?['company'] ?? '';
        print(Company);
      });
    };
  }
  File? _image;
  String? _imageUrl;

  Future<void> _uploadImage() async {
    if (_image != null) {
      // Create a unique filename for the image
      String fileName =
          DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';

      // Create a reference to the file in Firebase Storage
      Reference ref = _storage.ref().child('images/$fileName');

      // Upload the file to Firebase Storage
      UploadTask task = ref.putFile(_image!);

      // Wait for the upload to complete and get the download URL
      _imageUrl = await (await task).ref.getDownloadURL();

      // Navigate to the next screen
      print('Upload Image Called');
      if (_formKey.currentState != null) {
        _formKey.currentState!.save();
        // do something with the form data, such as submitting to a backend API
        await FirebaseFirestore.instance
            .collection('All Data')
            .doc(uniqueId)
            .set({
          'Color': _availableColors.text,
          'Company': Company,
          'Description': _productDescription.text,
          'Full_prices': _productPrice.text,
          'Gender': _selectedGender,
          'Image': _imageUrl,
          'Link': uniqueId,
          'Name': _productName.text,
          'Type': _selectedType,
          'Sp_filter': _selectedSP_Filter,
          'Seller':Seller,
        });
        print('Uploaded data');
        Navigator.pushNamed(context, Brand_Ambassador.id);
      }
    }
  }

  Future<void> _getImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
          print('image selected.');
          print(_image);
        } else {
          print('No image selected.');
        }
      });
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product to $Company Company'),
        leading: InkWell(
          onTap: () {
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
      body: Center(
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: SizeChangedLayoutNotifier(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _productName,
                      decoration: InputDecoration(
                        hintText: 'Product Name',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _availableColors,
                      decoration: InputDecoration(
                        hintText: 'Available Colors',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the Available Colors';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _productPrice,
                      decoration: InputDecoration(
                        hintText: 'Product Price',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the Product Price';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _productDescription,
                      decoration: InputDecoration(
                        hintText: 'Product Description',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the Product Description';
                        }
                        return null;
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedGender,
                            items: _gender.map((gender) {
                              return DropdownMenuItem<String>(
                                value: gender,
                                child: Text(gender),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                _selectedGender = value!;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Gender',
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedType,
                            items: _Type.map((type) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                _selectedType = value!;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Type',
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedSP_Filter,
                            items: _SP_Filter.map((sp_filter) {
                              return DropdownMenuItem<String>(
                                value: sp_filter,
                                child: Text(sp_filter),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                _selectedSP_Filter = value!;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Special Filter',
                            ),
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_image != null)
                            Image.file(
                              _image!,
                              height: 200,
                            ),
                          Column(
                            children: [
                              Expanded(
                                child: Center(
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                                    ),
                                    onPressed: _getImage,
                                    child: Text('Select Image'),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: ElevatedButton(
                                    onPressed: _uploadImage,
                                    child: Text('Submit Form'),
                                  ),
                                ),
                              ),
                            ],
                          )

                        ],
                      ),
                    ),
                    Expanded(child: Row(
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
                    ),)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
