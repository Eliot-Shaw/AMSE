import 'package:flutter/material.dart';
import 'package:tp2/ex1.dart';
import 'package:tp2/ex2.dart';
import 'package:tp2/ex3.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Liste des exercices',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ExerciseListPage(),
      routes: {
        '/ex1': (context) => const Ex1(),
        '/ex2': (context) => const Ex2(),
        '/ex3': (context) => const Ex3(),
      },
    );
  }
}

class ExerciseListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des exs'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Ex 1'),
            onTap: () {
              Navigator.pushNamed(context, '/ex1');
            },
          ),
          ListTile(
            title: const Text('Ex 2'),
            onTap: () {
              Navigator.pushNamed(context, '/ex2');
            },
          ),
          ListTile(
            title: const Text('Ex 3'),
            onTap: () {
              Navigator.pushNamed(context, '/ex3');
            },
          ),
        ],
      ),
    );
  }
}
