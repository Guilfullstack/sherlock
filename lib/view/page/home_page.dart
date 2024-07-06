import 'package:flutter/material.dart';
import 'package:sherlock/view/widgets/card_funtions.dart';
import 'package:sherlock/view/widgets/card_panel_challenges.dart';
import 'package:sherlock/view/widgets/card_panel_info.dart';
import 'package:sherlock/view/widgets/challanges.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.info))],
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
              const CardPanelInfo(),
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
