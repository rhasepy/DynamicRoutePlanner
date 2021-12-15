import 'package:dynamicrouteplanner/FirebaseAuthAPI/ProxyAuthAPI.dart';
import 'package:dynamicrouteplanner/Screens/TypeRouter/TypeAskerAPIUI.dart';
import 'package:dynamicrouteplanner/Screens/Welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:dynamicrouteplanner/Screens/Login/components/background.dart';
import 'package:dynamicrouteplanner/Screens/Signup/signup_screen.dart';
import 'package:dynamicrouteplanner/components/already_have_an_account_acheck.dart';
import 'package:dynamicrouteplanner/components/rounded_button.dart';
import 'package:dynamicrouteplanner/components/rounded_input_field.dart';
import 'package:dynamicrouteplanner/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';

class Body extends StatelessWidget {

  String _email = "";
  String _password = "";
  DRPAuthAPI API = DRPAuthAPI();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String _email = "";
    String _password = "";

    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: "Your Email",
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
              text: "LOGIN",
              press: () async {
                  await API.signIn(_email, _password);
                  if (API.getLoggedInfo()) {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => TypeAsker()), ModalRoute.withName("/Home"));
                  }
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
