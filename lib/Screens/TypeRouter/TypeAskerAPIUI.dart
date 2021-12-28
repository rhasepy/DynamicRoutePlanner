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
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TypeAsker extends StatefulWidget {
  @override
  _TypeAsker createState() => _TypeAsker();
}

class _TypeAsker extends State<TypeAsker>
{
  String _phoneNumber;
  String _nickName;
  DRPAuthAPI _API;
  bool stayScreen;

  _TypeAsker() {
    this._phoneNumber = "";
    this._nickName = "";
    this._API = DRPAuthAPI();
    this.stayScreen = false;
  }

  void tryApply(Map<String, dynamic> user) {
    try {
      if (user.containsKey("incomingList")) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Driver()), ModalRoute.withName("/Home"));
      }
      else if (user.containsKey("incoming")) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Passenger()), ModalRoute.withName("/Home"));
      }
    } catch (e) {}
  }

  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await FirebaseFirestore.instance.collection('Drivers').doc(FirebaseAuth.instance.currentUser.uid).get().then((value) =>
          tryApply(value.data()));
      setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await FirebaseFirestore.instance.collection('Passengers').doc(FirebaseAuth.instance.currentUser.uid).get().then((value) =>
          tryApply(value.data()));
      setState(() {
        stayScreen = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

      if (stayScreen == false) {
        return Scaffold();
      } else {
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
}