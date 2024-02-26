import 'package:flutter/material.dart';
import 'package:tp2/ex1.dart';
import 'package:tp2/ex2.dart';
import 'package:tp2/ex3.dart';
import 'package:tp2/ex4.dart';
import 'package:tp2/ex5a.dart';
import 'package:tp2/ex5b.dart';
import 'package:tp2/ex5c.dart';
import 'package:tp2/ex6a.dart';
import 'package:tp2/ex6b.dart';
import 'package:tp2/ex6c.dart';
import 'package:tp2/ex7a.dart';
import 'package:tp2/ex7b.dart';
import 'package:tp2/ex7c.dart';
import 'package:tp2/ex7d.dart';
import 'package:tp2/ex7e.dart';
import 'package:tp2/ex7f.dart';
import 'package:tp2/ex7g.dart';
import 'package:tp2/ex7h.dart';
import 'package:tp2/ex7i.dart';
import 'package:tp2/ex7j.dart';
import 'package:tp2/ex7k.dart';
import 'package:tp2/ex7l.dart';
import 'package:tp2/ex7m.dart';

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
      '/ex6a': (context) => const Ex6a(),
      '/ex6b': (context) => const Ex6b(),
      '/ex6c': (context) => const Ex6c(),
      '/ex7a': (context) => const Ex7a(),
      '/ex7b': (context) => const Ex7b(),
      '/ex7c': (context) => const Ex7c(),
      '/ex7d': (context) => const Ex7d(),
      '/ex7e': (context) => const Ex7e(),
      '/ex7f': (context) => const Ex7f(),
      '/ex7g': (context) => const Ex7g(),
      '/ex7h': (context) => const Ex7h(),
      '/ex7i': (context) => const Ex7i(),
      '/ex7j': (context) => const Ex7j(),
      '/ex7k': (context) => const Ex7k(),
      '/ex7l': (context) => const Ex7l(),
      '/ex7m': (context) => const Ex7m(),
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

