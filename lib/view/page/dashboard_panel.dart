import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sherlock/controller/tools_controller.dart';
import 'package:sherlock/controller/user_controller.dart';
import 'package:sherlock/view/page/about.dart';
import 'package:sherlock/view/page/page%20Panel/manager.dart';

class DashboardPanel extends StatefulWidget {
  const DashboardPanel({super.key});

  @override
  State<DashboardPanel> createState() => _DashboardPanelState();
}

class _DashboardPanelState extends State<DashboardPanel> {
  int _selectedPage = 0;
  UserController userController = UserController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _selectedPage == 2 || _selectedPage == 3
          ? null
          : FloatingActionButton(
              backgroundColor: Colors.blue,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.black,
                      content: SizedBox(
                          //height: 400,
                          width: _selectedPage == 0 ? 400 : 800,
                          child: pageCreate(_selectedPage)),
                    );
                  },
                );
              },
              child: const Icon(Icons.add),
            ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Image.asset(
          'images/logo2.png',
        ),
        title: Text(
          'SHERLOCK',
          style: GoogleFonts.anton(
            textStyle: const TextStyle(
              fontSize: 30, // Aumente o tamanho para dar um impacto maior
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing:
                  2.0, // Espaçamento entre letras para efeito de manchete
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                ToolsController.navigateReturn(context, const AboutPage());
              },
              icon: const Icon(
                Icons.info,
                color: Colors.blue,
              )),
          IconButton(
              onPressed: () => userController.logout(context),
              icon: const Icon(
                Icons.logout,
                color: Colors.blue,
              )),
        ],
        shape: const Border(
          bottom: BorderSide(
            color: Colors.blue, // Cor da borda
            width: 2.0, // Largura da borda
          ),
        ),
        centerTitle: true,
      ),
      body: Row(
        children: [
          // Drawer fixo na lateral esquerda
          Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: Colors.black, // Cor da borda
                    width: 1.0, // Largura da borda
                  ),
                ),
              ),
              child: Drawer(
                elevation: 5,
                backgroundColor: const Color(0xFF212A3E),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.zero,
                  ),
                ),
                child: ListView(
                  children: [
                    item('Home', 0, Icons.home, () {
                      setState(() {
                        _selectedPage = 0; // Muda para a página Dashboard
                      });
                    }),
                    item('Colaboradores', 1, Icons.group, () {
                      setState(() {
                        _selectedPage = 1; // Muda para a página Usuários
                      });
                    }),
                    item('Provas', 2, Icons.task, () {
                      setState(() {
                        _selectedPage = 2; // Muda para a página Vendas
                      });
                    }),
                    item('Hitorico', 3, Icons.history, () {
                      setState(() {
                        _selectedPage = 3; // Muda para a página Relatórios
                      });
                    }),
                  ],
                ),
              ),
            ),
          ),

          // Área de conteúdo à direita do Drawer
          Expanded(
            flex: 8, // Tamanho flexível maior para a área de conteúdo
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _getSelectedPage(), // Exibe a página selecionada
            ),
          ),
        ],
      ),
    );
  }

  // Retorna o conteúdo da página baseado no índice selecionado
  Widget _getSelectedPage() {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    switch (_selectedPage) {
      //pagina home
      case 0:
        return const Manager(create: false, pageList: 1);
      // pagina Colaboradores
      case 1:
        return w < 800
            ? ListView(
                children: [
                  SizedBox(
                      height: (h / 2) - 50,
                      child: const Manager(create: false, pageList: 2)),
                  SizedBox(
                      height: (h / 2) - 50,
                      child: const Manager(create: false, pageList: 3)),
                ],
              )
            : const Row(
                children: [
                  Expanded(child: Manager(create: false, pageList: 2)),
                  Expanded(child: Manager(create: false, pageList: 3)),
                ],
              );
      //pagina provas
      case 2:
        return const Manager(create: false, pageList: 4);
      //Pagina historico
      case 3:
        return const Manager(create: false, pageList: 5);
      default:
        return const Center(
            child: Text(
          'Selecione uma opção no menu',
          style: TextStyle(color: Colors.white),
        ));
    }
  }

  Widget pageCreate(int page) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    switch (page) {
      case 0:
        return const Manager(pageList: 1, create: true);
      case 1:
        return w < 800
            ? ListView(
                children: [
                  SizedBox(
                      height: (h / 2) - 50,
                      child: const Manager(pageList: 2, create: true)),
                  SizedBox(
                      height: (h / 2) - 50,
                      child: const Manager(pageList: 3, create: true)),
                ],
              )
            : const Row(
                children: [
                  Manager(pageList: 2, create: true),
                  Manager(pageList: 3, create: true),
                ],
              );
      case 2:
        return const Manager(pageList: 4, create: true);
      default:
        return const Text("data");
    }
  }

  // Método para criar os itens do Drawer
  ListTile item(String nome, int index, IconData icon, Function()? onTap) {
    double w = MediaQuery.of(context).size.width;
    return ListTile(
      tileColor: _selectedPage == index
          ? Colors.blue // Cor quando o ListTile está selecionado
          : colorTileDash(index), // Cor padrão
      title: w < 800
          ? Icon(
              icon,
              color: Colors.white,
            )
          : Text(
              nome,
              style:
                  const TextStyle(color: Colors.white), // Cor do texto ajustada
            ),
      onTap: onTap,
    );
  }
}

Color colorTileDash(int page) {
  return const Color(0xFF212A3E); // Cor padrão dos tiles
}
