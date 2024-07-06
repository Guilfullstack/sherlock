import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sherlock/firebase_options.dart';
import 'package:sherlock/view/page/home_page.dart';
import 'package:sherlock/view/page/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    // MultiProvider(
    // providers: [ChangeNotifierProvider(create: (context) => UserController())],
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ),
  );
}
