import 'package:flutter/material.dart';

class CardPanelChallenges extends StatelessWidget {
  final List<Widget> listchalanges;
  const CardPanelChallenges({Key? key, required this.listchalanges})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text(
            'Provas',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          height: 300, // Altura do Container
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.white,
              width: 1.0,
            ),
          ),
          child: ListView(children: listchalanges),
        ),
      ],
    );
  }
}
