import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImputTextFormField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final FormFieldValidator? validator;
  final Function(String)? onFieldSubmitted;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final bool? enabled;
  final bool? obscure;
  final Widget? icon;
  final int? maxLines;
  const ImputTextFormField({
    super.key,
    required this.title,
    required this.controller,
    this.validator,
    this.enabled,
    this.obscure,
    this.icon,
    this.maxLines,
    this.onFieldSubmitted,
    this.focusNode,
    this.keyboardType,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.7, // Define 50% da largura da tela
      child: TextFormField(
        minLines: 1,
        maxLines: maxLines ?? 1,
        obscureText: obscure ?? false,
        onFieldSubmitted: onFieldSubmitted,
        focusNode: focusNode,
        validator: validator ??
            (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, preencha este campo';
              }
              return null;
            },
        controller: controller,
        style: const TextStyle(color: Colors.white),
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          suffixIcon: icon,
          enabled: enabled ?? true,
          labelText: title,
          labelStyle: const TextStyle(color: Colors.white),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
      ),
    );
  }
}
