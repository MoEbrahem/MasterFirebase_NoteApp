import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/categories/add.dart';
import 'package:flutter_firebase/filter.dart';
import 'package:flutter_firebase/homepage.dart';
import 'package:flutter_firebase/test.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase/auth/login.dart';
import 'package:flutter_firebase/auth/signup.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("================= Back Ground Message");
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Firebase',
        theme: ThemeData(
            appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[50],
          titleTextStyle: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.orange),
          iconTheme: const IconThemeData(color: Colors.orange),
        )),
        routes: {
          "login": (context) => const Login(),
          "homepage": (context) => const HomePage(),
          "signup": (context) => const SignUp(),
          "addcategory": (context) => const AddCategory(),
          "filterData": (context) => const FilterData(),
        },
        home: const Test()
        //(FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser!.emailVerified) ? const HomePage() : const Login(),
        );
  }
}
