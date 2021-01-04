import 'package:flutter/material.dart';

class CreateQuestion extends StatefulWidget {
  CreateQuestion({Key key}) : super(key: key);

  @override
  _CreateQuestionState createState() => _CreateQuestionState();
}

class _CreateQuestionState extends State<CreateQuestion> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                      hintText: "Ingresa tu nombre"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Por favor coloca tu nombre para continuar';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    this.user.name = newValue;
                  },
                ),
              ),
              DefaultButton(
                contentText: "Haz tu primera pregunta!",
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    int status = await this.createUser(user);
                    if (status == 201) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MenuScreen(),
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
