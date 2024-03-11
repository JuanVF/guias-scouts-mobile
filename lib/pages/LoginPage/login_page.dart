import 'package:flutter/material.dart';
import 'package:guias_scouts_mobile/pages/LoginPage/components/login.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    const averageSpacing = SizedBox(height: 80);

    return Scaffold(
        backgroundColor: const Color.fromRGBO(195, 190, 247, 1),
        body: Center(
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
                    topLeft: Radius.circular(40.0), // Adjust radius for roundness
                    topRight: Radius.circular(40.0), // Adjust radius for roundness
                  ),
                  color: Color.fromRGBO(255, 255, 255, 1),
                ),
                child: const Center(
                  child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Login(),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
