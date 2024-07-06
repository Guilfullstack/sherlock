import 'package:flutter/material.dart';

class Challenge extends StatelessWidget {
  final String name;
  final bool isUnlocked;

  const Challenge({
    Key? key,
    required this.name,
    required this.isUnlocked,
  }) : super(key: key);

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
          name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.grey,
          child: Text(
            '1',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        trailing: isUnlocked
            ? Icon(
                Icons.check_circle,
                color: Colors.green,
              )
            : Icon(
                Icons.lock,
                color: Colors.red,
              ),
      ),
    );
  }
}
