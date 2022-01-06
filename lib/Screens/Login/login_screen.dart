import 'package:dynamicrouteplanner/StaticConstants/constants.dart';
import 'package:flutter/material.dart';
import 'package:dynamicrouteplanner/Screens/Login/components/body.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    driver = null;
    student = null;

    return Scaffold(
      body: Body(),
    );
  }
}
