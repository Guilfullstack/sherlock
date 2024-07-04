import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sherlock/controller/login_controller.dart';
import 'package:sherlock/firebase_options.dart';
import 'package:sherlock/view/page/loginPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (context) => LoginController())],
    child: MaterialApp(
      home: LoginPage(),
    ),
  ));
}
