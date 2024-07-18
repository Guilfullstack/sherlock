import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sherlock/controller/user_controller.dart';
import 'package:sherlock/firebase_options.dart';
import 'package:sherlock/view/page/controller_panel_page.dart';
import 'package:sherlock/view/page/home_page.dart';
import 'package:sherlock/view/page/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ChangeNotifierProvider(
      create: (context) => UserController(),
      child: MaterialApp(
        home: ControllerPanelPage(),
        theme: ThemeData(
          primaryColorLight: Colors.white,
          scaffoldBackgroundColor: Colors.black87,
          listTileTheme: const ListTileThemeData(
            tileColor: Colors.black,
          ),
          cardColor:
              const Color.fromARGB(255, 117, 21, 21), // Cor dos Cards definida em RGB
        ),
      ),
    ),
  );
}
