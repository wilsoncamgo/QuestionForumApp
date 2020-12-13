import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  DefaultButton({this.onPressed, this.contentText});
  final onPressed;
  final contentText;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: onPressed,
        child: Text(contentText),
      ),
    );
  }
}
