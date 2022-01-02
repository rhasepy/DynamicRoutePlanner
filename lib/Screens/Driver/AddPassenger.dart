import 'package:dynamicrouteplanner/FirebaseAuthAPI/ProxyAuthAPI.dart';
import 'package:dynamicrouteplanner/Screens/Driver/DriverScreen.dart';
import 'package:dynamicrouteplanner/Screens/Login/components/background.dart';
import 'package:dynamicrouteplanner/components/rounded_button.dart';
import 'package:dynamicrouteplanner/components/rounded_input_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddPassenger extends StatelessWidget {

  AddPassenger({Key key}) : super(key: key);

  String _email = "";
  DRPAuthAPI API = DRPAuthAPI();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.black,
        body: Background(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RoundedInputField(
                  hintText: "Passenger Mail",
                  onChanged: (value) {
                      _email = value;
                  },
                ),
                RoundedButton(
                  text: "Add Passenger",
                  press: () async {
                      await API.DRIVER_addPassenger(_email);
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Driver()), ModalRoute.withName("/Home"));
                  },
                ),
              ],
            ),
          ),
        )
    );
  }
}
