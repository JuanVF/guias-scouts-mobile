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
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guias_scouts_mobile/common/token_manager.dart';
import 'package:guias_scouts_mobile/controller/material_controller.dart';
import 'package:guias_scouts_mobile/pages/MainPage/main_page.dart';

class Materials extends StatefulWidget {
  final void Function(MainComponents) switchComponent; // Callback function
  final void Function(Map<String, dynamic>) setMaterial; // Callback function
  const Materials({Key? key, required this.switchComponent, required this.setMaterial}) : super(key: key);

  @override
  _Materials createState() => _Materials();
}

class _Materials extends State<Materials> {
  final MaterialController _materialController = MaterialController();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _materials = [];

  @override
  void initState() {
    super.initState();
    _fetchMaterials('');
  }

  void _onSearch() {
    _fetchMaterials(_searchController.text);
  }

  Future<void> _fetchMaterials(String query) async {
    final materials = await _materialController.search(query);
    setState(() {
      _materials = materials;
    });
  }

  Widget _buildMaterialItem(Map<String, dynamic> material) {
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
          const Icon(Icons.picture_as_pdf, color: Colors.red),
          averageInnerSpacing,
          Expanded(
            child: Text(
              material['title'],
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              widget.setMaterial(material);
              widget.switchComponent(MainComponents.MATERIAL_DETAIL);
            },
            child: const Icon(Icons.remove_red_eye, color: Color.fromRGBO(48, 16, 101, 1)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const averageSpacing = SizedBox(height: 20);
    const averageInnerSpacing = SizedBox(height: 10);

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
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Materiales Disponibles',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                            color: Color.fromRGBO(48, 16, 101, 1),
                          ),
                          textAlign: TextAlign.left, // Align text to the left
                        ),
                        averageInnerSpacing,
                        TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Buscar Materiales',
                          ),
                        ),
                        averageInnerSpacing,
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            textStyle: const TextStyle(
                                fontSize: 20, color: Colors.white),
                            elevation: 0,
                            backgroundColor:
                                const Color.fromRGBO(48, 16, 101, 1),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: _onSearch,
                          child: const Text('Buscar Materiales'),
                        )
                      ],
                    ),
                  ),
                ),
                averageSpacing,
                const Text(
                  'Resultados Disponibles',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                    color: Color.fromRGBO(48, 16, 101, 1),
                  ),
                  textAlign: TextAlign.left, // Align text to the left
                ),
                averageSpacing,
                Expanded(
                  child: ListView.builder(
                    itemCount: _materials.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildMaterialItem(_materials[index]);
                    },
                  ),
                ),
                snapshot.data?["role"] == "dirigente"
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          textStyle: const TextStyle(
                              fontSize: 20, color: Colors.white),
                          elevation: 0,
                          backgroundColor: const Color.fromRGBO(48, 16, 101, 1),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          widget
                              .switchComponent(MainComponents.CREATE_MATERIAL);
                        },
                        child: const Text('Agregar Material'),
                      )
                    : Container(),
              ],
            ),
          );
        });
  }
}
