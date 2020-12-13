import 'package:flutter/material.dart';
import 'package:questionforum/screens/login_screen.dart';

class OpenScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          ),
          child: Column(
            children: [
              Icon(Icons.question_answer),
              Text('Bienvenido a Preguntando\n Toca la pantalla para empezar'),
            ],
          ),
        ),
      ),
    );
  }
}
