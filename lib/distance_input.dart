import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DistanceInput extends StatelessWidget {
  final TextEditingController controller;

  const DistanceInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          labelText: "Distance Walked", hintText: "Enter Distance in meters"),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please Enter Distance in km";
        }
        return null;
      },
    );
  }
}
