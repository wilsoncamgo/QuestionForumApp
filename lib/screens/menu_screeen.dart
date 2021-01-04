import 'package:flutter/material.dart';
import 'package:questionforum/models/question.dart';
import 'package:questionforum/models/topic.dart';
import 'package:questionforum/screens/common_widgets/logo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class MenuScreen extends StatefulWidget {
  MenuScreen({Key key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  Future<List<Topic>> fetchTopics() async {
    final response =
        await http.get('http://askansproject.herokuapp.com/topics');
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        List<Topic> topics = new List<Topic>();
        for (Map<String, dynamic> topicMap in data) {
          topics.add(Topic.fromJson(topicMap));
        }
        return topics;
      }
      return null;
    } else {
      throw Exception('Failed to load topics');
    }
  }

  Future<int> createQuestion(Question question) async {
    final http.Response response =
        await http.post('https://askansproject.herokuapp.com/question',
            body: question.toJson(),
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

  Future<List<Question>> fetchQuestionsbyTopic(String topicId) async {
    final response =
        await http.get('http://askansproject.herokuapp.com/topics/$topicId');
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        List<Question> questions = new List<Question>();
        for (Map<String, dynamic> questionMap in data) {
          questions.add(Question.fromJson(questionMap));
        }
        return questions;
      }
      return null;
    } else {
      throw Exception('Failed to load questions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Topic>>(
      future: this.fetchTopics(),
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
                onPressed: () => setState(() => _count++),
                child: const Icon(Icons.question_answer_outlined),
              ),
              body: TabBarView(
                children: snapshot.data
                    .map((topic) => FutureBuilder<List<Question>>(
                          future: this
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
                                          subtitle: Text('Yung Beef'),
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
