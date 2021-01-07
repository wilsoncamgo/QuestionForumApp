import 'package:flutter/material.dart';
import 'package:questionforum/logic/api_service.dart';
import 'package:questionforum/logic/user_service.dart';
import 'package:questionforum/models/question.dart';
import 'package:questionforum/models/topic.dart';
import 'package:questionforum/models/user.dart';
import 'package:questionforum/screens/common_widgets/logo.dart';

import 'package:provider/provider.dart';

import 'package:questionforum/screens/create_question.dart';
import 'package:questionforum/screens/profile_general_view.dart';
import 'package:questionforum/screens/question_detail.dart';

class MenuScreen extends StatefulWidget {
  MenuScreen({Key key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  ApiService _apiService;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._apiService = ApiService();
  }

  @override
  Widget build(BuildContext context) {
    String authorName = "";
    showAlertDialog(BuildContext context) {
      // set up the buttons
      Widget cancelButton = FlatButton(
        child: Text("Regresar"),
        onPressed: () => Navigator.pop(context),
      );
      Widget continueButton = FlatButton(
        child: Text("Cerrar Sesión"),
        onPressed: () {
          context.read<UserService>().dispose();
          Navigator.popUntil(context, ModalRoute.withName('/'));
        },
      );
      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Saliendo de tu cuenta"),
        content: Text("Deseas cerrar sesión?"),
        actions: [
          cancelButton,
          continueButton,
        ],
      );
      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    return FutureBuilder<List<Topic>>(
      future: this._apiService.fetchTopics(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return DefaultTabController(
            length: snapshot.data.length,
            child: Scaffold(
              appBar: AppBar(
                title: Logo(),
                leading: Builder(builder: (BuildContext context) {
                  return InkWell(
                    onTap: () => showAlertDialog(context),
                    child: Icon(Icons.arrow_back_ios),
                  );
                }),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(30.0),
                  child: TabBar(
                    isScrollable: true,
                    tabs: snapshot.data
                        .map(
                          (topic) => new Tab(
                            text: topic.topic,
                          ),
                        )
                        .toList(),
                  ),
                ),
                actions: [
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileGeneralView(),
                      ),
                    ),
                    child: Icon(
                      Icons.menu,
                    ),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateQuestion(),
                  ),
                ),
                child: const Icon(Icons.question_answer_outlined),
              ),
              body: TabBarView(
                children: snapshot.data
                    .map((topic) => FutureBuilder<List<Question>>(
                          future: this
                              ._apiService
                              .fetchQuestionsbyTopic(topic.number.toString()),
                          builder: (context, snapshotTopics) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
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
                            if (snapshotTopics.hasData) {
                              return ListView(
                                children: snapshotTopics.data
                                    .map((question) => ListTile(
                                          onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  QuestionDetail(
                                                authorName: authorName,
                                                question: question,
                                              ),
                                            ),
                                          ),
                                          leading: Icon(Icons.question_answer),
                                          title: Text(question.question),
                                          subtitle: FutureBuilder<User>(
                                            future: context
                                                .watch<UserService>()
                                                .fetchUserbyId(question.userId),
                                            builder: (context, snapshotAuthor) {
                                              if (snapshotAuthor
                                                      .connectionState ==
                                                  ConnectionState.waiting) {
                                                return Text(
                                                    "Estamos cargando al autor de la pregunta");
                                              }
                                              if (snapshotAuthor.hasData) {
                                                authorName =
                                                    snapshotAuthor.data.name;
                                                return Text("por: " +
                                                    snapshotAuthor.data.name);
                                              } else if (snapshotAuthor
                                                  .hasError) {
                                                return Text(
                                                    "${snapshotAuthor.error}");
                                              }
                                              return Text(
                                                  "por:  Autor Anonimo");
                                            },
                                          ),
                                          trailing:
                                              Icon(Icons.arrow_forward_ios),
                                        ))
                                    .toList(),
                              );
                            } else if (snapshotTopics.hasError) {
                              return Text("${snapshotTopics.error}");
                            }

                            return Center(
                              child: Text(
                                  'Aun no hay ninguna pregunta, se el primero en hacer una!'),
                            );
                          },
                        ))
                    .toList(),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
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
      },
    );
  }
}
