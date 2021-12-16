import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamicrouteplanner/FirebaseAuthAPI/ProxyAuthAPI.dart';
import 'package:dynamicrouteplanner/Screens/Driver/DriverScreen.dart';
import 'package:dynamicrouteplanner/Screens/Login/components/background.dart';
import 'package:dynamicrouteplanner/Screens/Passenger/PassengerScreen.dart';
import 'package:dynamicrouteplanner/components/rounded_button.dart';
import 'package:dynamicrouteplanner/components/rounded_input_field.dart';
import 'package:dynamicrouteplanner/components/rounded_phone_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dynamicrouteplanner/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TypeAsker extends StatelessWidget
{
  String _phoneNumber;
  String _nickName;
  DRPAuthAPI _API;

  TypeAsker() {
      this._phoneNumber = "";
      this._nickName = "";
      this._API = DRPAuthAPI();
      if (_isPassenger() != null) {
        print("go to passenger");
      }
      if (_isDriver() != null) {
        print("go to driver");
      }
      
      FirebaseFirestore.instance.collection('Drivers').doc("eYvBdhtz7UQiOQQRsNgiZWJDVYn1").snapshots().listen((event) {
          print("ozannyesiller@gmail.com değişti");
      });
  }

  Future<bool> _isDriver() async {

    bool returnVal = false;
    await FirebaseFirestore.instance.collection('Drivers').doc(FirebaseAuth.instance.currentUser.uid).get().then((value) => {
      if (value.data() == null) {
        returnVal = false
      } else {
        returnVal = true
      }
    });

    if (returnVal) {
      return true;
    }
    return null;
  }

  Future<bool> _isPassenger() async {

    bool returnVal = false;
    await FirebaseFirestore.instance.collection('Passengers').doc(FirebaseAuth.instance.currentUser.uid).get().then((value) => {
      if (value.data() == null) {
        returnVal = false
      } else {
        returnVal = true
      }
    });

    if (returnVal) {
      return true;
    }
    return null;
  }

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
                    hintText: "Your Nickname",
                    onChanged: (value) {
                      _nickName = value;
                    },
                  ),
                  RoundedPhoneField(
                    onChanged: (value) {
                      _phoneNumber = value;
                    },
                  ),
                  RoundedButton(
                    text: "Passenger",
                    press: () async {
                      if (_nickName == "" || _phoneNumber == "") {
                        Fluttertoast.showToast(
                            msg: "Name or phone label can not be empty",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      } else {
                        await _API.addPassenger(
                            {
                              "name" : this._nickName,
                              "phone" : this._phoneNumber,
                              "lat" : 0.toDouble(),
                              "lng" : 0.toDouble(),
                              "incoming" : false,
                              "busID" : 0,
                              "UUID" : FirebaseAuth.instance.currentUser.uid,
                              "email" : FirebaseAuth.instance.currentUser.email
                            }
                        );
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Passenger()), ModalRoute.withName("/Home"));
                      }
                    },
                  ),
                  RoundedButton(
                    text: "Driver",
                    color: kPrimaryLightColor,
                    textColor: Colors.black,
                    press: () async {
                      if (_nickName == "" || _phoneNumber == "") {
                        Fluttertoast.showToast(
                            msg: "Name or phone label can not be empty",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      } else {
                        List emptyList = List.empty();
                        await _API.addDriver(
                            {
                              "name" : this._nickName,
                              "phone" : this._phoneNumber,
                              "lat" : 0.toDouble(),
                              "lng" : 0.toDouble(),
                              "incomingList" : emptyList,
                              "busID" : 0,
                              "UUID" : FirebaseAuth.instance.currentUser.uid,
                              "email" : FirebaseAuth.instance.currentUser.email
                            }
                        );
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Driver()), ModalRoute.withName("/Home"));
                      }
                    },
                  ),
                ],
              ),
            ),
          )
      );
  }
}