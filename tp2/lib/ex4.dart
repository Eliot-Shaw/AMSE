import 'package:flutter/material.dart';

class Tile {
  String imageURL;
  Alignment alignment;

  Tile({required this.imageURL, required this.alignment});

  Widget croppedImageTile() {
    return FittedBox(
      fit: BoxFit.fill,
      child: ClipRect(
        child: Container(
          child: Align(
            alignment: alignment,
            child: Image.network(
              imageURL,
              width: 150.0,
              height: 150.0,
              fit: BoxFit.cover,
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
  


  final Tile tile = Tile(
    imageURL: imageURL,
    alignment: Alignment.center,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Ex4.nomExercice),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              width: 150.0,
              height: 150.0,
              child: Container(
                margin: const EdgeInsets.all(20.0),
                child: InkWell(
                  child: tile.croppedImageTile(),
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
