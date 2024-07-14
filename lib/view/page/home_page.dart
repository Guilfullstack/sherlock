import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sherlock/controller/user_controller.dart';
import 'package:sherlock/model/user_team.dart';
import 'package:sherlock/view/widgets/card_funtions.dart';
import 'package:sherlock/view/widgets/card_panel_challenges.dart';
import 'package:sherlock/view/widgets/card_panel_info.dart';
import 'package:sherlock/view/widgets/challanges.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Box<UserTeam> userTeamBox;
  UserTeam? currentUser;
  UserController userController = UserController();
  @override
  void initState() {
    super.initState();
    _retrieveCurrentUser();
  }

  Future<void> _retrieveCurrentUser() async {
    userTeamBox = Hive.box<UserTeam>('userTeamBox');
    setState(() {
      currentUser = userTeamBox.get('currentUser');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        leading: Image.asset(
          'images/logo.png',
        ),
        title: const Text(
          'SHERLOK',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.info)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.info)),
          TextButton(
              onPressed: () {
                userController.logout(context);
              },
              child: Text('Log Out'))
        ],
        shape: const Border(
          bottom: BorderSide(
            color: Colors.white, // Cor da borda
            width: 2.0, // Largura da borda
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black12,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Exibe as informações do usuário se estiver disponível
              currentUser != null
                  ? CardPanelInfo(
                      credit: currentUser!.credit ?? 0,
                      status: currentUser!.status ?? Status.Jogando,
                    )
                  : const CircularProgressIndicator(),
              //const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CardFuntions(icon: Icons.map, nome: 'Mapa', onTap: () {}),
                    const SizedBox(
                      width: 10,
                    ),
                    CardFuntions(
                        icon: Icons.card_giftcard,
                        nome: 'Cartas',
                        onTap: () {}),
                  ],
                ),
              ),
              CardPanelChallenges(
                listchalanges: [
                  Challenge(name: "Prova", isUnlocked: true),
                  Challenge(name: "Prova", isUnlocked: true),
                  Challenge(name: "Prova", isUnlocked: false),
                  Challenge(name: "Prova", isUnlocked: false),
                ],
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.key),
        onPressed: () {},
        backgroundColor: Colors.grey,
      ),
    );
  }
}
