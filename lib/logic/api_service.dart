import 'package:http/http.dart' as http;
import 'package:questionforum/models/answer.dart';
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

  Future<List<Answer>> fetchAnswersbyQuestionId(String questionId) async {
    final response = await http
        .get('http://askansproject.herokuapp.com/answers/$questionId');
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        List<Answer> answers = new List<Answer>();
        for (Map<String, dynamic> answerMap in data) {
          answers.add(Answer.fromJson(answerMap));
        }
        return answers;
      }
      return null;
    } else {
      throw Exception('Failed to load answers');
    }
  }

  Future<List<Answer>> fetchAnswersbyUserId(String userId) async {
    final response = await http
        .get('http://askansproject.herokuapp.com/answers/users/$userId');
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        List<Answer> answers = new List<Answer>();
        for (Map<String, dynamic> answerMap in data) {
          answers.add(Answer.fromJson(answerMap));
        }
        return answers;
      }
      return null;
    } else {
      throw Exception('Failed to load answers');
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

  Future<int> createAnswer(Answer answer) async {
    final http.Response response =
        await http.post('https://askansproject.herokuapp.com/answers',
            body: answer.toJson(),
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
      throw Exception('Failed to load answer');
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

  Future<List<Question>> fetchQuestionsbyUserId(String userId) async {
    final response =
        await http.get('http://askansproject.herokuapp.com/questions/$userId');
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

  Future<int> deleteAnswer(String answerId) async {
    final http.Response response = await http
        .delete('https://askansproject.herokuapp.com/answers/$answerId');
    if (response.statusCode == 200) {
      return response.statusCode;
    } else {
      throw Exception('Failed to delete answer');
    }
  }

  Future<int> deleteQuestion(String questionId) async {
    final http.Response response = await http
        .delete('https://askansproject.herokuapp.com/questions/$questionId');
    if (response.statusCode == 200) {
      return response.statusCode;
    } else {
      throw Exception('Failed to delete question');
    }
  }
}
