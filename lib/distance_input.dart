import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DistanceInput extends StatelessWidget {

  final TextEditingController controller;

  DistanceInput({Key ? key}) : controller = TextEditingController(), super(key : key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Distance Walked",
        hintText: "Enter Distance in km"
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly, // Only allow digits
      ],
      validator: (value) {
        if(value == null || value.isEmpty){
          return "Please Enter Distance in km";
        }
        return null;
      },
    );
  }

}
