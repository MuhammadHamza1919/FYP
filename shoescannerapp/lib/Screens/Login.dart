import 'package:flutter/material.dart';
import 'package:shoescannerapp/Screens/Welcome_Screen.dart';
import '../Layout/Colors.dart';
import 'Home_Page.dart';
import 'Login.dart';
import 'SignUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatefulWidget {
  static const String id = 'Login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {
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
              // wrap the contents with a Form widget
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                    ),
                    onChanged: (value) {
                      _emailController.text = value.toLowerCase();
                      _emailController.selection = TextSelection.fromPosition(
                          TextPosition(offset: _emailController.text.length));
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: 'Password',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    items: _roles.map((role) {
                      return DropdownMenuItem<String>(
                        value: role,
                        child: Text(role),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedRole = value!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Role',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // validate the Form before proceeding
                        try {
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
                                    title: const Text(
                                        'User Credential Donot Match'),
                                    content:
                                        Text('User Credential Donot Match'),
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
                      }
                    },
                    child: const Text('Login'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        final emailController = 'anonymous@user.com';
                        final passwordController = 'Anonymoususer';
                        final selectedRole = 'User';
                        UserCredential userCredential =
                            await _auth.signInWithEmailAndPassword(
                              email: emailController,
                              password: passwordController,
                        );
                        if (userCredential.user != null) {
                          DocumentSnapshot userSnapshot =
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(emailController)
                                  .get();
                          Map<String, dynamic>? userData =
                              userSnapshot.data() as Map<String, dynamic>?;
                          String? userRole = userData?['role'];

                          print('userSnapshot = ${userSnapshot}');
                          String? userEmail = userData?['email'] as String?;
                          String? userPassword =
                              userData?['password'] as String?;

                          if (userRole == selectedRole &&
                              userEmail == emailController &&
                              userPassword == passwordController) {
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Signup()),
                          );
                          // Add code to navigate to the sign-up page
                        },
                        child: Text(
                          ' Sign up now',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
