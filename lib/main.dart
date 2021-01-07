import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:questionforum/logic/user_service.dart';
import 'package:questionforum/models/user.dart';
import 'package:questionforum/screens/open_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider<UserService>(
      create: (_) => UserService(),
      child: MaterialApp(
        title: 'Preguntando App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: OpenScreen(),
      ),
    );
  }
}
