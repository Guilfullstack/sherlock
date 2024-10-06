// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:sherlock/controller/play_controller.dart';
import 'package:sherlock/model/user_team.dart';
import 'package:sherlock/view/widgets/card_play.dart';

class CardPanelInfo extends StatefulWidget {
  final double credit;
  final Status status;
  final bool useCardFrezee;
  final bool useCardProtect;

  const CardPanelInfo({
    super.key,
    required this.credit,
    required this.status,
    required this.useCardFrezee,
    required this.useCardProtect,
  });
  @override
  State<CardPanelInfo> createState() => _CardPanelInfoState();
}

class _CardPanelInfoState extends State<CardPanelInfo> {
  PlayController playController = PlayController();
  late Color cortexto = Colors.white;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF523B76),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(40),
      ),
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Pontos:  ',
                  style: TextStyle(color: cortexto, fontSize: 18),
                ),
                Text(
                  '${widget.credit}',
                  style: TextStyle(color: cortexto, fontSize: 18),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(right: 100),
              child: Divider(
                color: Colors.purple,
                thickness: 2,
                //height: 30,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    text: 'Status:  ', // Texto comum, sem cor específica
                    style: TextStyle(
                        color: cortexto,
                        fontSize: 18), // Estilo do texto padrão
                    children: [
                      TextSpan(
                        text: playController.statusToString(
                            widget.status), // Apenas a variável status
                        style: widget.status == Status.Jogando
                            ? const TextStyle(color: Colors.white, fontSize: 18)
                            : widget.status == Status.Congelado
                                ? const TextStyle(
                                    color: Colors.blueAccent, fontSize: 18)
                                : const TextStyle(
                                    color: Colors.green, fontSize: 18),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(right: 100),
              child: Divider(
                color: Colors.purple,
                thickness: 2,
                //height: 30,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Cartas:',
                  style: TextStyle(color: cortexto, fontSize: 18),
                ),
                const SizedBox(width: 20),
                CardPlay(
                    src: 'images/congelar.png',
                    tipo: CartaTipo.congelar,
                    isUsed: widget.useCardFrezee),
                const SizedBox(width: 20),
                CardPlay(
                    src: 'images/escudo.png',
                    tipo: CartaTipo.escudo,
                    isUsed: widget.useCardProtect),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
