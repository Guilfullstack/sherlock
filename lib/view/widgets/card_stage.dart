import 'package:flutter/material.dart';
import 'package:sherlock/model/stage.dart';

class CardStage extends StatelessWidget {
  final Stage stage;
  final bool isUnlocked;
  final int position;

  const CardStage({
    super.key,
    required this.stage,
    required this.isUnlocked,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white,
          width: 1.0,
        ),
      ),
      child: ListTile(
        title: Text(
          stage.description ?? '',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.grey,
          child: Text(
            '$position',
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        trailing: isUnlocked
            ? const Icon(
                Icons.check_circle,
                color: Colors.green,
              )
            : const Icon(
                Icons.lock,
                color: Colors.red,
              ),
      ),
    );
  }
}
