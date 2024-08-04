import 'package:flutter/material.dart';
import 'package:sherlock/controller/play_controller.dart';
import 'package:sherlock/controller/user_controller.dart';
import 'package:sherlock/model/code.dart';
import 'package:sherlock/model/stage.dart';
import 'package:sherlock/model/user_team.dart';
import 'package:sherlock/view/widgets/card_funtions.dart';
import 'package:sherlock/view/widgets/card_panel_info.dart';
import 'package:sherlock/view/widgets/card_panel_stages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserTeam? currentUser;
  List<Stage>? listStages = [];
  List<Code>? listCode = [];
  UserController userController = UserController();
  PlayController playController = PlayController();
  @override
  void initState() {
    super.initState();
    _retrieveCurrentUser();
  }

  Future<void> _retrieveCurrentUser() async {
    try {
      UserTeam? userTeamFromHive = await userController.getUserHive();
      List<Stage>? listStagesFromHive =
          await playController.getStageListFromHive();

      for (Stage stage in listStagesFromHive) {
        print("${stage.description}");
      }

      List<Code>? listCodeFromHive = await playController.getCodeListFromHive();

      setState(() {
        currentUser = userTeamFromHive;
        listStages = listStagesFromHive;
        listCode = listCodeFromHive;
      });
    } catch (e) {
      print("erro home: $e");
    }
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
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.info,
                color: Colors.purple,
              )),
          IconButton(
              onPressed: () => userController.logout(context),
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
              CardPanelStages(
                liststages: listStages ?? [],
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCodeEntryDialog(context),
        backgroundColor: Colors.grey,
        child: const Icon(
          Icons.key,
          color: Colors.purple,
        ),
      ),
    );
  }
}

// Mapeamento das categorias para português
const Map<Category, String> categoryLabels = {
  Category.freezing: 'Congelar',
  Category.protect: 'Proteção',
  Category.pay: 'Pagar',
  Category.receive: 'Receber',
  Category.stage: 'Prova',
};

void _showCodeEntryDialog(BuildContext context) {
  final TextEditingController codeController = TextEditingController();
  Category? selectedCategory;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Inserir Código'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<Category>(
              value: selectedCategory,
              hint: const Text('Selecione uma categoria'),
              items: categoryLabels.entries.map((entry) {
                return DropdownMenuItem<Category>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
              onChanged: (Category? newCategory) {
                selectedCategory = newCategory;
              },
            ),
            TextField(
              controller: codeController,
              decoration: const InputDecoration(labelText: 'Código'),
              keyboardType: TextInputType.text,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (selectedCategory != null && codeController.text.isNotEmpty) {
                final Category category = selectedCategory!;
                final String code = codeController.text;

                // Execute a função com a categoria e código
                _handleSave(category, code);

                Navigator.of(context).pop();
              } else {
                // Exiba uma mensagem de erro se a categoria ou o código não forem preenchidos
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Preencha todos os campos')),
                );
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      );
    },
  );
}

void _handleSave(Category category, String code) {
  // Adicione a lógica para tratar o código e a categoria aqui
  print('Categoria: $category');
  print('Código: $code');
}
