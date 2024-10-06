import 'package:flutter/material.dart';
import 'package:sherlock/view/widgets/game_card.dart';

class CardPage extends StatelessWidget {
  const CardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212A3E),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Cartas do Jogo'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: const [
            GameCard(
              title: 'Congelar',
              description: 'Congela o inimigo por 10 min.',
              imagePath:
                  'images/congelar.png', // Certifique-se de adicionar uma imagem apropriada na pasta assets
            ),
            GameCard(
              title: 'Escudo',
              description: 'Protege contra o próximo ataque.',
              imagePath:
                  'images/escudo.png', // Certifique-se de adicionar uma imagem apropriada na pasta assets
            ),
          ],
        ),
      ),
    );
  }
}
