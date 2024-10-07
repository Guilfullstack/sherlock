import 'package:flutter/material.dart';
import 'package:sherlock/view/widgets/game_card.dart';

class CardPage extends StatelessWidget {
  const CardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212A3E),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.blue),
        title: const Text('Cartas do Jogo'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GameCard(
                title: 'Congelar',
                imagePath:
                    'images/congelar.png', // Certifique-se de adicionar uma imagem apropriada na pasta assets
              ),
              GameCard(
                title: 'Escudo',
                imagePath:
                    'images/escudo.png', // Certifique-se de adicionar uma imagem apropriada na pasta assets
              ),
              GameCard(
                title: 'Lá casa de papel',
                imagePath:
                    'images/lacasadepapel.png', // Certifique-se de adicionar uma imagem apropriada na pasta assets
              ),
            ],
          ),
        ),
      ),
    );
  }
}
