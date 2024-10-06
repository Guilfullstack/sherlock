import 'package:flutter/material.dart';

class GameCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const GameCard({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Card(
          color: const Color(0xFF523B76),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 10),
              Image.asset(
                imagePath,
                height: 220,
                width: 120,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
