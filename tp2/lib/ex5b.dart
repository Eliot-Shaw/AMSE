import 'package:flutter/material.dart';

class Ex5b extends StatelessWidget {
  static const String nomExercice = "Tuiles à partir d'une image";
  static const int tilesLigne = 4;
  static const String imageURL = "assets/images/wallebra.png";

  const Ex5b({super.key});
  String getExerciceName() {
    return nomExercice;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(nomExercice),
        backgroundColor: const Color.fromARGB(255, 150, 131, 236),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Cropped Image",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: GridView.count(
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              crossAxisCount: tilesLigne,
              children: generateTiles(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> generateTiles() {
    List<Widget> tiles = [];
    int totalTiles = tilesLigne * tilesLigne;

    for (int i = 0; i < totalTiles; i++) {
      tiles.add(Tile(
        imageURL: imageURL,
        alignment: calculateAlignment(i),
      ));
    }

    return tiles;
  }

  Alignment calculateAlignment(int index) {
    int row = index ~/ tilesLigne;
    int column = index % tilesLigne;

    double horizontalAlignment = (column / (tilesLigne - 1)) * 2 - 1;
    double verticalAlignment = (row / (tilesLigne - 1)) * 2 - 1;
    return Alignment(horizontalAlignment, verticalAlignment);
  }
}

class Tile extends StatelessWidget {
  final String imageURL;
  final Alignment alignment;

  const Tile({super.key, required this.imageURL, required this.alignment});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fill,
      child: ClipRect(
        child: Align(
          alignment: alignment,
          widthFactor: 1 / Ex5b.tilesLigne,
          heightFactor: 1 / Ex5b.tilesLigne,
          child: Image.asset(imageURL),
        ),
      ),
    );
  }
}
