import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopri/views/phone_auth_sign_up.dart';

class AuthChoice extends StatefulWidget {
  const AuthChoice({Key? key}) : super(key: key);

  @override
  State<AuthChoice> createState() => _AuthChoiceState();
}

class _AuthChoiceState extends State<AuthChoice> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
          child: Container(
        decoration: const BoxDecoration(),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // SizedBox(height: size.height * 0.04),
            Container(
              height: size.height * 0.2,
              width: size.width * 0.2,
              decoration: const BoxDecoration(color: Colors.white),
              child: const FlutterLogo(),
            ),
            // SizedBox(height: size.height * 0.02),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 80.0),
              child: Text('Minim quis reprehenderit', style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            ),
            // SizedBox(height: size.height * 0.02),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Text('Magna ullamco sunt ullamco mollit qui officia',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500, color: Colors.grey), textAlign: TextAlign.center),
            ),
            // SizedBox(height: size.height * 0.12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: MaterialButton(
                onPressed: () => Navigator.push(context, CupertinoPageRoute(builder: (context) => const PhoneAuthSignUp())),
                color: Colors.black,
                minWidth: double.infinity,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                height: size.height * 0.07,
                child: const Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
              ),
            ),
            // SizedBox(height: size.height * 0.04),
          ],
        ),
      )),
    );
  }
}
