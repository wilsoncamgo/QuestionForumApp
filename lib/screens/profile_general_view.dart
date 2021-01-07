import 'package:flutter/material.dart';
import 'package:questionforum/logic/user_service.dart';
import 'package:questionforum/screens/common_widgets/button.dart';
import 'package:questionforum/screens/common_widgets/logo.dart';
import 'package:provider/provider.dart';
import 'package:questionforum/screens/review_activity.dart';

class ProfileGeneralView extends StatelessWidget {
  const ProfileGeneralView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserService>().getUser;
    return Scaffold(
      appBar: AppBar(
        title: Logo(),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: CircleAvatar(
              minRadius: 40,
              maxRadius: 70,
              backgroundImage: NetworkImage(
                  "https://images.unsplash.com/flagged/photo-1570612861542-284f4c12e75f?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1950&q=80"),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              "Bienvenida/o " + user.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w200,
              ),
            ),
          ),
          DefaultButton(
            contentText: "Revisa tus preguntas hechas",
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReviewActivity(
                  type: 1,
                ),
              ),
            ),
          ),
          DefaultButton(
            contentText: "Revisa tus respuestas hechas",
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReviewActivity(
                  type: 2,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
