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
import 'package:guias_scouts_mobile/controller/material_controller.dart';
import 'package:guias_scouts_mobile/pages/MainPage/main_page.dart';
import 'dart:html' as html;


class MaterialDetail extends StatefulWidget {
  final void Function(MainComponents) switchComponent; // Callback function
  final Map<String, dynamic> material; // Callback function
  const MaterialDetail(
      {Key? key, required this.switchComponent, required this.material})
      : super(key: key);

  // Método para descargar el archivo
  Future<void> _downloadFile(String url, String filename) async {
    html.AnchorElement anchorElement =  html.AnchorElement(href: url);
    anchorElement.download = url;
    anchorElement.click();
  }

  @override
  _MaterialDetail createState() => _MaterialDetail();
}


class _MaterialDetail extends State<MaterialDetail> {
  final MaterialController controller = MaterialController();

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

  void onDeleteSelected() async {
    final shouldDelete = await showErrorDialog("¿Está seguro de borrar el material?");

    if (!shouldDelete) {
      return;
    }

    final material = widget.material;

    final succeed = await controller.delete(material['material_id']);
    var message = "¡Material borrado correctamente!";

    if (!succeed) {
      message = "Ha ocurrido un error borrando el material. Inténtelo de nuevo...";
    }

    await showErrorDialog(message);

    if (succeed) {
      widget.switchComponent(MainComponents.MATERIALS);
    }
  }

  @override
  Widget build(BuildContext context) {
    const averageSpacing = SizedBox(height: 20);
    const averageInnerSpacing = SizedBox(height: 10);

    final material = widget.material;

    return FutureBuilder(
        future: TokenManager.getDecodedToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.data == null) {
            return Container();
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
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      '${material['title']}',
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
                const SizedBox(
                  width: 800, // Match iframe width
                  height: 600, // Match iframe height
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    textStyle: const TextStyle(fontSize: 20, color: Colors.white),
                    elevation: 0,
                    backgroundColor: const Color.fromRGBO(48, 16, 101, 1),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: (){
                    widget._downloadFile(material['url'], material['title']);
                  },
                  child: const Text('Descargar'),
                ),
                averageSpacing,
                snapshot.data?["role"] == "dirigente" ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    textStyle: const TextStyle(fontSize: 20, color: Colors.white),
                    elevation: 0,
                    backgroundColor: const Color.fromRGBO(184, 31, 31, 1),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: onDeleteSelected,
                  child: const Text('Borrar Material'),
                ) : Container(),
              ],
            ),
          );
        });
  }
}
