import 'package:flutter/material.dart';

class RoundedRectangularButton extends StatelessWidget {
  final VoidCallback onPressed;

  final String label;

  final Color labelColor;

  final Color color;

  const RoundedRectangularButton(
      {Key key, this.onPressed, this.label, this.labelColor, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          primary: color ?? Colors.white,
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(
            color: labelColor ?? Color(0xFF004aaa),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
