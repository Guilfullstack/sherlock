import 'package:flutter/material.dart';

enum CartaTipo { escudo, congelar }

class CardPlay extends StatelessWidget {
  final String src;
  final bool isUsed;
  final CartaTipo tipo;
  const CardPlay({
    super.key,
    required this.src,
    required this.isUsed,
    required this.tipo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 70,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        border: Border.all(
          color: Colors.white, // Cor da borda
          width: 1.0, // Largura da borda
        ),
        //borderRadius: BorderRadius.circular(5.0), // Bordas arredondadas
      ),
      child: isUsed
          ? Image.asset(
              src,
              fit: BoxFit.cover,
            )
          : const Center(
              child: Icon(
                Icons.add,
                size: 20,
                color: Colors.white,
              ),
            ),
    );
  }
}
