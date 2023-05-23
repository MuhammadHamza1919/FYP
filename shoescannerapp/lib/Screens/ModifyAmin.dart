import 'package:flutter/material.dart';
import 'package:shoescannerapp/Layout/Colors.dart';
import 'package:shoescannerapp/Screens/Home_Page.dart';
import 'Admin.dart';
import 'Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Modify extends StatefulWidget {
  static const String id = 'Modify';

  @override
  _DeleteState createState() => _DeleteState();
}

class _DeleteState extends State<Modify> {
  final _auth = FirebaseAuth.instance;
  List<String> _roles = [
    'Admin',
  ];
  String _selectedRole = 'Admin'; // Add this variable
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _newemail = TextEditingController();
  final TextEditingController _newpassword = TextEditingController();
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
      body: SingleChildScrollView(
        child: Center(
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
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Old Email',
                      ),
                      onChanged: (value) {
                        _emailController.text = value.toLowerCase();
                        _emailController.selection = TextSelection.fromPosition(
                            TextPosition(offset: _emailController.text.length));
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter old email';
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
                        hintText: 'Old Password',
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter old password';
                        }
                        if (value.length < 8) {
                          return 'Password should be at least 8 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
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
                                return 'Please enter your new name';
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
                      keyboardType: TextInputType.emailAddress,
                      controller: _newemail,
                      decoration: InputDecoration(
                        hintText: 'New Email',
                      ),
                      onChanged: (value) {
                        _newemail.text = value.toLowerCase();
                        _newemail.selection = TextSelection.fromPosition(
                            TextPosition(offset: _newemail.text.length));
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter new email';
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
                      controller: _newpassword,
                      decoration: InputDecoration(
                        hintText: 'New Password',
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter new password';
                        }
                        if (value.length < 8) {
                          return 'Password should be at least 8 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
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

                              if (userEmail == _emailController.text &&
                                  userPassword == _passwordController.text) {
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(_emailController.text)
                                    .update({
                                  'fname': _fnameController.text,
                                  'lname': _lnameController.text,
                                  'role': _selectedRole,
                                  'email': _newemail.text,
                                  'password': _newpassword.text
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Admin()),
                                );
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    title: Text('Account Modified'),
                                    content: Text(
                                        'Your account has been Modified successfully.'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Admin()),
                                          );
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
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
                      child: const Text('Update Record'),
                    ),
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
