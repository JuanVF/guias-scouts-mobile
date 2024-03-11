import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guias_scouts_mobile/controller/auth_controller.dart';
import 'package:guias_scouts_mobile/pages/LoginPage/login_page.dart';

class Confirm extends StatefulWidget {
  final void Function(LoginComponents) switchComponent; // Callback function
  final String Function() getUserEmail; // Callback function
  const Confirm(
      {Key? key, required this.switchComponent, required this.getUserEmail})
      : super(key: key);

  @override
  _ConfirmState createState() => _ConfirmState();
}

class _ConfirmState extends State<Confirm> {
  TextEditingController codeController = TextEditingController();

  AuthController controller = AuthController();

  // Function to show an error dialog with the given message
  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  // Function to handle the login process
  Future<void> handleConfirm() async {
    String email = widget.getUserEmail();
    String code = codeController.text;

    ConfirmCodeResponse result = await controller.confirmUser(email, code);

    if (result == ConfirmCodeResponse.SERVER_ERROR) {
      showErrorDialog('Ha ocurrido un error. Inténtelo de nuevo.');
      return;
    }

    if (result == ConfirmCodeResponse.INVALID_CODE) {
      showErrorDialog('Código Inválido.');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    const averageSpacing = SizedBox(height: 30);

    return Column(
      children: <Widget>[
        const SizedBox(height: 40),
        const Text(
          'Confirmar Usuario',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
            color: Color.fromRGBO(48, 16, 101, 1),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          '''¡Bienvenido a Guías Online!\nPara confirmar tu usuario te hemos envíado un código de confirmación a tu correo.''',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
            fontFamily: 'Inter',
            color: Color.fromRGBO(0, 0, 0, 1),
          ),
        ),
        averageSpacing,
        TextField(
          controller: codeController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Código',
            hintText: 'ABCD-1234',
          ),
        ),
        averageSpacing,
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            textStyle: const TextStyle(fontSize: 20, color: Colors.white),
            elevation: 0,
            backgroundColor: const Color.fromRGBO(48, 16, 101, 1),
            foregroundColor: Colors.white,
          ),
          onPressed: handleConfirm,
          child: const Text('Confirmar Usuario'),
        ),
        averageSpacing,
        TextButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            textStyle: const TextStyle(fontSize: 20, color: Colors.white),
            elevation: 0,
            foregroundColor: const Color.fromRGBO(48, 16, 101, 1),
            backgroundColor: Colors.white,
          ),
          onPressed: () {
            widget.switchComponent(LoginComponents.LOGIN);
          },
          child: const Text('Volver a Inicio de Sesión'),
        ),
        averageSpacing,
        Image.asset(
          '../../../assets/guias_scouts_logo.png',
          height: 100,
        ),
        const Text(
          'Guías Scouts @ 2024',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w300,
            fontFamily: 'Inter',
            color: Color.fromRGBO(0, 0, 0, 0.8),
          ),
        ),
      ],
    );
  }
}
