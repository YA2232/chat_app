import 'package:chat_app/view/registration_screen.dart';
import 'package:chat_app/view/signin_screen.dart';
import 'package:chat_app/widgets/my_button.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  static const String routeScreen = 'welcomescreen';

  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 23),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Container(
                  height: 200,
                  child: Image.asset(
                      "images/360_F_511873784_NLmIMOcuwo9JTuoXJNyR0jQSQOUXUvFk.jpg"),
                ),
                Text(
                  "Message Me",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            MyButton(
              color: Colors.yellow[900]!,
              title: "sign in",
              onpressed: () {
                Navigator.pushNamed(context, SigninScreen.routeScreen);
              },
            ),
            MyButton(
              color: Colors.blue[800]!,
              title: "register",
              onpressed: () {
                Navigator.pushNamed(context, RegistrationScreen.routeScreen);
              },
            ),
          ],
        ),
      ),
    );
  }
}
