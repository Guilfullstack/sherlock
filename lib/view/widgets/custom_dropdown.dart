import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final String? value;
  final List<String> items;
  final String? title;
  final Function(String?)? onChanged;
  const CustomDropdown(
      {super.key, this.onChanged, this.title, required this.items, this.value});

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      dropdownColor: Colors.black,
      value: widget.value,
      hint: Text(widget.title ?? ""),
      items: widget.items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: const TextStyle(color: Colors.white),
          ),
        );
      }).toList(),
      onChanged: widget.onChanged,
    );
  }
}
