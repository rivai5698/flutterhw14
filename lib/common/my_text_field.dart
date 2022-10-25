import 'package:flutter/material.dart';

const textCapitalizationConst = TextCapitalization.sentences;
class MyTextField extends StatefulWidget {
  final String? text;
  final String? hintText;
  final TextInputType textInputType;
  final TextEditingController textEditingController;
  final int maxLength;
  final bool obscureText;
  final bool readonly;
  final String? inputCheck;
  final TextCapitalization textCapitalization;
  final int maxLines,minLines;
  final bool autofocus;
  final TextInputAction textInputAction;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final Function()? onTap;
  final GestureDetector? icon;
  const MyTextField({super.key,  this.text, this.textInputType = TextInputType.text, this.maxLength = 100, this.obscureText = false, this.textCapitalization = textCapitalizationConst, this.maxLines = 1, this.minLines = 1, required this.textEditingController, this.textInputAction=TextInputAction.next, this.onSubmitted,this.onChanged, this.onTap,this.inputCheck ,this.readonly = false,this.autofocus=false,this.icon,this.hintText});



  @override
  State<MyTextField> createState() => _MyTextFieldsState();
}

class _MyTextFieldsState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
        autofocus: widget.autofocus,
        textCapitalization: widget.textCapitalization,
        keyboardType: widget.textInputType,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        maxLength: widget.maxLength,
        obscureText: widget.obscureText,
        controller: widget.textEditingController,
        autocorrect: false,
        textInputAction: widget.textInputAction,
        onSubmitted: widget.onSubmitted,
        onTap: widget.onTap,
        readOnly: widget.readonly,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: widget.hintText,
          suffixIcon: widget.icon,
          counterText: widget.inputCheck,
          counterStyle: const TextStyle(color: Colors.blue),
          labelText: widget.text,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
          ),
        ),
    );
  }
}
