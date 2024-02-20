import 'package:flutter/material.dart';

class Tile {
  String imageURL;
  double tailleTile;
  
  Tile({required this.imageURL, required this.tailleTile});
  int ratioTuiles = 3;
  
  Widget croppedImageTile(int index) {
    int row = index ~/ ratioTuiles;
    int col = index % ratioTuiles;
    double startX = col * tailleTile;
    double startY = row * tailleTile;

    return FittedBox(
      fit: BoxFit.fill,
      child: ClipRect(
        child: Container(
          child: Align(
            alignment: Alignment.topLeft,
            child: Image.network(
              imageURL,
              width: tailleTile,
              height: tailleTile,
              fit: BoxFit.fill,
              alignment: Alignment(-startX / tailleTile, -startY / tailleTile),
            ),
          ),
        ),
      ),
    );
  }
}
class Ex4 extends StatelessWidget {
  static const String nomExercice = "Affichage d'une tuile";

  const Ex4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyHomePage();
  }

  String getExerciceName(){
    return nomExercice;
  }
}

class MyHomePage extends StatelessWidget {
  static const String imageURL = "assets/images/wallebra.png";
  static const double tailleTile = 150;
  final Tile tile = Tile(
    imageURL: imageURL,
    tailleTile: tailleTile
  );

  MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Ex4.nomExercice),
        backgroundColor:const Color.fromARGB(255, 150, 131, 236),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              width: tailleTile,
              height: tailleTile,
              child: Container(
                margin: const EdgeInsets.all(20.0),
                child: InkWell(
                  child: tile.croppedImageTile(0),
                  onTap: () {
                    print("Tapped on tile");
                  },
                ),
              ),
            ),
            Image.asset(imageURL)
          ],
        ),
      ),
    );
  }
}
