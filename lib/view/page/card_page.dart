import 'package:flutter/material.dart';
import 'package:sherlock/view/widgets/game_card.dart';

class CardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF212A3E),
      appBar: AppBar(
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
            SizedBox(width: 16), // Espaçamento entre as cartas
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
