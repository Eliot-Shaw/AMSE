import 'package:flutter/material.dart';

class Ex3 extends StatelessWidget {
  static const String nomExercice = "Menu et navigation entre pages";

  const Ex3({super.key});
  @override
  Widget build(BuildContext context) {
    return const MyHomePage();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(Ex3.nomExercice),
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
