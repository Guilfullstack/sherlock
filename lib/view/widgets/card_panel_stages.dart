import 'package:flutter/material.dart';
import 'package:sherlock/model/stage.dart';
import 'package:sherlock/view/widgets/card_stage.dart';

class CardPanelStages extends StatelessWidget {
  final List<Stage> liststages;
  const CardPanelStages({Key? key, required this.liststages}) : super(key: key);

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
          child: ListView.builder(
            itemCount: liststages.length,
            itemBuilder: (context, index) {
              Stage stage = liststages[index];
              bool isUnlocked = true; // Adapte conforme necessário
              int position = index + 1;
              return CardStage(
                  stage: stage, isUnlocked: isUnlocked, position: position);
            },
          ),
        ),
      ],
    );
  }
}
