import 'package:flutter/material.dart';
import 'package:shoescannerapp/Layout/Colors.dart';
import 'package:shoescannerapp/Screens/Employee.dart';
import 'package:shoescannerapp/Screens/Home_Page.dart';
import 'Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupBA extends StatefulWidget {
  static const String id = 'SignUpBA';

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<SignupBA> {
  final _auth = FirebaseAuth.instance;
  List<String> _roles = [
    'Brand Ambassador',
  ];
  String _selectedRole = 'Brand Ambassador'; // Add this variable
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _CompanyController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _fnameController,
                          decoration: InputDecoration(
                            hintText: 'First Name',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _lnameController,
                          decoration: InputDecoration(
                            hintText: 'Last Name',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _CompanyController,
                    decoration: InputDecoration(
                      hintText: 'Company Name',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
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
                      if (value.length < 8) {
                        return 'Password should be at least 8 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
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
                        try {
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .createUserWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                          // Update display name
                          await userCredential.user!.updateDisplayName(
                              '${_fnameController.text} ${_lnameController.text}');
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(_emailController.text)
                              .set({
                            'fname': _fnameController.text,
                            'lname': _lnameController.text,
                            'email': _emailController.text,
                            'password': _passwordController.text,
                            'company': _CompanyController.text,
                            'role': _selectedRole,
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Employee()),
                          );

                          // Send email verification
                          await userCredential.user!.sendEmailVerification();
                          // Show success dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text('Account Created'),
                              content: Text(
                                  'Your account has been created successfully.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Employee()),
                                    );
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                        on FirebaseAuthException catch (e) {
                          // Show error dialog
                          if (e.code == 'weak-password') {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text('Weak Password'),
                                content:
                                    Text('The password provided is too weak.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'OK'),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          } else if (e.code == 'email-already-in-use') {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text('Email Already in Use'),
                                content: Text(
                                    'The email address is already in use by another account.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Employee()),
                                      );
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            print(e);
                          }
                        } catch (e) {
                          print(e);
                        }
                      }
                    },
                    child: const Text('Sign Up'),
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
