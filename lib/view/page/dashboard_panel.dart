import 'package:flutter/material.dart';
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
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.black,
                      content: SizedBox(
                          height: 400,
                          width: _selectedPage == 0 ? 400 : 800,
                          child: pageCreate(_selectedPage)),
                    );
                  },
                );
              },
              child: const Icon(Icons.add),
            ),
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Image.asset(
            'images/logo.png',
          ),
        ),
        title: const Text(
          'SHERLOCK',
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
              onPressed: () => userController.logout(context),
              icon: const Icon(
                Icons.logout,
                color: Colors.purple,
              )),
        ],
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
                    item('Home', 0, () {
                      setState(() {
                        _selectedPage = 0; // Muda para a página Dashboard
                      });
                    }),
                    item('Colaboradores', 1, () {
                      setState(() {
                        _selectedPage = 1; // Muda para a página Usuários
                      });
                    }),
                    item('Provas', 2, () {
                      setState(() {
                        _selectedPage = 2; // Muda para a página Vendas
                      });
                    }),
                    item('Hitorico', 3, () {
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
    switch (_selectedPage) {
      //pagina home
      case 0:
        return const Manager(create: false, pageList: 1);
      // pagina Colaboradores
      case 1:
        return const Row(
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
    switch (page) {
      case 0:
        return const Manager(pageList: 1, create: true);
      case 1:
        return const Row(
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
  ListTile item(String nome, int index, Function()? onTap) {
    return ListTile(
      tileColor: _selectedPage == index
          ? const Color(0xFF523B76) // Cor quando o ListTile está selecionado
          : colorTileDash(index), // Cor padrão
      title: Text(
        nome,
        style: const TextStyle(color: Colors.white), // Cor do texto ajustada
      ),
      onTap: onTap,
    );
  }
}

Color colorTileDash(int page) {
  return const Color(0xFF212A3E); // Cor padrão dos tiles
}
