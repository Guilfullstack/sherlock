import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sherlock/controller/play_controller.dart';
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
    print('Inicialização do Hive ignorada na plataforma Web.');
    return; // Não inicializa o Hive se for a Web
  }

  try {
    print('Inicializando o Hive...');
    final appDocumentDir =
        await path_provider.getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);
    print('Hive inicializado com o caminho: ${appDocumentDir.path}');

    // Registra os adaptadores do Hive
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserTeamAdapter());
      print('UserTeamAdapter registrado');
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(StageAdapter());
      print('StageAdapter registrado');
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(StatusAdapter());
      print('StatusAdapter registrado');
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(CodeAdapter());
      print('CodeAdapter registrado');
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(CategoryAdapter());
      print('CategoryAdapter registrado');
    }

    // Abra as caixas do Hive
    await Hive.openBox<UserTeam>('userTeamBox');
    print('userTeamBox aberta');
    await Hive.openBox<Code>('codeBox');
    print('codeBox aberta');
    await Hive.openBox<Stage>('stageBox');
    print('stageBox aberta');

    print('Caixas do Hive abertas com sucesso');
  } catch (e) {
    print('Erro ao inicializar o Hive: $e');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Firebase
  try {
    print('Initializing Firebase...');
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    print('Firebase initialized successfully');
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  // Pequeno atraso para garantir que os plugins estão carregados
  await Future.delayed(const Duration(seconds: 1));
  await initializeHive();

  PlayController playController = PlayController();

  List<Stage> stageList = await playController.getStageList();

  playController.saveStageListToHive(stageList);

  List<Stage> l2 = await playController.getStageListFromHive();

  for (Stage stage in l2) {
    print("${stage.description}");
  }

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
