import 'package:flutter/material.dart';
import 'package:questionforum/models/user.dart';
import 'package:questionforum/screens/common_widgets/button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:async';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  //
  getUserName(String userId) async {
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request =
        http.Request('GET', Uri.parse('http://askansproject.herokuapp.com/users/finder/'));
    request.bodyFields = {'id': userId};
    request.headers.addAll(headers);
    http.StreamedResponse responseStream = await request.send();

    if (responseStream.statusCode == 200) {
      var response = await http.Response.fromStream(responseStream);
      final Map parsed = convert.json.decode(response.body[0]); 
      User user= User.fromMap(parsed);
      print(user.name);
    } else {
      print(responseStream.reasonPhrase);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserName("1000948840");
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Form(
          key: _formKey,
          child: Column(children: <Widget>[
            TextFormField(
              cursorColor: Colors.black,
              decoration: new InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                  hintText: "Ingresa tu nombre"),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              cursorColor: Colors.black,
              decoration: new InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                  hintText: "Ingresa tu identificacion"),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            DefaultButton(
              contentText: "Ingresa o Registrate",
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  //Valid information
                  //First HTTP request
                }
              },
            ),
          ]),
        ),
      ),
    );
  }
}
