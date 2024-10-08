import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sherlock/controller/user_controller.dart';
import 'package:sherlock/firebase_options.dart';
import 'package:sherlock/model/code.dart';
import 'package:sherlock/model/stage.dart';
import 'package:sherlock/model/user_team.dart';
import 'package:sherlock/view/page/login_page.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter/foundation.dart' show kIsWeb;

Future<void> initializeHive() async {
  if (kIsWeb) {
    return;
  }
  try {
    final appDocumentDir =
        await path_provider.getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);
    // Registra os adaptadores do Hive
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserTeamAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(StatusAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(CategoryAdapter());
    }
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(StageAdapter());
    }
    await Hive.openBox<UserTeam>('userTeamBox');
    await Hive.openBox<Stage>('stageBox');
    debugPrint('Caixas do Hive abertas com sucesso');
  } catch (e) {
    debugPrint('Erro ao inicializar o Hive: $e');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Firebase
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    debugPrint('Error initializing Firebase: $e');
  }
  await Future.delayed(const Duration(seconds: 1));
  await initializeHive();

  runApp(
    ChangeNotifierProvider(
      create: (context) => UserController(),
      child: MaterialApp(
        home: const LoginPage(),
        theme: ThemeData(
            primaryColorLight: Colors.blue,
            scaffoldBackgroundColor: const Color(0xFF212A3E),
            textButtonTheme: TextButtonThemeData(
                style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all(Colors.blue),
            )),
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            )),
            listTileTheme: const ListTileThemeData(
              tileColor: Colors.black,
            ),
            drawerTheme: const DrawerThemeData(
              backgroundColor: Colors.black,
            ),
            cardColor: const Color.fromARGB(
                255, 117, 21, 21), // Cor dos Cards definida em RGB
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.black,
            )),
      ),
    ),
  );
}
