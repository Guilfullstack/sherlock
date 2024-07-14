import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sherlock/controller/user_controller.dart';
import 'package:sherlock/firebase_options.dart';
import 'package:sherlock/model/user_team.dart';
import 'package:sherlock/view/page/login_page.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart' as path_provider;

void clearHiveData() async {
  final dir = await path_provider.getApplicationDocumentsDirectory();
  await Hive.deleteFromDisk();
  Hive.init(dir.path);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  clearHiveData();
  // Inicializa o Hive com o diretório de documentos do aplicativo
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(
      appDocumentDir.path); // use initFlutter para integração completa

  // Registra os adaptadores do Hive
  Hive.registerAdapter(UserTeamAdapter());
  Hive.registerAdapter(StatusAdapter());

  // Abre a caixa para armazenar UserTeam
  await Hive.openBox<UserTeam>('userTeamBox');
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserController(),
      child: MaterialApp(
        home: LoginPage(),
        theme: ThemeData(
          primaryColorLight: Colors.white,
          scaffoldBackgroundColor: Colors.black87,
          listTileTheme: const ListTileThemeData(
            tileColor: Colors.black,
          ),
          cardColor: const Color.fromARGB(
              255, 117, 21, 21), // Cor dos Cards definida em RGB
        ),
      ),
    ),
  );
}
