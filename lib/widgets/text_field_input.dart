import 'package:flutter/material.dart';
import 'package:indgram/main.dart';

class TextFieldInput extends StatelessWidget {

  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  final Icon icon;

  const TextFieldInput({Key? key, 
    required this.textEditingController, 
    this.isPass = false, 
    required this.hintText, 
    required this.icon, 
    required this.textInputType
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
      borderRadius: BorderRadius.circular(screenWidth!*0.01),
    );

    return TextField(
      controller: textEditingController,
      keyboardType: TextInputType.text,
      maxLines: 1,
      decoration: InputDecoration(
        prefixIcon: icon,
        hintText: hintText,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: EdgeInsets.all(screenWidth!*0.005),
      ),
      obscureText: isPass,
    );
  }
}