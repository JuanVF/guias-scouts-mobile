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
import 'package:guias_scouts_mobile/controller/material_controller.dart';
import 'package:guias_scouts_mobile/pages/MainPage/main_page.dart';
import 'dart:html' as html;

class CreateMaterial extends StatefulWidget {
  final void Function(MainComponents) switchComponent; // Callback function
  const CreateMaterial({Key? key, required this.switchComponent})
      : super(key: key);

  @override
  _CreateMaterial createState() => _CreateMaterial();
}

class _CreateMaterial extends State<CreateMaterial> {
  late TextEditingController _titleController;

  MaterialController controller = MaterialController();

  String _base64Data = '';
  String _fileExtension = '';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
  }

  // Function to show an error dialog with the given message and return true if 'Aceptar' is tapped
  Future<bool> showErrorDialog(String message) async {
    bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
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

  void _pickFile() {
    // Create an HTML file input element
    final html.InputElement input =
        html.FileUploadInputElement() as html.InputElement..accept = '.pdf';
    input.click();

    // Listen for a file selection
    input.onChange.listen((event) {
      final file = input.files!.first;
      final reader = html.FileReader()..readAsDataUrl(file);
      reader.onLoadEnd.listen((event) async {
        setState(() {
          _fileExtension = file.name.split('.').last;
          _base64Data = reader.result as String;
        });
      });
    });
  }

  void _saveFile() async {
    final fileName = _titleController.text;

    if (fileName == '') {
      showErrorDialog("Por favor agrega un nombre al material...");
      return;
    }

    final result = await controller.create(fileName, _base64Data, _fileExtension);

    if (!result) {
      showErrorDialog("Ha ocurrido un error, inténtalo de nuevo...");
    }

    widget.switchComponent(MainComponents.MATERIALS);
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
                'Crear Nuevo Material',
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
                      'Detalles del Material',
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
                      controller: _titleController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Título del Material',
                      ),
                    ),
                    averageSpacing,
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(50),
                        textStyle: TextStyle(fontSize: 20, color: Colors.white),
                        elevation: 0,
                        backgroundColor: Color.fromRGBO(48, 16, 101, 1),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _pickFile,
                      child: Text('Adjuntar Material'),
                    ),
                    averageSpacing,
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        textStyle:
                            const TextStyle(fontSize: 20, color: Colors.white),
                        elevation: 0,
                        backgroundColor: const Color.fromRGBO(48, 16, 101, 1),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _saveFile,
                      child: const Text('Crear Material'),
                    ),
                  ],
                )), // Align child to the left
          ),
        ],
      ),
    );
  }
}
