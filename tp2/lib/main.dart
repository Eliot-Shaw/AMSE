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
    Map<String, Widget Function(BuildContext)> lesRoutes = {
      '/ex1': (context) => const Ex1(),
      '/ex2': (context) => const Ex2(),
      '/ex3': (context) => const Ex3(),
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        children: routes.keys.map((route) {
          return ListTile(
            title: Text((routes[route]!(context) as dynamic).getExerciceName()),
            onTap: () {
              Navigator.pushNamed(context, route);
            },
          );
        }).toList(),
      ),
    );
  }
}

