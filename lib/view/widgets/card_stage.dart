import 'package:flutter/material.dart';

import 'package:sherlock/controller/tools_controller.dart';
import 'package:sherlock/model/stage.dart';

class CardStage extends StatelessWidget {
  final Stage stage;
  final bool isUnlocked;
  final Color? backgrundColor;
  final Color? textColor;

  const CardStage({
    super.key,
    required this.stage,
    required this.isUnlocked,
    this.backgrundColor,
    this.textColor,
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
                            Text(
                              stage.description ?? '',
                              style: const TextStyle(
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
          color: backgrundColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.white,
            //width: 1.0,
          ),
        ),
        child: ListTile(
          title: Text(
            stage.description ?? '',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: textColor,
            ),
          ),
          leading: const CircleAvatar(
              child: Icon(
            Icons.search,
            color: Colors.purple,
            size: 30,
          )),
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
