import 'package:flutter/material.dart';

TextField inputField(TextEditingController controller, String hint,
    {int lines = 1}) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      filled: true,
      fillColor: Colors.white,
    ),
    minLines: lines,
    maxLines: 5,
  );
}
