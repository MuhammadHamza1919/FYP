import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shoescannerapp/Layout/Colors.dart';
import 'package:shoescannerapp/Screens/Home_Page.dart';
import 'package:shoescannerapp/Screens/Login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Sample.dart';

class Welcome extends StatefulWidget {
  static const String id = 'Welcome_Screen';
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );
    _animation = Tween<double>(begin: 4, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward().whenComplete(() {
      _controller.dispose();
      _navigatetohome();
    });
  }

  _navigatetohome() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _logoVisible = true;
    });
    await Future.delayed(Duration(seconds: 2));
    Navigator.pushNamed(context, Login.id);
  }

  bool _logoVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(
              opacity: _logoVisible ? 1 : 0,
              child: AnimatedContainer(
                duration: Duration(seconds: 1),
                width: _logoVisible ? 250 : 0,
                height: _logoVisible ? 250 : 0,
                child: Image(
                  image: AssetImage('assets/images/Logo.png'),
                ),
              ),
            ),
            SizedBox(height: 50),
            Text(
              '${_animation.value.toInt()}',
              style: TextStyle(
                fontSize: 48,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppColor.accent,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
