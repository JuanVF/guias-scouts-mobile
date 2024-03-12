import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guias_scouts_mobile/controller/user_controller.dart';
import 'package:guias_scouts_mobile/pages/MainPage/main_page.dart';

class MyUser extends StatefulWidget {
  final void Function(MainComponents) switchComponent; // Callback function
  const MyUser({Key? key, required this.switchComponent}) : super(key: key);

  @override
  _MyUser createState() => _MyUser();
}

class _MyUser extends State<MyUser> {
  TextEditingController prevPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();

  final UserController controller = UserController();

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
  Future<void> handleChangePassword() async {
    String prevPswd = prevPassword.text;
    String newPswd = newPassword.text;

    ChangePasswordResponse result = await controller.changePassword(prevPswd, newPswd);

    if (result == ChangePasswordResponse.SERVER_ERROR) {
      showErrorDialog('Ha ocurrido un error. Inténtelo de nuevo.');
      return;
    }

    if (result == ChangePasswordResponse.INVALID_PASSWORD) {
      showErrorDialog('Credenciales Inválidas.');
      return;
    }

    showErrorDialog('Contraseña Cambiada!');
  }

  @override
  Widget build(BuildContext context) {
    const averageSpacing = SizedBox(height: 20);
    const averageInnerSpacing = SizedBox(height: 10);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Title Container
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
            alignment: Alignment.centerLeft,
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Mi Usuario',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                  color: Color.fromRGBO(48, 16, 101, 1),
                ),
                textAlign: TextAlign.left, // Align text to the left
              ),
            ), // Align child to the left
          ),
          averageSpacing,
          // Password Container
          Container(
            width: double.infinity, // Make the container full width
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cambiar Contraseña',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                        color: Color.fromRGBO(48, 16, 101, 1),
                      ),
                      textAlign: TextAlign.left, // Align text to the left
                    ),
                    averageInnerSpacing,
                    TextField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: prevPassword,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Antigua Contraseña',
                      ),
                    ),
                    averageInnerSpacing,
                    TextField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: newPassword,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nueva Contraseña',
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
                      onPressed: handleChangePassword,
                      child: const Text('Cambiar Contraseña'),
                    ),
                  ],
                )), // Align child to the left
          ),
        ],
      ),
    );
  }
}
