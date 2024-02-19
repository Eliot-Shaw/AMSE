import 'package:flutter/material.dart';

class Ex3 extends StatelessWidget {
  const Ex3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercice 3'),
      ),
      body: const Center(
        child: Text(
          'ON A MIS LES APP DANS UNE APPLIST',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
