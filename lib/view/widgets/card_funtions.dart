import 'package:flutter/material.dart';

class CardFuntions extends StatelessWidget {
  final IconData icon;
  final String nome;
  final VoidCallback onTap;

  const CardFuntions({
    super.key,
    required this.icon,
    required this.nome,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.white.withOpacity(0.5), // Cor do splash
      borderRadius: BorderRadius.circular(10.0),
      child: Card(
        color: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(
            color: Colors.blueAccent, // Cor da borda
            width: 1.0, // Largura da borda
          ),
        ),
        child: SizedBox(
          height: 100,
          width: 120,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 50,
                  color: Colors.blue,
                ),
                const SizedBox(height: 8),
                Text(
                  nome,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
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
