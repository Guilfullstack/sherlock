import 'package:flutter/material.dart';
import 'package:sherlock/model/stage.dart';
import 'package:sherlock/view/widgets/card_stage.dart';

class CardPanelStages extends StatelessWidget {
  final List<Stage>? liststages;
  final List<String>? listTokenStageDesbloqued;

  const CardPanelStages({
    Key? key,
    required this.liststages,
    required this.listTokenStageDesbloqued,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (liststages == null || liststages!.isEmpty) {
      return const Center(
        child: Text(
          'Nenhuma prova disponível.',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

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
          height: 300,
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
            itemCount: liststages!.length,
            itemBuilder: (context, index) {
              final stage = liststages![index];
              final isUnlocked =
                  listTokenStageDesbloqued?.contains(stage.token) ?? false;

              return CardStage(
                stage: stage,
                isUnlocked: isUnlocked,
                position: index + 1,
              );
            },
          ),
        ),
      ],
    );
  }
}
