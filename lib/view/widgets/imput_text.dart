import 'package:flutter/material.dart';

class ImputTextFormField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final FormFieldValidator? validator;
  final bool? enabled;
  final bool? obscure;
  final Widget? icon;
  final int? maxLines;
  const ImputTextFormField(
      {super.key,
      required this.title,
      required this.controller,
      this.validator,
      this.enabled,
      this.obscure,
      this.icon,
      this.maxLines});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.7, // Define 50% da largura da tela
      child: TextFormField(
        minLines: 1,
        maxLines: maxLines ?? 1,
        obscureText: obscure ?? false,
        validator: validator ??
            (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, preencha este campo';
              }
              return null;
            },
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          suffixIcon: icon,
          enabled: enabled ?? true,
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
