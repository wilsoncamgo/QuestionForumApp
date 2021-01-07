import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:questionforum/models/user.dart';
import 'package:questionforum/screens/common_widgets/logo.dart';
import 'package:questionforum/screens/menu_screeen.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({Key key, @required this.typeMessage})
      : super(key: key);

  final int typeMessage;

  @override
  Widget build(BuildContext context) {
    String message;
    switch (typeMessage) {
      case 1:
        message =
            'La pregunta ha sido correctamente creada!\n Toca para continuar';
        break;
      case 2:
        message =
            'El usuario ha sido correctamente creado\n Toca para continuar';
        break;
      case 3:
        message =
            'la respuesta ha sido correctamente creada\n Toca para continuar';
        break;
      default:
        message = 'Codigo de error PR07';
        break;
    }
    return Material(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Logo(),
            InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MenuScreen(),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    message,
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 50,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
