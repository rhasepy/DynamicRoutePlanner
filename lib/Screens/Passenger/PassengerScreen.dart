import 'package:dynamicrouteplanner/Screens/Login/components/background.dart';
import 'package:dynamicrouteplanner/components/rounded_button.dart';
import 'package:flutter/material.dart';

class Passenger extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RoundedButton(
              text: "Passenger",
              press: () {
                print("Ben Yolcuyum");
              },
            ),
          ],
        ),
      ),
    );
  }
}