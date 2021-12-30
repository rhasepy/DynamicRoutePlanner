import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class DRPAuthAPI
{
    CollectionReference _Passengercollection;
    CollectionReference _Drivercollection;

    FirebaseAuth _authProvider;
    Stream<User> get authStateChanges => _authProvider.authStateChanges();

    GoogleSignInAccount _googleUser;
    GoogleSignInAccount get user => _googleUser;
    final googleSignIn = GoogleSignIn();

    bool logged;

    DRPAuthAPI() {
        this._authProvider = FirebaseAuth.instance;
        this.logged = false;
        this._Passengercollection = FirebaseFirestore.instance.collection('Passengers');
        this._Drivercollection = FirebaseFirestore.instance.collection('Drivers');
    }

    bool getLoggedInfo() {
        return logged;
    }

    void addPassenger(Map<String, dynamic> user) async {
        user.forEach((k, v) => print("Key : $k, Value : $v"));
        await this._Passengercollection.doc(user["email"]).set(user);
    }

    void addDriver(Map<String, dynamic> user) async {
        user.forEach((k, v) => print("Key : $k, Value : $v"));
        await this._Drivercollection.doc(user["email"]).set(user);
    }

    void fetchPassenger() {
        this._Passengercollection.snapshots().listen((event) {
            print(event.docs[0].data());
        });
    }

    void getSpecUser() async {
        print("Drivers: ");
        await FirebaseFirestore.instance.collection('Drivers').doc(FirebaseAuth.instance.currentUser.uid).get().then((value) => {
            print("Test1: " + value.data()["name"])
        });

        print("Passengers: ");
        await FirebaseFirestore.instance.collection('Passengers').doc(FirebaseAuth.instance.currentUser.uid).get().then((value) =>
            print("Test2: " + value.data()["name"]));
    }

    Future googleLogin() async {

        try { googleSignIn.signOut(); }
        catch (error) { print(error); }

        final googleUserInscope = await googleSignIn.signIn();
        _googleUser = googleUserInscope;
        if (_googleUser == null) {
            logged = false;
            return;
        }
        logged = true;

        final googleAuth = await _googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
        );

        print(_googleUser.email);
        await _authProvider.signInWithCredential(credential);
    }

    void createUser(String email, String password) async {

        try {
            await _authProvider.createUserWithEmailAndPassword(email: email, password: password);
        } catch (error) {
            Fluttertoast.showToast(
                msg: "${error.message}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0
            );
            logged = false;
            return;
        }
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
        );
        logged = true;
    }
    void signIn(String email, String password) async {
        try {
            await _authProvider.signInWithEmailAndPassword(email: email, password: password);
        } catch (error) {
            Fluttertoast.showToast(
                msg: "${error.message}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0
            );
            logged = false;
            return;
        }
        Fluttertoast.showToast(
            msg: "Signed in",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
        );
        logged = true;
    }
}