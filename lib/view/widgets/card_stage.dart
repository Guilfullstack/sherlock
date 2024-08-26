import 'package:flutter/material.dart';
import 'package:sherlock/controller/tools_controller.dart';
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
    return InkWell(
      onTap: isUnlocked
          ? () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    contentPadding: EdgeInsets.zero,
                    content: Container(
                      width: 300, // Define a largura do container
                      height: 400, // Define a altura do container
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'images/eniguima2.jpg'), // Caminho da imagem

                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Enigma",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              stage.puzzle ?? '',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          : () => ToolsController.scafoldMensage(
              context, Colors.red, 'Prova bloqueada'),
      child: Container(
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
      ),
    );
  }
}
