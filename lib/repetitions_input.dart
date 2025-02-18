import 'package:flutter/material.dart';

class RepetitionsInput extends StatelessWidget {
  final int counter;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final TextEditingController controller;

  const RepetitionsInput({
    Key? key,
    required this.counter,
    required this.onIncrement,
    required this.onDecrement,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: onDecrement,
        ),
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Repetitions',
              border: OutlineInputBorder(),
              hintText: '$counter',
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                controller.text = value;
              }
            },
          ),
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: onIncrement,
        ),
      ],
    );
  }
}
