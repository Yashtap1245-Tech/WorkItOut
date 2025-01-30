import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RepetitionsInput extends StatelessWidget {
  final TextEditingController controller;

  RepetitionsInput({Key? key}) : controller = TextEditingController(), super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Repetitions Completed',
        hintText: 'Enter Number of repetitions',
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly, // Only allow digits
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter Number of repetitions';
        }
        return null;
      },
    );
  }
}
