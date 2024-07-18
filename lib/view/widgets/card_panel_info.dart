// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:sherlock/model/user_team.dart';
import 'package:sherlock/view/widgets/card_play.dart';

class CardPanelInfo extends StatefulWidget {
  final double credit;
  final Status status;

  CardPanelInfo({
    Key? key,
    required this.credit,
    required this.status,
  }) : super(key: key);
  @override
  State<CardPanelInfo> createState() => _CardPanelInfoState();
}

class _CardPanelInfoState extends State<CardPanelInfo> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[800],
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Saldo:',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(
                  width: 25,
                ),
                Text(
                  'R\$ ${widget.credit}',
                  style: const TextStyle(color: Colors.purple, fontSize: 20),
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
                const Text(
                  'Status:',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(width: 8),
                Text(
                  '${widget.status}',
                  style: TextStyle(color: Colors.pink, fontSize: 18),
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
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Cartas:',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(width: 20),
                CardPlay(
                    src: 'images/logo.png',
                    tipo: CartaTipo.congelar,
                    isUsed: true),
                SizedBox(width: 20),
                CardPlay(
                    src: 'images/logo.png',
                    tipo: CartaTipo.escudo,
                    isUsed: true),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
