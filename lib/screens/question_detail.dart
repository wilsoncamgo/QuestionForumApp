import 'package:flutter/material.dart';
import 'package:questionforum/logic/api_service.dart';
import 'package:questionforum/logic/user_service.dart';
import 'package:questionforum/models/answer.dart';
import 'package:questionforum/models/question.dart';
import 'package:questionforum/models/user.dart';
import 'package:questionforum/screens/common_widgets/logo.dart';
import 'package:provider/provider.dart';
import 'package:questionforum/screens/confirmation_screen.dart';

class QuestionDetail extends StatefulWidget {
  const QuestionDetail({Key key, this.question, this.authorName})
      : super(key: key);
  final Question question;
  final String authorName;

  @override
  _QuestionDetailState createState() => _QuestionDetailState();
}

class _QuestionDetailState extends State<QuestionDetail> {
  ApiService _apiService;
  final _formKey = GlobalKey<FormState>();
  String answer = "";
  FocusNode myFocusNode;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._apiService = ApiService();
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserService>().getUser;
    return Scaffold(
      appBar: AppBar(
        title: Logo(),
        actions: [
          InkWell(
            child: Icon(
              Icons.menu,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.question_answer),
              title: Text("Respondiendo como: " +
                  context.watch<UserService>().getUser.name),
              subtitle: Form(
                key: _formKey,
                child: TextFormField(
                  cursorColor: Colors.black,
                  focusNode: myFocusNode,
                  decoration: new InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "Coloca tu respuesta aca"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Por favor coloca una respuesta valida';
                    }
                    return null;
                  },
                  onSaved: (newValue) => answer = newValue,
                ),
              ),
            ),
            TextButton(
              child: Text('Responder a ' + this.widget.authorName),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  Answer answer = new Answer(
                      answer: this.answer,
                      dateSumb: DateTime.now(),
                      questionId: widget.question.id,
                      userId: user.id);
                  int status = await this._apiService.createAnswer(answer);
                  if (status == 201) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ConfirmationScreen(typeMessage: 3),
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Detalle de la pregunta: "),
              Center(
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.question_answer),
                        title: Text(this.widget.question.question),
                        subtitle: Text(this.widget.authorName),
                      ),
                      TextButton(
                        child: Text('Responder a ' + this.widget.authorName),
                        onPressed: () => myFocusNode.requestFocus(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<List<Answer>>(
              future: _apiService
                  .fetchAnswersbyQuestionId(widget.question.id.toString()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: 800,
                    child: FractionallySizedBox(
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
                    ),
                  );
                }
                if (snapshot.hasData) {
                  return ListView(
                    shrinkWrap: true,
                    children: snapshot.data
                        .map((answer) => ListTile(
                              leading: Icon(Icons.supervised_user_circle),
                              title: Text(answer.answer),
                              subtitle: FutureBuilder<User>(
                                future: context
                                    .watch<UserService>()
                                    .fetchUserbyId(answer.userId),
                                builder: (context, snapshotAuthor) {
                                  if (snapshotAuthor.connectionState ==
                                      ConnectionState.waiting) {
                                    return Text(
                                        "Estamos cargando al autor de la respuesta");
                                  }
                                  if (snapshotAuthor.hasData) {
                                    return Text(
                                        "por: " + snapshotAuthor.data.name);
                                  } else if (snapshotAuthor.hasError) {
                                    return Text("${snapshotAuthor.error}");
                                  }
                                  return Text("por:  Autor Anonimo");
                                },
                              ),
                              trailing: Icon(Icons.add),
                            ))
                        .toList(),
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return Text(
                    "No hay ninguna respuesta aún, \n Se el primero en responder!");
              },
            ),
          ),
        ],
      ),
    );
  }
}
