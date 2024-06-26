import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String title;
  final IconData icon;
  final Function onPressed;
  final bool isPressed;

  const CustomButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onPressed, required this.isPressed,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {


  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
      widget.onPressed();
      },
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        side: MaterialStateProperty.all(const BorderSide(
          color: Colors.grey,
          width: 1,
        )),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
        )),
        backgroundColor: MaterialStateProperty.all<Color>(widget.isPressed? Colors.blue: Colors.white),
      ),
      icon: Icon(
        widget.icon,
        color: widget.isPressed? Colors.white: Colors.grey[600],
        size: 16,
      ),
      label: Text(
        widget.title,
        style: TextStyle(color: widget.isPressed? Colors.white: Colors.grey[600], fontSize: 12),
      ),
    );
  }
}
