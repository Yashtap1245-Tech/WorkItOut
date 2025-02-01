import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WeightInput extends StatefulWidget {
  final TextEditingController controller;

  const WeightInput({required this.controller});

  @override
  _WeightInputState createState() => _WeightInputState();
}

class _WeightInputState extends State<WeightInput> {
  final List<int> _weightOptions = [100, 150, 200];
  int? _selectedWeight;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: "Weight Lifted",
            hintText: "Enter Weight lifted in Kg",
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Enter Weight lifted in Kg";
            }
            return null;
          },
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 10,
          children: _weightOptions.map((weight) {
            return ChoiceChip(
              label: Text("$weight kg"),
              selected: _selectedWeight == weight,
              onSelected: (selected) {
                setState(() {
                  _selectedWeight = selected ? weight : null;
                  widget.controller.text = _selectedWeight?.toString() ?? '';
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
