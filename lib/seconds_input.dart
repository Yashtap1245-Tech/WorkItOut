import 'package:flutter/material.dart';

class SecondsInput extends StatefulWidget {
  final int counter;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final TextEditingController controller;

  const SecondsInput({
    required this.counter,
    required this.onIncrement,
    required this.onDecrement,
    required this.controller,
  });

  @override
  _SecondsInputState createState() => _SecondsInputState();
}

class _SecondsInputState extends State<SecondsInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _controller.text = widget.counter.toString();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged(String value) {
    if (value.isNotEmpty) {
      final parsedValue = int.tryParse(value);
      if (parsedValue != null && parsedValue >= 0) {
        setState(() {
          widget.controller.text = parsedValue.toString();
        });
      } else {
        widget.controller.text = '0';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Seconds Completed',
            hintText: 'Seconds: ${widget.counter}',
          ),
          onChanged: _onTextChanged,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: widget.onDecrement,
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: widget.onIncrement,
            ),
          ],
        ),
      ],
    );
  }
}
