import 'package:flutter/material.dart';
class RepetitionsInput extends StatelessWidget {
  final int counter;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const RepetitionsInput({
    required this.counter,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: TextEditingController(text: '$counter'),
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'Repetitions Completed',
            hintText: 'Repetitions: $counter',
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: onDecrement,
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: onIncrement,
            ),
          ],
        ),
      ],
    );
  }
}