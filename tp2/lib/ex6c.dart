// ignore_for_file: avoid_print

import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:math' as math;

math.Random random = math.Random();

class Tile {
  late int indexTile;
  late Color color;
  bool isEmpty = false;

  Tile(this.indexTile, this.isEmpty) {
    color = Color.fromARGB(255, random.nextInt(255), random.nextInt(255), random.nextInt(255));
  }

  Widget toWidget() {
    if (!isEmpty) {
      return Container(
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(70.0),
          child: Text(
            indexTile.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
      );
    } else {
      return Container(
        color: const Color.fromARGB(255, 0, 0, 0),
        child: Padding(
          padding: const EdgeInsets.all(70.0),
          child: Text(
            indexTile.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
      );
    }
  }
}

class Ex6c extends StatelessWidget {
  static const String nomExercice = "Echanger deux tuiles d'un plateau de taille variable";

  const Ex6c({super.key});

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
  int _currentSliderValueGridCount = 4;
  int sliderMin = 2;
  int sliderMax = 10;

  late List<Tile> listTiles;
  @override
  void initState() {
    super.initState();
    regenerateTiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Ex6c.nomExercice),
        backgroundColor: const Color.fromARGB(255, 150, 131, 236),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
                crossAxisCount: _currentSliderValueGridCount,
                children: listTiles.map((tile) {
                  return createTileWidgetFrom(tile);
                }).toList(),
              ),
            ),
          ),
          Slider(
            value: _currentSliderValueGridCount.toDouble(),
            min: sliderMin.toDouble(),
            max: sliderMax.toDouble(),
            onChanged: (double value) {
              setState(() {
                if (_currentSliderValueGridCount != value.toInt()){
                  _currentSliderValueGridCount = value.toInt();
                  regenerateTiles();
                }
              });
            },
            label: "$_currentSliderValueGridCount",
          ),
        ],
      ),
    );
  }


  Widget createTileWidgetFrom(Tile tile) {
    return InkWell(
      child: tile.toWidget(),
      onTap: () {
        int index = tile.indexTile;
        if(listTiles[index].isEmpty){
          print("Tu as trouvé la tile vide !");
        }
        if(index-1 >= 0 && listTiles[index-1].isEmpty){
          if(index%_currentSliderValueGridCount != 0){
            swapTiles(index-1, index);
          }
        }else if(index+1 <= _currentSliderValueGridCount*_currentSliderValueGridCount-1 && listTiles[index+1].isEmpty){
          if((index+1)%_currentSliderValueGridCount != 0){
            swapTiles(index+1, index);
          }
        }else if(index-_currentSliderValueGridCount >= 0 && listTiles[index-_currentSliderValueGridCount].isEmpty){
          swapTiles(index-_currentSliderValueGridCount, index);
        }else if(index+_currentSliderValueGridCount <= _currentSliderValueGridCount*_currentSliderValueGridCount-1 && listTiles[index+_currentSliderValueGridCount].isEmpty){
          swapTiles(index+_currentSliderValueGridCount, index);
        }
      },
    );
  }

  void regenerateTiles() {
    int tileVide = Random().nextInt(_currentSliderValueGridCount*_currentSliderValueGridCount);
    setState(() {
      listTiles = List<Tile>.generate(_currentSliderValueGridCount * _currentSliderValueGridCount, (index) {
        if (index == tileVide) {
          return Tile(index, true);
        } else {
          return Tile(index, false);
        }
      });
    });
  }

  void swapTiles(indexEmpty, indexAChanger) {
    print("Swapping $indexAChanger with: $indexEmpty");
    setState(() {
      Tile tileEmpty = listTiles[indexEmpty];
      Tile tileToChange = listTiles[indexAChanger];

      if(indexEmpty > indexAChanger){
        listTiles.insert(indexEmpty, tileToChange);
        listTiles.remove(tileEmpty);

        listTiles.insert(indexAChanger, tileEmpty);
        listTiles.remove(tileToChange);
      }else{
        listTiles.insert(indexAChanger, tileEmpty);
        listTiles.remove(tileToChange);

        listTiles.insert(indexEmpty, tileToChange);
        listTiles.remove(tileEmpty);
      }

      int indexTemp = listTiles[indexAChanger].indexTile;
      listTiles[indexAChanger].indexTile = listTiles[indexEmpty].indexTile;
      listTiles[indexEmpty].indexTile = indexTemp;
    });
  }
}
