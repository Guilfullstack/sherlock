import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sherlock/controller/user_controller.dart';
import 'package:sherlock/firebase_options.dart';
import 'package:sherlock/model/code.dart';
import 'package:sherlock/model/stage.dart';
import 'package:sherlock/model/user_team.dart';
import 'package:sherlock/view/page/dashboard_panel.dart';
import 'package:sherlock/view/page/login_page.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter/foundation.dart' show kIsWeb;

Future<void> initializeHive() async {
  if (kIsWeb) {
    debugPrint('Inicialização do Hive ignorada na plataforma Web.');
    return; // Não inicializa o Hive se for a Web
  }

  try {
    debugPrint('Inicializando o Hive...');
    final appDocumentDir =
        await path_provider.getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);
    debugPrint('Hive inicializado com o caminho: ${appDocumentDir.path}');

    // Registra os adaptadores do Hive
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserTeamAdapter());
      debugPrint('UserTeamAdapter registrado');
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(StatusAdapter());
      debugPrint('StatusAdapter registrado');
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(CategoryAdapter());
      debugPrint('CategoryAdapter registrado');
    }
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(StageAdapter());
      debugPrint('StageAdapter registrado');
    }
    // Abra as caixas do Hive
    await Hive.openBox<UserTeam>('userTeamBox');
    debugPrint('userTeamBox aberta');
    await Hive.openBox<Stage>('stageBox');
    debugPrint('stageBox aberta');
    debugPrint('Caixas do Hive abertas com sucesso');
  } catch (e) {
    debugPrint('Erro ao inicializar o Hive: $e');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Firebase
  try {
    debugPrint('Initializing Firebase...');
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    debugPrint('Firebase initialized successfully');
  } catch (e) {
    debugPrint('Error initializing Firebase: $e');
  }
  // Pequeno atraso para garantir que os plugins estão carregados
  await Future.delayed(const Duration(seconds: 1));
  await initializeHive();

  runApp(
    ChangeNotifierProvider(
      create: (context) => UserController(),
      child: MaterialApp(
        home: LoginPage(),
        theme: ThemeData(
            primaryColorLight: Colors.black,
            scaffoldBackgroundColor: const Color(0xFF212A3E),
            listTileTheme: const ListTileThemeData(
              tileColor: Color(0xFF523B76),
            ),
            drawerTheme: DrawerThemeData(
              backgroundColor: Colors.black,
            ),
            
            cardColor: const Color.fromARGB(
                255, 117, 21, 21), // Cor dos Cards definida em RGB
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.black,
            )),
      ),
    ),
  );
}
