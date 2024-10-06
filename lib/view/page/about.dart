import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sobre o Projeto',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      backgroundColor: const Color(0xFF212A3E), // Fundo escuro
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informações sobre o Projeto',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Texto branco
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Este projeto tem como objetivo ...', // Descrição do projeto
              style: TextStyle(
                fontSize: 16,
                color: Colors.white, // Texto branco
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Colaboradores',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Texto branco
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildCollaboratorCard(
                    imageUrl: 'https://example.com/imagem1.jpg',
                    name: 'Colaborador 1',
                    position: 'Desenvolvedor',
                  ),
                  _buildCollaboratorCard(
                    imageUrl: 'https://example.com/imagem2.jpg',
                    name: 'Colaborador 2',
                    position: 'Designer',
                  ),
                  _buildCollaboratorCard(
                    imageUrl: 'https://example.com/imagem3.jpg',
                    name: 'Colaborador 3',
                    position: 'Gerente de Projeto',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollaboratorCard({
    required String imageUrl,
    required String name,
    required String position,
  }) {
    return Card(
      color: const Color(0xFF394867), // Cor do card para combinar com o fundo
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 60, // Tamanho da imagem (ajustável)
              backgroundImage: NetworkImage(imageUrl),
            ),
            const SizedBox(width: 16), // Espaço entre a imagem e os textos
            Expanded(
              // Permite que os textos ocupem o restante do espaço
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Alinha textos à esquerda
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white, // Nome em branco
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    position,
                    style: const TextStyle(
                      color: Colors.white, // Cargo em branco
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
