import 'package:flutter/material.dart';

class ImputTextFormField extends StatelessWidget {
  final String title;
  final TextEditingController controller;

  const ImputTextFormField(
      {super.key, required this.title, required this.controller});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.7, // Define 50% da largura da tela
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, preencha este campo';
          }
          return null;
        },
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: title,
          labelStyle: const TextStyle(color: Colors.white),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.purple),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.purple),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.purple),
          ),
        ),
      ),
    );
  }
}
