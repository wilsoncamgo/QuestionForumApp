import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:questionforum/logic/user_service.dart';
import 'package:questionforum/models/user.dart';
import 'package:questionforum/screens/common_widgets/button.dart';

import 'package:questionforum/screens/common_widgets/logo.dart';
import 'package:questionforum/screens/menu_screeen.dart';
import 'package:questionforum/screens/name_setup.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String id;
  //

/*
  getUserName(String userId) async {
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.Request(
        'GET', Uri.parse('http://askansproject.herokuapp.com/users/'));
    request.bodyFields = {'id': userId};
    request.headers.addAll(headers);
    http.StreamedResponse responseStream = await request.send();

    if (responseStream.statusCode == 200) {
      var response = await http.Response.fromStream(responseStream);
      final Map parsed = convert.json.decode(response.body[0]);
      User user = User.fromMap(parsed);
      print(user.name);
    } else {
      print(responseStream.reasonPhrase);
    }
  }
*/

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Form(
          key: _formKey,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Logo(),
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
                        hintText: "Ingresa tu identificacion"),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Por favor coloca tu identificación para continuar';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      this.id = newValue;
                    },
                  ),
                ),
                Container(
                  child: InkWell(
                    onTap: () async {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        User user = await context
                            .read<UserService>()
                            .fetchUserbyId(this.id);
                        if (user != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MenuScreen(),
                            ),
                          );
                        } else {
                          User user = new User(id: this.id);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NameSetup(
                                user: user,
                              ),
                            ),
                          );
                        }
                      }
                    },
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 50,
                    ),
                  ),
                ),
                /*
                DefaultButton(
                  contentText: "Ingresa o Registrate",
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      //Valid information
                      //First HTTP request
                    }
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
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "Ingresa tu nombre"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Por favor coloca tu nombre para continuar';
                    }
                    return null;
                  },
                ),
                */
              ]),
        ),
      ),
    );
  }
}
