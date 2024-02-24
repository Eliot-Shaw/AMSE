// ignore_for_file: avoid_print

import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:math' as math;

math.Random random = math.Random();

class Tile {
  late int indexTile;
  late int indexPosFinale;
  late Color color;
  bool isEmpty = false;

  Tile(this.indexTile, this.isEmpty, this.indexPosFinale) {
    color = Color.fromARGB(255, random.nextInt(255), random.nextInt(255), random.nextInt(255));
  }

  Widget toWidget() {
    if (!isEmpty) {
      return Container(
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(70.0),
          child: Text(
            indexPosFinale.toString(),
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
            indexPosFinale.toString(),
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

class Ex7a extends StatelessWidget {
  static const String nomExercice = "Jeu de taquin couleurs random";

  const Ex7a({super.key});

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
  int sliderMin = 2;
  int sliderMax = 10;
  int _currentSliderValueGridCount = 3;

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
        title: const Text(Ex7a.nomExercice),
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
          ElevatedButton(
            onPressed: () {
              regenerateTiles();
            },
            child: const Text('Nouvelle Partie'),
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

  void shuffleSilent(index){
    if(index-1 >= 0 && listTiles[index-1].isEmpty){
      if(index%_currentSliderValueGridCount != 0){
        swapTiles(index-1, index, silent: true);
      }
    }else if(index+1 <= _currentSliderValueGridCount*_currentSliderValueGridCount-1 && listTiles[index+1].isEmpty){
      if((index+1)%_currentSliderValueGridCount != 0){
        swapTiles(index+1, index, silent: true);
      }
    }else if(index-_currentSliderValueGridCount >= 0 && listTiles[index-_currentSliderValueGridCount].isEmpty){
      swapTiles(index-_currentSliderValueGridCount, index, silent: true);
    }else if(index+_currentSliderValueGridCount <= _currentSliderValueGridCount*_currentSliderValueGridCount-1 && listTiles[index+_currentSliderValueGridCount].isEmpty){
      swapTiles(index+_currentSliderValueGridCount, index, silent: true);
    }
  }

  void regenerateTiles() {
    int tileVide = Random().nextInt(_currentSliderValueGridCount*_currentSliderValueGridCount);
    setState(() {
      listTiles = List<Tile>.generate(_currentSliderValueGridCount * _currentSliderValueGridCount, (index) {
        if (index == tileVide) {
          return Tile(index, true, index);
        } else {
          return Tile(index, false, index);
        }
      });
      
      for(int i = 0; i<10000; i++){ //fatigue : abandon on shuffle comme des sacs
        int index = Random().nextInt(_currentSliderValueGridCount*_currentSliderValueGridCount);
        shuffleSilent(index);
      }

      for (int i = 0; i < listTiles.length; i++) {
        listTiles[i].indexTile = i;
      }
    });
  }


  bool partieGagnee(){
    if (listTiles[0].indexPosFinale != 0) return false;
    for(int i = 1; i< listTiles.length; i++) {
      if(listTiles[i].indexPosFinale-listTiles[i-1].indexPosFinale != 1) return false;
    }
    print("youhou");
    return true;
  }

  void swapTiles(indexEmpty, indexAChanger, {bool silent = false}) {
    // print("Swapping $indexAChanger with: $indexEmpty");
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
    if(!silent){partieGagnee();}
  }
}
