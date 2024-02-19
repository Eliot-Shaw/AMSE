import 'package:flutter/material.dart';
import 'package:tp2/ex1.dart';
import 'package:tp2/ex2.dart';
import 'package:tp2/ex3.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const ExerciseListPage(),
      routes: {
        '/ex1': (context) => const Ex1(),
        '/ex2': (context) => const Ex2(),
        '/ex3': (context) => const Ex3(),
      },
    );
  }
}

class ExerciseListPage extends StatelessWidget {
  const ExerciseListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Liste des exs'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text(
              Ex1.nomExercice,
              style: TextStyle(color: Colors.black), // Couleur du texte en noir
            ),
            onTap: () {
              Navigator.pushNamed(context, '/ex1');
            },
          ),
          ListTile(
            title: const Text(
              Ex2.nomExercice,
              style: TextStyle(color: Colors.black), // Couleur du texte en noir
            ),
            onTap: () {
              Navigator.pushNamed(context, '/ex2');
            },
          ),
          ListTile(
            title: const Text(
              Ex3.nomExercice,
              style: TextStyle(color: Colors.black), // Couleur du texte en noir
            ),
            onTap: () {
              Navigator.pushNamed(context, '/ex3');
            },
          ),
        ],
      ),
    );
  }
}
