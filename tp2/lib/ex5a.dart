import 'package:flutter/material.dart';

class Ex5a extends StatelessWidget {
  static const String nomExercice = "Génération du plateau de tuiles";

  const Ex5a({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyHomePage();
  }

  String getExerciceName() {
    return nomExercice;
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  static const int ratioTuiles = 5;
  static const double tailleTile = 75;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Ex5a.nomExercice),
        backgroundColor: const Color.fromARGB(255, 150, 131, 236),
      ),
      body: Center(
        child: SizedBox(
          width: ratioTuiles * (tailleTile+1),
          height: ratioTuiles * (tailleTile+1),
          child: GridView.count(
            crossAxisCount: ratioTuiles,
            childAspectRatio: 1.0,
            children: List.generate(ratioTuiles*ratioTuiles, (index) {
              return Center(
                child: Container(
                  width: tailleTile,
                  height: tailleTile,
                  color: const Color.fromARGB(255, 150, 131, 236), //lzvzndr
                  child: Center(
                    child: Text(
                      'Tile $index',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
