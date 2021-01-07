import 'package:flutter/material.dart';
import 'package:questionforum/logic/api_service.dart';
import 'package:questionforum/logic/user_service.dart';
import 'package:questionforum/models/question.dart';
import 'package:questionforum/models/topic.dart';
import 'package:questionforum/models/user.dart';
import 'package:questionforum/screens/common_widgets/button.dart';
import 'package:questionforum/screens/common_widgets/logo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:questionforum/screens/confirmation_screen.dart';

import 'package:questionforum/screens/menu_screeen.dart';

class CreateQuestion extends StatefulWidget {
  CreateQuestion({Key key}) : super(key: key);

  @override
  _CreateQuestionState createState() => _CreateQuestionState();
}

class _CreateQuestionState extends State<CreateQuestion> {
  final _formKey = GlobalKey<FormState>();
  Question question = new Question(
    id: null,
  );
  ApiService _apiService;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserService>().getUser;
    this._apiService = ApiService();
    return Material(
      child: Container(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Logo(),
              SizedBox(
                height: 400,
                child: FutureBuilder<List<Topic>>(
                  future: this._apiService.fetchTopics(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return FractionallySizedBox(
                        heightFactor: 0.15,
                        widthFactor: 0.3,
                        child: Stack(
                          alignment: Alignment.center,
                          fit: StackFit.expand,
                          children: [
                            CircularProgressIndicator(),
                            Icon(
                              Icons.question_answer,
                              size: 50,
                            ),
                          ],
                        ),
                      );
                    }
                    if (snapshot.hasData) {
                      return DropdownButton<String>(
                        items: snapshot.data
                            .map(
                              (e) => new DropdownMenuItem<String>(
                                value: e.number.toString(),
                                child: new Text(e.topic),
                              ),
                            )
                            .toList(),
                        onChanged: (String newValue) {
                          setState(() {
                            this.question.topicId = int.tryParse(newValue);
                          });
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    return Center(
                      child: Text('Aun no hay ningun tema, crea el primero!'),
                    );
                  },
                ),
              ),
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
                      hintText: "Coloca tu pregunta acá"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Por favor coloca una pregunta';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    this.question.question = newValue;
                  },
                ),
              ),
              DefaultButton(
                contentText: "Registra tu pregunta!",
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    this.question.dateSumb = DateTime.now();
                    this.question.userId = user.id;
                    int status =
                        await this._apiService.createQuestion(question);
                    if (status == 201) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ConfirmationScreen(typeMessage: 1),
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
