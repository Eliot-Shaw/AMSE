import 'package:flutter/material.dart';
import 'package:tp2/ex1.dart';
import 'package:tp2/ex2.dart';
import 'package:tp2/ex3.dart';
import 'package:tp2/ex4.dart';
import 'package:tp2/ex5a.dart';
import 'package:tp2/ex5b.dart';
import 'package:tp2/ex5c.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, Widget Function(BuildContext)> lesRoutes = {
      '/ex1': (context) => const Ex1(),
      '/ex2': (context) => const Ex2(),
      '/ex3': (context) => const Ex3(),
      '/ex4': (context) => const Ex4(),
      '/ex5a': (context) => const Ex5a(),
      '/ex5b': (context) => const Ex5b(),
      '/ex5c': (context) => const Ex5c(),
    };

    return MaterialApp(
      title: 'TP2',
      routes: lesRoutes,
      home: ExerciseListPage(routes: lesRoutes),
    );
  }
}

class ExerciseListPage extends StatelessWidget {
  final Map<String, WidgetBuilder> routes;

  const ExerciseListPage({super.key, required this.routes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des exercices'),
        backgroundColor: const Color.fromARGB(255, 150, 131, 236),
      ),
      body: ListView(
  children: [
    for (var route in routes.keys)
      Column(
        children: [
          ListTile(
            title: Center(child: Text((routes[route]!(context) as dynamic).getExerciceName())),
            onTap: () {
              Navigator.pushNamed(context, route);
            },
          ),
          const Divider(
            color: Color.fromARGB(255, 150, 131, 236),
            height: 1,
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
        ],
      ),
  ],
),

    );
  }
}

