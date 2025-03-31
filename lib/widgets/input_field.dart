import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType inputType;
  final List<TextInputFormatter>? formatters;

  const InputField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.inputType,
    this.formatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      keyboardType: inputType,
      inputFormatters: formatters,
    );
  }
}