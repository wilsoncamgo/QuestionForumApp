import 'package:flutter/material.dart';
import 'package:questionforum/screens/login_screen.dart';

class OpenScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Tested and working
    return Material(
      child: Container(
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.question_answer,
                size: 100,
              ),
              Text(
                'Bienvenido a Preguntando\n Toca la pantalla para empezar',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
