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
import 'package:guias_scouts_mobile/controller/patrol_controller.dart';
import 'package:guias_scouts_mobile/controller/user_controller.dart';
import 'package:guias_scouts_mobile/pages/MainPage/main_page.dart';

class UsersByPatrol extends StatefulWidget {
  final void Function(MainComponents) switchComponent; // Callback function
  final String patrol; // Callback function
  const UsersByPatrol({Key? key, required this.switchComponent, required this.patrol}) : super(key: key);

  @override
  _UsersByPatrol createState() => _UsersByPatrol();
}

class _UsersByPatrol extends State<UsersByPatrol> {
  final UserController _userController = UserController();
  final PatrolController _patrolController = PatrolController();

  List<Map<String, dynamic>> _users = [];

  Future<void> _fetchUsers() async {
    final users = await _userController.getAllByPatrol(widget.patrol);
    setState(() {
      _users = users;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  // Function to show an error dialog with the given message and return true if 'Aceptar' is tapped
  Future<bool> showErrorDialog(String message) async {
    bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alerta'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                // Use Navigator.pop to close the dialog and return true
                Navigator.of(context).pop(true);
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );

    // If result is null (dialog was dismissed without tapping 'Aceptar'), return false. Otherwise, return true.
    return result ?? false;
  }

  // Function to handle the login process
  Future<void> handleDeletePatrol() async {
    final shouldDelete = await showErrorDialog("¿Está seguro de borrar la patrulla?");

    if (!shouldDelete) {
      return;
    }

    bool result = await _patrolController.delete(widget.patrol);

    if (!result) {
      showErrorDialog('Ha ocurrido un error. Inténtelo de nuevo.');
      return;
    }

    await showErrorDialog('¡Patrulla borrada!');


    widget.switchComponent(MainComponents.USERS);
  }

  Widget _buildUserItem(Map<String, dynamic> user) {
    const averageInnerSpacing = SizedBox(width: 10);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(user['role_name'] == "dirigente" ? Icons.co_present_sharp : Icons.person, color: Colors.red),
          averageInnerSpacing,
          Expanded(
            child: Text(
              user['fullname'],
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
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
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Usuarios de ${widget.patrol}',
                style: const TextStyle(
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
          Expanded(
            child: ListView.builder(
              itemCount: _users.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildUserItem(_users[index]);
              },
            ),
          ),
          averageSpacing,
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              textStyle: const TextStyle(fontSize: 20, color: Colors.white),
              elevation: 0,
              backgroundColor: const Color.fromRGBO(184, 31, 31, 1),
              foregroundColor: Colors.white,
            ),
            onPressed: handleDeletePatrol,
            child: const Text('Borrar Patrulla'),
          ),
        ],
      ),
    );
  }
}
