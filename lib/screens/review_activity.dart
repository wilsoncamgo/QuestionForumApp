import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:questionforum/logic/api_service.dart';
import 'package:questionforum/logic/user_service.dart';
import 'package:questionforum/models/answer.dart';
import 'package:questionforum/models/question.dart';
import 'package:questionforum/models/user.dart';
import 'package:questionforum/screens/common_widgets/logo.dart';
import 'package:provider/provider.dart';

class ReviewActivity extends StatefulWidget {
  ReviewActivity({Key key, this.type}) : super(key: key);
  final int type;

  @override
  _ReviewActivityState createState() => _ReviewActivityState();
}

class _ReviewActivityState extends State<ReviewActivity> {
  ApiService _apiService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._apiService = ApiService();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserService>().getUser;
    return Scaffold(
      appBar: AppBar(
        title: Logo(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          widget.type == 1 ? buildQuestion(user) : buildAnswer(user),
        ],
      ),
    );
  }

  Widget buildQuestion(User user) {
    return Expanded(
      child: FutureBuilder<List<Question>>(
        future: this._apiService.fetchQuestionsbyUserId(user.id),
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
            List<Question> myQuestions = List<Question>.from(snapshot.data);
            return ListView.builder(
              itemCount: myQuestions.length,
              itemBuilder: (context, index) {
                final question = myQuestions[index];
                return Dismissible(
                  key: Key(
                    question.id.toString(),
                  ),
                  background: Container(
                    color: Colors.lightBlue,
                    child: Icon(Icons.update),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    child: Icon(Icons.delete),
                  ),
                  confirmDismiss: (DismissDirection direction) async {
                    //DELETE
                    if (direction == DismissDirection.endToStart) {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Confirmacion"),
                            content: const Text(
                                "Estas seguro de eliminar esta pregunta?"),
                            actions: <Widget>[
                              FlatButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text("Eliminar")),
                              FlatButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text("Cancelar"),
                              ),
                            ],
                          );
                        },
                      );
                    }
                    //UPDATE
                    if (direction == DismissDirection.startToEnd) {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Confirmacion"),
                            content:
                                const Text("Vamos a actualizar esta pregunta"),
                            actions: <Widget>[
                              FlatButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text("Actualizar")),
                              FlatButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text("Cancelar"),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  onDismissed: (direction) async {
                    //DELETE
                    if (direction == DismissDirection.endToStart) {
                      setState(() {
                        myQuestions.removeAt(index);
                      });
                      this._apiService.deleteQuestion(question.id.toString());
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Confirmacion"),
                            content:
                                const Text("Pregunta eliminada correctamente"),
                            actions: <Widget>[
                              FlatButton(
                                  onPressed: () {
                                    setState(() {});
                                    Navigator.of(context).pop(true);
                                  },
                                  child: const Text("Aceptar")),
                            ],
                          );
                        },
                      );
                    }
                    //UPDATE
                    if (direction == DismissDirection.startToEnd) {}
                  },
                  child: ListTile(
                    leading: Icon(Icons.question_answer),
                    title: Text(question.question),
                    subtitle: Text("Realizada el dia: " +
                        DateFormat("yyyy-MM-dd").format(question.dateSumb) +
                        "  Pertenece al tema numero " +
                        question.topicId.toString()),
                    isThreeLine: true,
                  ),
                );
              },
            );
            return ListView(
              children: snapshot.data
                  .map(
                    (question) => Dismissible(
                      key: Key(
                        question.id.toString(),
                      ),
                      background: Container(
                        color: Colors.lightBlue,
                        child: Icon(Icons.update),
                      ),
                      secondaryBackground: Container(
                        color: Colors.lightBlue,
                        child: Icon(Icons.delete),
                      ),
                      confirmDismiss: (DismissDirection direction) async {
                        //DELETE
                        if (direction == DismissDirection.endToStart) {
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Confirmacion"),
                                content: const Text(
                                    "Estas seguro de eliminar esta pregunta?"),
                                actions: <Widget>[
                                  FlatButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const Text("Eliminar")),
                                  FlatButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text("Cancelar"),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                        //UPDATE
                        if (direction == DismissDirection.startToEnd) {
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Confirmacion"),
                                content: const Text(
                                    "Vamos a actualizar esta pregunta"),
                                actions: <Widget>[
                                  FlatButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const Text("Actualizar")),
                                  FlatButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text("Cancelar"),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      onDismissed: (direction) {
                        //DELETE
                        if (direction == DismissDirection.endToStart) {}
                        //UPDATE
                        if (direction == DismissDirection.startToEnd) {}
                      },
                      child: ListTile(
                        leading: Icon(Icons.question_answer),
                        title: Text(question.question),
                        subtitle: Text("Realizada el dia: " +
                            DateFormat("yyyy-MM-dd").format(question.dateSumb) +
                            "  Pertenece al tema numero " +
                            question.topicId.toString()),
                        isThreeLine: true,
                      ),
                    ),
                  )
                  .toList(),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(
            child:
                Text('Aun no has hecho la primera pregunta, vamos, animate!'),
          );
        },
      ),
    );
  }

  Widget buildAnswer(User user) {
    return Expanded(
      child: FutureBuilder<List<Answer>>(
        future: this._apiService.fetchAnswersbyUserId(user.id),
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
            List<Answer> myAnswers = List<Answer>.from(snapshot.data);
            return ListView.builder(
              itemCount: myAnswers.length,
              itemBuilder: (context, index) {
                final answer = myAnswers[index];
                return Dismissible(
                  key: Key(
                    answer.id.toString(),
                  ),
                  background: Container(
                    color: Colors.lightBlue,
                    child: Icon(Icons.update),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    child: Icon(Icons.delete),
                  ),
                  confirmDismiss: (DismissDirection direction) async {
                    //DELETE
                    if (direction == DismissDirection.endToStart) {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Confirmacion"),
                            content: const Text(
                                "Estas seguro de eliminar esta respuesta?"),
                            actions: <Widget>[
                              FlatButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text("Eliminar")),
                              FlatButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text("Cancelar"),
                              ),
                            ],
                          );
                        },
                      );
                    }
                    //UPDATE
                    if (direction == DismissDirection.startToEnd) {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Confirmacion"),
                            content:
                                const Text("Vamos a actualizar esta respuesta"),
                            actions: <Widget>[
                              FlatButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text("Actualizar")),
                              FlatButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text("Cancelar"),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  onDismissed: (direction) async {
                    //DELETE
                    if (direction == DismissDirection.endToStart) {
                      setState(() {
                        myAnswers.removeAt(index);
                      });
                      this._apiService.deleteAnswer(answer.id.toString());
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Confirmacion"),
                            content:
                                const Text("Respuesta eliminada correctamente"),
                            actions: <Widget>[
                              FlatButton(
                                  onPressed: () {
                                    setState(() {});
                                    Navigator.of(context).pop(true);
                                  },
                                  child: const Text("Aceptar")),
                            ],
                          );
                        },
                      );
                    }
                    //UPDATE
                    if (direction == DismissDirection.startToEnd) {}
                  },
                  child: ListTile(
                    leading: Icon(Icons.question_answer),
                    title: Text(answer.answer),
                    subtitle: Text("Realizada el dia: " +
                        DateFormat("yyyy-MM-dd").format(answer.dateSumb) +
                        "  Pertenece a la pregunta numero" +
                        answer.questionId.toString()),
                    isThreeLine: true,
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(
            child:
                Text('Aun no has hecho la primera respuesta, vamos, animate!'),
          );
        },
      ),
    );
  }
}
