import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  DefaultButton({this.onPressed, this.contentText});
  final onPressed;
  final contentText;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Text(
          contentText,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
