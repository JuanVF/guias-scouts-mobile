import 'package:flutter/material.dart';
import 'package:guias_scouts_mobile/pages/LoginPage/components/confirm.dart';
import 'package:guias_scouts_mobile/pages/LoginPage/components/login.dart';

enum LoginComponents { LOGIN, CONFIRM_USER, FORGOT_PASSWORD }

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginComponents _currentComponent = LoginComponents.LOGIN;
  String _userEmail = "";

  // Function to switch to a different component
  void switchComponent(LoginComponents component) {
    setState(() {
      _currentComponent = component;
    });
  }

  // Sets the user email
  void setUserEmail(String email) {
    setState(() {
      _userEmail = email;
    });
  }

  // Sets the user email
  String getUserEmail() {
    return _userEmail;
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentComponent) {
      case LoginComponents.LOGIN:
        return _buildLoginPage(Login(
          switchComponent: switchComponent,
          setUserEmail: setUserEmail,
        ));
      case LoginComponents.CONFIRM_USER:
        return _buildLoginPage(Confirm(
          switchComponent: switchComponent,
          getUserEmail: getUserEmail,
        ));
      default:
        return _buildLoginPage(Login(
          switchComponent: switchComponent,
          setUserEmail: setUserEmail,
        ));
    }
  }

  Widget _buildLoginPage(Widget component) {
    const averageSpacing = SizedBox(height: 80);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(195, 190, 247, 1),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            right: -175,
            top: -100,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                const Color.fromRGBO(195, 190, 247, 0.1).withOpacity(1),
                BlendMode.screen,
              ),
              child: Image.asset(
                '../../assets/login_pattern.png',
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                const Text(
                  'Guías Online',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                    color: Color.fromRGBO(29, 8, 63, 1),
                  ),
                ),
                averageSpacing,
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0),
                    ),
                    color: Color.fromRGBO(255, 255, 255, 1),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: component,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
