import 'package:flutter/material.dart';
import 'package:sherlock/view/widgets/card_play.dart';

class CardPanelInfo extends StatefulWidget {
  const CardPanelInfo({super.key});

  @override
  State<CardPanelInfo> createState() => _CardPanelInfoState();
}

class _CardPanelInfoState extends State<CardPanelInfo> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[800],
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Saldo:',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(
                  width: 25,
                ),
                Text(
                  'R\$ 20,00',
                  style: TextStyle(color: Colors.purple, fontSize: 20),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(right: 100),
              child: Divider(
                color: Colors.purple,
                thickness: 2,
                //height: 30,
              ),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Status:',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(width: 8),
                Text(
                  'Em jogo',
                  style: TextStyle(color: Colors.pink, fontSize: 18),
                ),
              ],
            ),
            Padding(
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
