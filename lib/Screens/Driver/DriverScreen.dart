import 'package:dynamicrouteplanner/Screens/Login/components/background.dart';
import 'package:dynamicrouteplanner/components/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:dynamicrouteplanner/constants.dart';

class Driver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RoundedButton(
              text: "Driver",
              color: kPrimaryLightColor,
              textColor: Colors.black,
              press: () {
                print("Ben sürücüyüm");
              },
            ),
          ],
        ),
      ),
    );
  }
}