import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guias_scouts_mobile/controller/auth_controller.dart';
import 'package:guias_scouts_mobile/pages/LoginPage/login_page.dart';
import 'package:guias_scouts_mobile/pages/MainPage/main_page.dart';

class Login extends StatefulWidget {
  final void Function(LoginComponents) switchComponent; // Callback function
  final void Function(String) setUserEmail; // Callback function
  const Login(
      {Key? key, required this.switchComponent, required this.setUserEmail})
      : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscureText = true;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
  Future<void> handleLogin() async {
    String email = emailController.text;
    String password = passwordController.text;

    LoginResponse result = await controller.login(email, password);

    if (result == LoginResponse.SERVER_ERROR) {
      showErrorDialog('Ha ocurrido un error. Inténtelo de nuevo.');
      return;
    }

    if (result == LoginResponse.INVALID_CREDENTIALS) {
      showErrorDialog('Credenciales Inválidas.');
      return;
    }

    if (result == LoginResponse.NEEDS_CONFIRMATION) {
      widget.setUserEmail(email);
      widget.switchComponent(LoginComponents.CONFIRM_USER);
      return;
    }

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const MainPage()));
  }

  @override
  Widget build(BuildContext context) {
    const averageSpacing = SizedBox(height: 30);

    return Column(
      children: <Widget>[
        const SizedBox(height: 40),
        const Text(
          'Iniciar Sesión',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
            color: Color.fromRGBO(48, 16, 101, 1),
          ),
        ),
        averageSpacing,
        TextField(
          keyboardType: TextInputType.emailAddress,
          controller: emailController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Correo',
            hintText: 'jhon@doe.com',
          ),
        ),
        averageSpacing,
        TextField(
          obscureText: _obscureText,
          controller: passwordController,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: 'Contraseña',
            suffixIcon: IconButton(
              icon:
                  Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
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
          onPressed: handleLogin,
          child: const Text('Iniciar Sesión'),
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
          onPressed: () {},
          child: const Text('Olvidé la Contraseña'),
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
