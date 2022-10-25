import 'package:flutter/material.dart';

const colorConst = Colors.blue;
class MyButton extends StatefulWidget {
  final Color color;
  final double width;
  final double height;
  final String text;
  final Color textColor;
  final VoidCallback onPressed;
  final bool isEnable;

  const MyButton({super.key, this.color = colorConst, this.width = double.infinity, this.height = 50, required this.text, this.textColor = Colors.white, required this.onPressed, this.isEnable = false});



  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        widget.onPressed();
      },
      child: Container(
        decoration: BoxDecoration(
          color: widget.isEnable ? widget.color : Colors.grey,
          borderRadius: BorderRadius.circular(32),
        ),
        width: widget.width,
        height: widget.height,
        child: Center(
          child: Text(widget.text,style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: widget.textColor,
          ),),
        ),
      ),
    );
  }
}
