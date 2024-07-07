import 'package:flutter/material.dart';

class CardFuntions extends StatelessWidget {
  final IconData icon;
  final String nome;
  final VoidCallback onTap;

  const CardFuntions({
    Key? key,
    required this.icon,
    required this.nome,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.white.withOpacity(0.5), // Cor do splash
      borderRadius: BorderRadius.circular(10.0),
      child: Card(
        color: Colors.grey[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(
            color: Colors.white, // Cor da borda
            width: 1.0, // Largura da borda
          ),
        ),
        child: SizedBox(
          height: 130,
          width: 150,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 50,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Text(
                  nome,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
