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
import 'package:guias_scouts_mobile/controller/progress_controller.dart';
import 'package:guias_scouts_mobile/pages/MainPage/main_page.dart';

class ProgressForm extends StatefulWidget {
  final void Function(MainComponents) switchComponent;
  final String progressType;
  final Map<String, dynamic> user;
  const ProgressForm({Key? key, required this.switchComponent, required this.progressType, required this.user}) : super(key: key);

  @override
  _ProgressForm createState() => _ProgressForm();
}

class _ProgressForm extends State<ProgressForm> {
  final ProgressController _progressController = ProgressController();
  List<Map<String, dynamic>> _questions = [];
  List<String> _questionTypes = [];

  Future<void> _fetchQuestions() async {
    final questions = await _progressController.getAllProgressQuestionsByUserIdAndProgressType(widget.progressType, widget.user['user_id']);
    final Set<String> questionTypesSet = questions.map<String>((question) => question['question_type']).toSet();
    final List<String> questionTypes = questionTypesSet.toList();
    setState(() {
      _questions = questions;
      _questionTypes = questionTypes;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  // Function to show an error dialog with the given message
  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sistema'),
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

  Future<void> _sendForm() async {
    List<Map<String, dynamic>> updatedQuestions = _questions.toList(); // Create a copy of _questions

    // Update user answers in the copied list
    for (int i = 0; i < updatedQuestions.length; i++) {
      updatedQuestions[i]['user_answer'] = _questions[i]['user_answer'];
    }

    // Send the updated questions to the server
    final success = await _progressController.evaluate(updatedQuestions, widget.user['user_id']);

    if (success) {
      showErrorDialog("Formulario actualizado!");
      widget.switchComponent(MainComponents.USER_DETAIL);
    } else {
      showErrorDialog("Ocurrió un error, inténtelo de nuevo...");
    }
  }

  Widget _buildQuestionItem(Map<String, dynamic> question) {
    bool userAnswer = question['user_answer'] == 1;

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
          Expanded(
            child: Text(
              question['question'],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ),
          Checkbox(
            value: userAnswer,
            onChanged: (bool? value) {
              setState(() {
                question['user_answer'] = value! ? 1 : 0;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionSection(List<Map<String, dynamic>> questions, String questionType) {
    List<Widget> questionWidgets = [];

    for (var question in questions) {
      if (question['question_type'] == questionType) {
        questionWidgets.add(_buildQuestionItem(question));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            questionType,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        ...questionWidgets,
      ],
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
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Evaluación',
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
          Expanded(
            child: ListView(
              children: [
                for (var questionType in _questionTypes)
                  _buildQuestionSection(_questions, questionType),
              ],
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
            onPressed: _sendForm,
            child: const Text('Enviar Formulario'),
          ),
        ],
      ),
    );
  }
}
