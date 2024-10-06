import 'package:flutter/material.dart';
import 'package:sherlock/controller/play_controller.dart';
import 'package:sherlock/controller/tools_controller.dart';
import 'package:sherlock/controller/user_controller.dart';
import 'package:sherlock/view/page/about.dart';
import 'package:sherlock/view/page/login_page.dart';
import 'package:sherlock/view/page/page%20Panel/list_users.dart';
import 'package:sherlock/view/widgets/list_team_controller.dart';

class StaffPage extends StatefulWidget {
  final String staffId;
  const StaffPage({super.key, required this.staffId});

  @override
  State<StaffPage> createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  List<Map<String, dynamic>> stageDetails = [];

  PlayController playController = PlayController();
  UserController userController = UserController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Image.asset(
          'images/logo.png',
        ),
        title: const Text(
          'SHERLOK',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutPage()),
                );
              },
              icon: const Icon(
                Icons.info,
                color: Colors.purple,
              )),
          IconButton(
              onPressed: () =>
                  ToolsController.navigate(context, const LoginPage()),
              icon: const Icon(
                Icons.logout,
                color: Colors.purple,
              )),
        ],
        shape: const Border(
          bottom: BorderSide(
            color: Colors.white, // Cor da borda
            width: 2.0, // Largura da borda
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Card.filled(
          color: const Color.fromARGB(0, 0, 0, 0),
          child: ListUsers<Map<String, dynamic>>(
            aspectRatio: 5,
            size: MediaQuery.of(context).size.width,
            stream: playController.getListStaff(widget.staffId),
            emptyMessage: 'Não há provas',
            errorMessage: 'Erro ao carregar provas',
            itemBuilder: (context, team, index) {
              return ListTeamController(
                listStageProva: true,
                user: true,
                code: true,
                stage: true,
                equipe: "${team['description']}",
                status: "${team['token']}",
              );
            },
          ),
        ),
      ),
    );
  }
}
