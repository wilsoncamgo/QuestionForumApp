import 'package:flutter/material.dart';
import 'package:questionforum/models/user.dart';
import 'package:questionforum/screens/common_widgets/button.dart';
import 'package:questionforum/screens/common_widgets/logo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'menu_screeen.dart';

class NameSetup extends StatelessWidget {
  NameSetup({Key key, @required this.user}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  String name = "";
  final User user;

  Future<int> createUser(User user) async {
    final http.Response response =
        await http.post('https://askansproject.herokuapp.com/users',
            body: user.toJson(),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/x-www-form-urlencoded"
            },
            encoding: Encoding.getByName("utf-8"));
    if (response.statusCode == 201) {
      return response.statusCode;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to load user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Logo(),
              FractionallySizedBox(
                widthFactor: 0.5,
                alignment: Alignment.center,
                child: TextFormField(
                  cursorColor: Colors.black,
                  decoration: new InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "Ingresa tu nombre"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Por favor coloca tu nombre para continuar';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    this.user.name = newValue;
                  },
                ),
              ),
              DefaultButton(
                contentText: "Haz tu primera pregunta!",
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    int status = await this.createUser(user);
                    if (status == 201) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MenuScreen(),
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
