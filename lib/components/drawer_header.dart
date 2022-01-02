import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyHeaderDrawer extends StatefulWidget {
  const MyHeaderDrawer({Key key}) : super(key: key);

  @override
  _MyHeaderDrawerState createState() => _MyHeaderDrawerState();
}

class _MyHeaderDrawerState extends State<MyHeaderDrawer>
{
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent[700],
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.only(top: 70.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/icons/Main.png'),
              ),
            ),
          ),
          Text(FirebaseAuth.instance.currentUser.email.toString(), style: TextStyle(color: Colors.white, fontSize: 20),),
        ],
      ),
    );
  }
}
