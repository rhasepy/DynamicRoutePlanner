import 'package:dynamicrouteplanner/FirebaseAuthAPI/ProxyAuthAPI.dart';
import 'package:dynamicrouteplanner/Screens/TypeRouter/TypeAskerAPIUI.dart';
import 'package:dynamicrouteplanner/Screens/Welcome/welcome_screen.dart';
import 'package:dynamicrouteplanner/StaticConstants/DRP_Constants.dart';
import 'package:flutter/material.dart';
import 'package:dynamicrouteplanner/Screens/Login/login_screen.dart';
import 'package:dynamicrouteplanner/Screens/Signup/components/background.dart';
import 'package:dynamicrouteplanner/Screens/Signup/components/or_divider.dart';
import 'package:dynamicrouteplanner/Screens/Signup/components/social_icon.dart';
import 'package:dynamicrouteplanner/components/already_have_an_account_acheck.dart';
import 'package:dynamicrouteplanner/components/rounded_button.dart';
import 'package:dynamicrouteplanner/components/rounded_input_field.dart';
import 'package:dynamicrouteplanner/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Body extends StatelessWidget {

  String _email = "";
  String _password = "";
  DRPAuthAPI API = DRPAuthAPI();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Dynamic Route Planner Sign Up",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/signup.svg",
              height: size.height * 0.35,
            ),
            RoundedInputField(
              hintText: "Email",
              onChanged: (value) {
                _email = value;
              },
            ),
            RoundedPasswordField(
              onChanged: (value) {
                _password = value;
              },
            ),
            RoundedButton(
              text: "SIGN UP",
              press: () async {
                  await API.createUser(_email, _password);
                  if (API.getLoggedInfo()) {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => TypeAsker()), ModalRoute.withName("/Home"));
                  }
                },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
            OrDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SocalIcon(
                  iconSrc: "assets/icons/google-plus.svg",
                  press: () async {
                      await API.googleLogin();
                      if (API.getLoggedInfo()) {
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => TypeAsker()), ModalRoute.withName("/Home"));
                      }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
