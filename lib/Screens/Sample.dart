import 'package:flutter/material.dart';
import 'package:shoescannerapp/Screens/Welcome_Screen.dart';
import '../Layout/Colors.dart';
import 'Home_Page.dart';
import 'Login.dart';
import 'SignUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Sample extends StatefulWidget {
  static const String id = 'Sample';

  @override
  _SamplePageState createState() => _SamplePageState();
}

class _SamplePageState extends State<Sample> {
  final _auth = FirebaseAuth.instance;
  List<String> _roles = [
    'Customer',
    'Admin',
    'Employee',
    'Brand Ambassador',
  ];
  String _selectedRole = 'Customer';
  final _formKey = GlobalKey<FormState>(); // add global key for the Form
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              // wrap the contents with a Form widget
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        _emailController.text = 'admin1@shoescanner.com';
                        _passwordController.text = 'Admin1234';
                        _selectedRole = 'Admin';
                        UserCredential userCredential =
                            await _auth.signInWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text,
                        );
                        if (userCredential.user != null) {
                          DocumentSnapshot userSnapshot =
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(_emailController.text)
                                  .get();
                          Map<String, dynamic>? userData =
                              userSnapshot.data() as Map<String, dynamic>?;
                          String? userRole = userData?['role'];

                          print('userSnapshot = ${userSnapshot}');
                          String? userEmail = userData?['email'] as String?;
                          String? userPassword =
                              userData?['password'] as String?;

                          if (userRole == _selectedRole &&
                              userEmail == _emailController.text &&
                              userPassword == _passwordController.text) {
                            Navigator.pushNamed(context, HomePage.id);
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title:
                                      const Text('User Credential Donot Match'),
                                  content: Text('User Credential Donot Match'),
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
                        }
                      } on FirebaseAuthException catch (e) {
                        String errorMessage = '';
                        if (e.code == 'user-not-found') {
                          errorMessage = 'No user found for that email.';
                        } else if (e.code == 'wrong-password') {
                          errorMessage =
                              'Wrong password provided for that user.';
                        }
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Login Error'),
                              content: Text(errorMessage),
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
                    child: const Text('Login As Administrator'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        _emailController.text = 'employee1@shoescanner.com';
                        _passwordController.text = 'Employee1234';
                        _selectedRole = 'Employee';
                        UserCredential userCredential =
                            await _auth.signInWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text,
                        );
                        if (userCredential.user != null) {
                          DocumentSnapshot userSnapshot =
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(_emailController.text)
                                  .get();
                          Map<String, dynamic>? userData =
                              userSnapshot.data() as Map<String, dynamic>?;
                          String? userRole = userData?['role'];

                          print('userSnapshot = ${userSnapshot}');
                          String? userEmail = userData?['email'] as String?;
                          String? userPassword =
                              userData?['password'] as String?;

                          if (userRole == _selectedRole &&
                              userEmail == _emailController.text &&
                              userPassword == _passwordController.text) {
                            Navigator.pushNamed(context, HomePage.id);
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title:
                                      const Text('User Credential Donot Match'),
                                  content: Text('User Credential Donot Match'),
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
                        }
                      } on FirebaseAuthException catch (e) {
                        String errorMessage = '';
                        if (e.code == 'user-not-found') {
                          errorMessage = 'No user found for that email.';
                        } else if (e.code == 'wrong-password') {
                          errorMessage =
                              'Wrong password provided for that user.';
                        }
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Login Error'),
                              content: Text(errorMessage),
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
                    child: const Text('Login As Employee'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        _emailController.text = 'brandambassador1@shoescanner.com';
                        _passwordController.text = 'Brandambassador1234';
                        _selectedRole = 'Brand Ambassador';
                        UserCredential userCredential =
                            await _auth.signInWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text,
                        );
                        if (userCredential.user != null) {
                          DocumentSnapshot userSnapshot =
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(_emailController.text)
                                  .get();
                          Map<String, dynamic>? userData =
                              userSnapshot.data() as Map<String, dynamic>?;
                          String? userRole = userData?['role'];

                          print('userSnapshot = ${userSnapshot}');
                          String? userEmail = userData?['email'] as String?;
                          String? userPassword =
                              userData?['password'] as String?;

                          if (userRole == _selectedRole &&
                              userEmail == _emailController.text &&
                              userPassword == _passwordController.text) {
                            Navigator.pushNamed(context, HomePage.id);
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title:
                                      const Text('User Credential Donot Match'),
                                  content: Text('User Credential Donot Match'),
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
                        }
                      } on FirebaseAuthException catch (e) {
                        String errorMessage = '';
                        if (e.code == 'user-not-found') {
                          errorMessage = 'No user found for that email.';
                        } else if (e.code == 'wrong-password') {
                          errorMessage =
                              'Wrong password provided for that user.';
                        }
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Login Error'),
                              content: Text(errorMessage),
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
                    child: const Text('Login As Brand Ambassador'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        _emailController.text = 'user1@shoescanner.com';
                      _passwordController.text = 'User1234';
                        _selectedRole = 'Customer';
                        UserCredential userCredential =
                            await _auth.signInWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text,
                        );
                        if (userCredential.user != null) {
                          DocumentSnapshot userSnapshot =
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(_emailController.text)
                                  .get();
                          Map<String, dynamic>? userData =
                              userSnapshot.data() as Map<String, dynamic>?;
                          String? userRole = userData?['role'];

                          print('userSnapshot = ${userSnapshot}');
                          String? userEmail = userData?['email'] as String?;
                          String? userPassword =
                              userData?['password'] as String?;

                          if (userRole == _selectedRole &&
                              userEmail == _emailController.text &&
                              userPassword == _passwordController.text) {
                            Navigator.pushNamed(context, HomePage.id);
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title:
                                      const Text('User Credential Donot Match'),
                                  content: Text('User Credential Donot Match'),
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
                        }
                      } on FirebaseAuthException catch (e) {
                        String errorMessage = '';
                        if (e.code == 'user-not-found') {
                          errorMessage = 'No user found for that email.';
                        } else if (e.code == 'wrong-password') {
                          errorMessage =
                              'Wrong password provided for that user.';
                        }
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Login Error'),
                              content: Text(errorMessage),
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
                    child: const Text('Login As User'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        _emailController.text = 'anonymous@user.com';
                        _passwordController.text = 'Anonymoususer';
                        _selectedRole = 'User';
                        UserCredential userCredential =
                            await _auth.signInWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text,
                        );
                        if (userCredential.user != null) {
                          DocumentSnapshot userSnapshot =
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(_emailController.text)
                                  .get();
                          Map<String, dynamic>? userData =
                              userSnapshot.data() as Map<String, dynamic>?;
                          String? userRole = userData?['role'];

                          print('userSnapshot = ${userSnapshot}');
                          String? userEmail = userData?['email'] as String?;
                          String? userPassword =
                              userData?['password'] as String?;

                          if (userRole == _selectedRole &&
                              userEmail == _emailController.text &&
                              userPassword == _passwordController.text) {
                            Navigator.pushNamed(context, HomePage.id);
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title:
                                      const Text('User Credential Donot Match'),
                                  content: Text('User Credential Donot Match'),
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
                        }
                      } on FirebaseAuthException catch (e) {
                        String errorMessage = '';
                        if (e.code == 'user-not-found') {
                          errorMessage = 'No user found for that email.';
                        } else if (e.code == 'wrong-password') {
                          errorMessage =
                              'Wrong password provided for that user.';
                        }
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Login Error'),
                              content: Text(errorMessage),
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
                    child: const Text('Login As Anonymous User'),
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
