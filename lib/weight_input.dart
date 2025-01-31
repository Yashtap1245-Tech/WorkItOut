import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WeightInput extends StatelessWidget {
  final TextEditingController controller;

  const WeightInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Weight Lifted",
        hintText: "Enter Weight lifted in Kg"
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly, // Only allow digits
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Enter Weight lifted in Kg";
        }
        return null;
      },
    );
  }
}
