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
import 'package:guias_scouts_mobile/controller/user_controller.dart';
import 'package:guias_scouts_mobile/pages/MainPage/components/add_patrol.dart';
import 'package:guias_scouts_mobile/pages/MainPage/components/create_material.dart';
import 'package:guias_scouts_mobile/pages/MainPage/components/create_user.dart';
import 'package:guias_scouts_mobile/pages/MainPage/components/edit_user.dart';
import 'package:guias_scouts_mobile/pages/MainPage/components/material_detail.dart';
import 'package:guias_scouts_mobile/pages/MainPage/components/materials.dart';
import 'package:guias_scouts_mobile/pages/MainPage/components/my_user.dart';
import 'package:guias_scouts_mobile/pages/MainPage/components/progress_form.dart';
import 'package:guias_scouts_mobile/pages/MainPage/components/user_detail.dart';
import 'package:guias_scouts_mobile/pages/MainPage/components/users.dart';
import 'package:guias_scouts_mobile/pages/MainPage/components/users_by_patrol.dart';

enum MainComponents { MY_USER, MATERIALS, CREATE_MATERIAL, MATERIAL_DETAIL, PROGRESS, USERS, USER_DETAIL, EDIT_USER, CREATE_USER, PROGRESS_FORM, ADD_PATROL, USERS_BY_PATROL }

class MainPage extends StatefulWidget {
  final Map<String, dynamic> user;

  const MainPage({Key? key, required this.user}) : super(key: key);

  @override
  _MainPage createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  final UserController controller = UserController();

  MainComponents _currentComponent = MainComponents.MATERIALS;
  Map<String, dynamic> _currentMaterial = {};
  String _currentProgressType = "";
  String _currentPatrol = "";
  Map<String, dynamic> _currentUser = {};
  int _selectedIndex = 1;

  // Function to switch to a different component
  void switchComponent(MainComponents component) {
    setState(() {
      _currentComponent = component;
    });
  }

  // Function to switch to a different component
  void setMaterial(Map<String, dynamic> material) {
    setState(() {
      _currentMaterial = material;
    });
  }

  // Function to switch to a different component
  void setUser(Map<String, dynamic> user) {
    setState(() {
      _currentUser = user;
    });
  }

  // Function to switch to a different component
  void setProgressType(String progressType) {
    setState(() {
      _currentProgressType = progressType;
    });
  }

  // Function to switch to a different component
  void setPatrol(String patrol) {
    setState(() {
      _currentPatrol = patrol;
    });
  }

  // Define the function to handle bottom navigation item selection
  void _onItemTapped(int index) {
    List<MainComponents> pages = [
      MainComponents.USERS,
      MainComponents.MATERIALS,
      MainComponents.MY_USER
    ];

    if (widget.user['role'] != 'dirigente') {
      pages = [
        MainComponents.USER_DETAIL,
        MainComponents.MATERIALS,
        MainComponents.MY_USER
      ];
    }

    setState(() {
      _selectedIndex = index;
      _currentComponent = pages[index];
    });
  }

  @override
  void initState() {
    super.initState();

    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    final user = await controller.getProfile();
    user['user_id'] = user['id'];
    setState(() {
      _currentUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentComponent) {
      case MainComponents.USERS:
        return _buildMainPage(Users(
          switchComponent: switchComponent,
          setUser: setUser,
          setPatrol: setPatrol,
        ));
      case MainComponents.USER_DETAIL:
        return _buildMainPage(UserDetail(
          switchComponent: switchComponent,
          user: _currentUser,
          setProgressType: setProgressType,
        ));
      case MainComponents.MATERIALS:
        return _buildMainPage(Materials(
          switchComponent: switchComponent,
          setMaterial: setMaterial,
        ));
      case MainComponents.MY_USER:
        return _buildMainPage(MyUser(
          switchComponent: switchComponent,
        ));
      case MainComponents.CREATE_USER:
        return _buildMainPage(CreateUser(
          switchComponent: switchComponent,
        ));
      case MainComponents.ADD_PATROL:
        return _buildMainPage(AddPatrol(
          switchComponent: switchComponent,
        ));
      case MainComponents.USERS_BY_PATROL:
        return _buildMainPage(UsersByPatrol(
          switchComponent: switchComponent,
          patrol: _currentPatrol,
        ));
      case MainComponents.MATERIAL_DETAIL:
        return _buildMainPage(MaterialDetail(
          switchComponent: switchComponent,
          material: _currentMaterial,
        ));
      case MainComponents.CREATE_MATERIAL:
        return _buildMainPage(CreateMaterial(
          switchComponent: switchComponent,
        ));
      case MainComponents.EDIT_USER:
        return _buildMainPage(EditUser(
          switchComponent: switchComponent,
          user: _currentUser,
        ));
      case MainComponents.PROGRESS_FORM:
        return _buildMainPage(ProgressForm(
          switchComponent: switchComponent,
          user: _currentUser,
          progressType: _currentProgressType,
        ));
      default:
        return _buildMainPage(MyUser(
          switchComponent: switchComponent,
        ));
    }
  }

  Widget _buildMainPage(Widget component) {
    const averageSpacing = SizedBox(height: 80);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 248, 254, 1),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          component,
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(widget.user['role'] == 'dirigente' ? Icons.people : Icons.bar_chart),
            label: widget.user['role'] == 'dirigente' ? 'Usuarios' : 'Progresos',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Material',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Mi Usuario',
          ),
        ],
      ),
    );
  }
}
