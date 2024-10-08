import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sobre o app',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.blue),
        backgroundColor: Colors.black,
      ),
      backgroundColor: const Color(0xFF212A3E), // Fundo escuro
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Informações sobre o projeto',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Texto branco
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '''O aplicativo desenvolvido para o evento anual do internato do UNIAENE, conhecido como Sherlock, foi projetado para aprimorar a experiência interativa lúdica dos participantes. 
Este evento, realizado há mais de 20 anos, tem o objetivo de contar histórias misteriosas e entreter os internos, levando-os a uma jornada por diferentes épocas e cenários históricos.
O aplicativo desenvolvido auxilia na gamificação dessas histórias, oferecendo aos participantes uma plataforma dinâmica para resolver enigmas, desbloquear pistas e interagir com o enredo de forma imersiva.''',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white, // Texto branco
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Colaboradores',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Texto branco
                ),
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  _buildCollaboratorCard(
                      imageUrl: 'images/colab/italo.jpeg',
                      name: 'Ítalo Ferreira',
                      position: 'Desenvolvedor',
                      linkedInUrl:
                          'https://www.linkedin.com/in/%C3%ADtalo-ferreira-383a4b1a7/'),
                  _buildCollaboratorCard(
                      imageUrl: 'images/colab/guilherme.jpeg',
                      name: 'Guilherme Almeida',
                      position: 'Desenvolvedor',
                      linkedInUrl:
                          'www.linkedin.com/in/guilherme-souza-almeida-dev'),
                  _buildCollaboratorCard(
                      imageUrl: 'images/colab/ezequiel.jpeg',
                      name: 'Ezequiel Ribeiro',
                      position: 'Idealizador',
                      linkedInUrl:
                          'www.linkedin.com/in/guilherme-souza-almeida-dev'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCollaboratorCard({
    required String imageUrl,
    required String name,
    required String position,
    required String linkedInUrl,
  }) {
    return Card(
      color: Colors.black12,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 50,
              backgroundImage: AssetImage(imageUrl),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    position,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: linkedInUrl));
                    },
                    child: const Text(
                      'LinkedIn',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
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
