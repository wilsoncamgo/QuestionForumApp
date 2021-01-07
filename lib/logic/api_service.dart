import 'package:http/http.dart' as http;
import 'package:questionforum/models/question.dart';
import 'dart:convert';
import 'dart:async';

import 'package:questionforum/models/topic.dart';

class ApiService {
  ApiService();
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
        await http.post('https://askansproject.herokuapp.com/questions',
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
      throw Exception('Failed to load question');
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
}
