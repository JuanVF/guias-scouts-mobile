// Copyright (c) 2024 Guias Scouts
//
// All rights reserved. This file and the source code it contains is
// confidential and proprietary to Guias Scouts. No part of this
// file may be reproduced, stored in a retrieval system, or transmitted
// in any form or by any means, electronic, mechanical, photocopying,
// recording, or otherwise, without the prior written permission of
// Guias Scouts.
//
// This file is provided "as is" with no warranties of any kind, express
// or implied, including but not limited to, any implied warranty of
// merchantability, fitness for a particular purpose, or non-infringement.
// In no event shall Guias Scouts be liable for any direct, indirect,
// incidental, special, exemplary, or consequential damages (including, but
// not limited to, procurement of substitute goods or services; loss of use,
// data, or profits; or business interruption) however caused and on any
// theory of liability, whether in contract, strict liability, or tort
// (including negligence or otherwise) arising in any way out of the use
// of this software, even if advised of the possibility of such damage.
//
// For licensing opportunities, please contact tropa92cr@gmail.com.
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guias_scouts_mobile/common/token_manager.dart';
import 'package:guias_scouts_mobile/controller/user_controller.dart';
import 'package:guias_scouts_mobile/pages/LoginPage/login_page.dart';
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

  Future<void> handleLogout() async {
    TokenManager.storeToken("");

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  String _formatBirthday(int epoch) {
    // Convert epoch to DateTime
    DateTime birthday = DateTime.fromMillisecondsSinceEpoch(epoch * 1000);
    // Format DateTime as YYYY/MM/DD
    return '${birthday.year}/${_addLeadingZero(birthday.month)}/${_addLeadingZero(birthday.day + 1)}';
  }

  String _addLeadingZero(int value) {
    // Add leading zero if necessary
    return value.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    const averageSpacing = SizedBox(height: 20);
    const averageInnerSpacing = SizedBox(height: 10);

    return FutureBuilder(
        future: controller.getProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return  const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

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
                // User Container
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
                            'Detalles de tu Usuario',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                              color: Color.fromRGBO(48, 16, 101, 1),
                            ),
                            textAlign: TextAlign.left, // Align text to the left
                          ),
                          averageInnerSpacing,
                          Text(
                            'Tu ID es ${snapshot.data?["id"] ?? ''}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                              color: Color.fromRGBO(48, 16, 101, 1),
                            ),
                            textAlign: TextAlign.left, // Align text to the left
                          ),
                           averageInnerSpacing,
                          TextField(
                            controller: TextEditingController()..text = snapshot.data?["fullname"] ?? '',
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Nombre Completo',
                            ),
                          ),
                          averageInnerSpacing,
                          TextField(
                            readOnly: snapshot.data!['role_name'] == "dirigente",
                            controller: TextEditingController()..text = snapshot.data!['role_name'] != "dirigente" ? snapshot.data!["patrol_name"] : 'N/A',
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Patrulla',
                            ),
                          ),
                          averageInnerSpacing,
                          TextField(
                            keyboardType: TextInputType.emailAddress,
                            controller: TextEditingController()..text = snapshot.data!['email'],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Correo',
                            ),
                          ),
                          averageInnerSpacing,
                          TextField(
                            keyboardType: TextInputType.emailAddress,
                            controller: TextEditingController()..text = '${_formatBirthday(snapshot.data!['birthday'])}',
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Fecha de Nacimiento',
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
                            onPressed: (){},
                            child: const Text('Actualizar Datos'),
                          ),
                        ],
                      )), // Align child to the left
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
                          averageSpacing,
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                              textStyle: const TextStyle(fontSize: 20, color: Colors.white),
                              elevation: 0,
                              backgroundColor: const Color.fromRGBO(48, 16, 101, 1),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: handleLogout,
                            child: const Text('Cerrar Sesión'),
                          ),
                        ],
                      )), // Align child to the left
                ),
              ],
            ),
          );
        }
    );
  }
}
