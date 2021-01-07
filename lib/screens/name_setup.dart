import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:questionforum/logic/user_service.dart';
import 'package:questionforum/models/user.dart';
import 'package:questionforum/screens/common_widgets/button.dart';
import 'package:questionforum/screens/common_widgets/logo.dart';
import 'package:http/http.dart' as http;
import 'package:questionforum/screens/confirmation_screen.dart';
import 'dart:convert';
import 'dart:async';

import 'menu_screeen.dart';

class NameSetup extends StatelessWidget {
  NameSetup({Key key, @required this.user}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  String name = "";
  final User user;

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
                    int status =
                        await context.read<UserService>().createUser(user);
                    User userRetrieved = await context
                        .read<UserService>()
                        .fetchUserbyIdLogin(user.id);
                    if (status == 201 && userRetrieved != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ConfirmationScreen(typeMessage: 2),
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
