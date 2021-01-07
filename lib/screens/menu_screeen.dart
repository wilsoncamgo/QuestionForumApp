import 'package:flutter/material.dart';
import 'package:questionforum/logic/api_service.dart';
import 'package:questionforum/logic/user_service.dart';
import 'package:questionforum/models/question.dart';
import 'package:questionforum/models/topic.dart';
import 'package:questionforum/models/user.dart';
import 'package:questionforum/screens/common_widgets/logo.dart';

import 'package:provider/provider.dart';

import 'package:questionforum/screens/create_question.dart';

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
    final user = context.watch<UserService>().getUser;
    return FutureBuilder<List<Topic>>(
      future: this._apiService.fetchTopics(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return DefaultTabController(
            length: snapshot.data.length,
            child: Scaffold(
              appBar: AppBar(
                title: Logo(),
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
                                          leading: Icon(Icons.question_answer),
                                          title: Text(question.question),
                                          subtitle: Text('por: ' + user.name),
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

                            // By default, show a loading spinner.
                          },
                        ))
                    .toList(),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        // By default, show a loading spinner.
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
