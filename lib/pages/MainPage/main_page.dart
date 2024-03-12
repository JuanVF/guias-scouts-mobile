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
import 'package:flutter/material.dart';
import 'package:guias_scouts_mobile/pages/MainPage/components/my_user.dart';

enum MainComponents { MY_USER, MATERIAL, PROGRESS, USERS }

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPage createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  MainComponents _currentComponent = MainComponents.MY_USER;
  int _selectedIndex = 0;

  // Function to switch to a different component
  void switchComponent(MainComponents component) {
    setState(() {
      _currentComponent = component;
    });
  }

  // Define the function to handle bottom navigation item selection
  void _onItemTapped(int index) {
    List<MainComponents> pages = [
      MainComponents.USERS,
      MainComponents.MATERIAL,
      MainComponents.MY_USER
    ];
    setState(() {
      _selectedIndex = index;
      _currentComponent = pages[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentComponent) {
      case MainComponents.MY_USER:
        return _buildMainPage(MyUser(
          switchComponent: switchComponent,
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Usuarios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Material',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Mi Usuario',
          ),
        ],
      ),
    );
  }
}
