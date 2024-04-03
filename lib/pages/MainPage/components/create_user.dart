import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guias_scouts_mobile/controller/user_controller.dart';
import 'package:guias_scouts_mobile/pages/MainPage/main_page.dart';

class CreateUser extends StatefulWidget {
  final void Function(MainComponents) switchComponent; // Callback function
  const CreateUser({Key? key, required this.switchComponent}) : super(key: key);

  @override
  _CreateUser createState() => _CreateUser();
}

class _CreateUser extends State<CreateUser> {
  final UserController controller = UserController();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _birthdayController;
  int? _selectedRole;
  int? _selectedPatrulla;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _birthdayController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  String _addLeadingZero(int value) {
    return value.toString().padLeft(2, '0');
  }

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

  Future<void> registerUser() async {
    // Retrieve values from controllers
    String name = _nameController.text;
    String email = _emailController.text;
    int birthdayEpoch = _birthdayController.text.isEmpty
        ? DateTime.now().millisecondsSinceEpoch ~/ 1000
        : _parseBirthday(_birthdayController.text);
    int? role = _selectedRole;
    int? patrulla = _selectedPatrulla;

    final user = {
      "fullname" : name,
      "email" : email,
      "password" : "guias-scouts-2024",
      "birthday" : birthdayEpoch,
      "id_role" : role,
      "id_patrol" : patrulla
    };

    final result = await controller.createUser(user);

    if (result == CreateUserResponse.SERVER_ERROR) {
      showErrorDialog("Ha ocurrido un error, inténtalo de nuevo...");
      return;
    }

    showErrorDialog("¡Usuario Creado!");
    widget.switchComponent(MainComponents.USERS);
  }

  int _parseBirthday(String dateString) {
    List<String> parts = dateString.split('/');
    int year = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int day = int.parse(parts[2]);
    return DateTime(year, month, day).millisecondsSinceEpoch ~/ 1000;
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
                'Agregar Integrante',
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
          // Create User Container
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
                      'Crear nuevo usuario',
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
                      controller: _nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nombre Completo',
                      ),
                    ),
                    averageInnerSpacing,
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Correo',
                      ),
                    ),
                    averageInnerSpacing,
                    TextFormField(
                      readOnly: true,
                      controller: _birthdayController, // Controller for birthday field
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() {
                            _birthdayController.text = '${picked.year}/${_addLeadingZero(picked.month)}/${_addLeadingZero(picked.day)}';
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Fecha de Nacimiento',
                      ),
                    ),
                    averageInnerSpacing,
                    DropdownButtonFormField<int>(
                      value: _selectedRole,
                      onChanged: (int? newValue) {
                        setState(() {
                          _selectedRole = newValue;
                        });
                      },
                      items: const [
                        DropdownMenuItem<int>(
                          value: 1,
                          child: Text('Dirigente'),
                        ),
                        DropdownMenuItem<int>(
                          value: 2,
                          child: Text('Protagonista'),
                        ),
                      ],
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Rol',
                      ),
                    ),
                    averageInnerSpacing,
                    DropdownButtonFormField<int>(
                      value: _selectedPatrulla,
                      onChanged: (int? newValue) {
                        setState(() {
                          _selectedPatrulla = newValue;
                        });
                      },
                      items: const [
                        DropdownMenuItem<int>(
                          value: 1,
                          child: Text('Lobos'),
                        ),
                        DropdownMenuItem<int>(
                          value: 2,
                          child: Text('Toros'),
                        ),
                        DropdownMenuItem<int>(
                          value: 3,
                          child: Text('Chorlitos'),
                        ),
                      ],
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Patrulla',
                      ),
                    ),
                    averageInnerSpacing,
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        textStyle: const TextStyle(fontSize: 20, color: Colors.white),
                        elevation: 0,
                        backgroundColor: const Color.fromRGBO(48, 16, 101, 1),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        registerUser();
                      },
                      child: const Text('Crear Usuario'),
                    ),
                  ],
                )), // Align child to the left
          ),
        ],
      ),
    );
  }
}
