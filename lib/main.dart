import 'package:chat_app/view/chat_screen.dart';
import 'package:chat_app/view/registration_screen.dart';
import 'package:chat_app/view/signin_screen.dart';
import 'package:chat_app/view/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future _firebaseMessagingBackgroundHandler(RemoteMessage meassage) async {
  print("${meassage.notification!.body}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _auth = FirebaseAuth.instance;
  final fbm = FirebaseMessaging.instance;

  @override
  void initState() {
    fbm.getToken().then((token) {
      print(token);
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("${event.notification!.title}");
    });
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   print('Got a message whilst in the foreground!');
    //   print('Message data: ${message.notification!.body}');
    // });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      Navigator.pushNamed(context, RegistrationScreen.routeScreen);
    });
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'chat app',
      initialRoute: _auth.currentUser != null
          ? ChatScreen.routeScreen
          : WelcomeScreen.routeScreen,
      routes: {
        WelcomeScreen.routeScreen: (context) => WelcomeScreen(),
        SigninScreen.routeScreen: (context) => SigninScreen(),
        RegistrationScreen.routeScreen: (context) => RegistrationScreen(),
        ChatScreen.routeScreen: (context) => ChatScreen(),
      },
    );
  }
}
