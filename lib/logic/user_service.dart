import 'package:flutter/material.dart';
import 'package:questionforum/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class UserService {
  User _user = User();

  UserService();

  User get getUser => _user;
  void dispose() {
    this._user = null;
  }

  Future<User> fetchUserbyIdLogin(String id) async {
    final response =
        await http.get('http://askansproject.herokuapp.com/users/$id');
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        _user = User.fromJson(data[0]);
        return _user;
      }
      return null;
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<User> fetchUserbyId(String id) async {
    final response =
        await http.get('http://askansproject.herokuapp.com/users/$id');
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        return User.fromJson(data[0]);
      }
      return null;
    } else {
      throw Exception('Failed to load user');
    }
  }

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
}
