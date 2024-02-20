import 'package:flutter/material.dart';

class Ex4 extends StatelessWidget {
  static const String nomExercice = "Suite...";

  const Ex4({super.key});
  @override
  Widget build(BuildContext context) {
    return const MyHomePage();
  }

  String getExerciceName(){
    return nomExercice;
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
        title: const Text(Ex4.nomExercice),
        backgroundColor: const Color.fromARGB(255, 150, 131, 236),
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
