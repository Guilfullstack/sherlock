import 'package:flutter/material.dart';
import 'package:sherlock/model/stage.dart';
import 'package:sherlock/view/widgets/card_stage.dart';

class CardPanelStages extends StatelessWidget {
  final List<Stage>? liststages;
  final List<String>? listTokenStageDesbloqued;

  const CardPanelStages({
    super.key,
    this.liststages,
    this.listTokenStageDesbloqued,
  });

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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white,
          width: 1.0,
        ),
      ),
      height:
          MediaQuery.of(context).size.height * 0.50, // 50% da altura da tela,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(10),
      child: Card(
        color: const Color(0xFF212A3E),
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
              backgrundColor: const Color(0xFF523B76),
              circleColor: const Color(0xFF212A3E),
              textColor: Colors.white,
            );
          },
        ),
      ),
    );
  }
}
