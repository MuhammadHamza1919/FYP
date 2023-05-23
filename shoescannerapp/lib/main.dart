import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoescannerapp/Screens/Add_Product.dart';
import 'package:shoescannerapp/Screens/Admin.dart';
import 'package:shoescannerapp/Screens/Brand_Ambassador.dart';
import 'package:shoescannerapp/Screens/Data_User.dart';
import 'package:shoescannerapp/Screens/Delete.dart';
import 'package:shoescannerapp/Screens/Employee.dart';
import 'package:shoescannerapp/Screens/Home_Page.dart';
import 'package:shoescannerapp/Screens/Indiv_chat.dart';
import 'package:shoescannerapp/Screens/Login.dart';
import 'package:shoescannerapp/Screens/ModifyAmin.dart';
import 'package:shoescannerapp/Screens/ModifyEmployee.dart';
import 'package:shoescannerapp/Screens/Product.dart';
import 'package:shoescannerapp/Screens/SignUp.dart';
import 'package:shoescannerapp/Screens/SignUpAdmin.dart';
import 'package:shoescannerapp/Screens/User_Cart.dart';
import 'package:shoescannerapp/Screens/Welcome_Screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Screens/Delete_Admin.dart';
import 'Screens/Delete_Brand_Ambassador.dart';
import 'Screens/Delete_Employee.dart';
import 'Screens/Filters.dart';
import 'Screens/Record_Management.dart';
import 'Screens/Sample.dart';
import 'Screens/SignUpEmployee.dart';
import 'Screens/SignUp_Brand_Ambassador.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Shoe Scanner',
        initialRoute: Welcome.id,
        routes: {
          Welcome.id : (context) => Welcome(),
          Sample.id : (context) => Sample(),
          HomePage.id : (context) => HomePage(),
          Login.id : (context) => Login(),
          Signup.id : (context) => Signup(),
          SignupAdmin.id : (context) => SignupAdmin(),
          SignupBA.id : (context) => SignupBA(),
          SignupEmployee.id : (context) => SignupEmployee(),
          Data_User.id : (context) => Data_User(),
          User_Cart.id :(context)=> User_Cart(),
          Indiv_chat.id :(context)=> Indiv_chat(),
          Brand_Ambassador.id :(context)=> Brand_Ambassador(),
          Add_Product.id :(context)=> Add_Product(),
          Employee.id :(context)=> Employee(),
          Admin.id :(context)=> Admin(),
          Delete.id : (context)=> Delete(),
          Delete_Admin.id : (context)=> Delete_Admin(),
          Modify.id : (context)=> Modify(),
          Delete_Brand_Ambassador.id : (context)=> Delete_Brand_Ambassador(),
          Delete_Employee.id : (context)=> Delete_Employee(),
          ModifyE.id : (context)=> ModifyE(),
        },
    );
  }
}
