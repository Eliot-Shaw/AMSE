import 'package:flutter/material.dart';

class Tile {
  String imageURL;
  Alignment alignment;

  Tile({required this.imageURL, required this.alignment});

  Widget croppedImageTile(double taille) {
    return FittedBox(
      fit: BoxFit.fill,
      child: ClipRect(
        child: Align(
          alignment: alignment,
          widthFactor: taille,
          heightFactor: taille,
          child: Image.asset(imageURL),
        ),
      ),
    );
  }
}

class Ex5c extends StatefulWidget {
  static const String nomExercice = "Nb Tuiles Dynamiques";

  const Ex5c({super.key});
  
  String getExerciceName() {
    return nomExercice;
  }
  
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Ex5c> {
  static const String imageURL = "assets/images/wallebra.png";
  int _currentSliderValueGridCount = 2;

  List<Tile> generateTiles() {
    List<Tile> tiles = [];
    int totalTiles = _currentSliderValueGridCount * _currentSliderValueGridCount;

    for (int i = 0; i < totalTiles; i++) {
      tiles.add(Tile(
        imageURL: imageURL,
        alignment: calculateAlignment(i),
      ));
    }
    return tiles;
  }

  Alignment calculateAlignment(int index) {
    int row = index ~/ _currentSliderValueGridCount; 
    int column = index % _currentSliderValueGridCount; 

    double horizontalAlignment = (column / (_currentSliderValueGridCount - 1)) * 2 - 1; 
    double verticalAlignment = (row / (_currentSliderValueGridCount - 1)) * 2 - 1; 
    return Alignment(horizontalAlignment, verticalAlignment);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Ex5c.nomExercice),
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
              crossAxisCount: _currentSliderValueGridCount,
              children: generateTiles().map((tile) {
                return createTileWidgetFrom(tile);
              }).toList(),
            ),
          ),
          Slider(
            value: _currentSliderValueGridCount.toDouble(),
            min: 2,
            max: 10,
            onChanged: (double value) {
              setState(() {
                _currentSliderValueGridCount = value.toInt();
              });
            },
            divisions: 6,
            label: "$_currentSliderValueGridCount",
          ),
        ],
      ),
    );
  }

  Widget createTileWidgetFrom(Tile tile) {
    return InkWell(
      child: tile.croppedImageTile(1 / _currentSliderValueGridCount),
      onTap: () {
        print("tapped on tile");
      },
    );
  }
}
