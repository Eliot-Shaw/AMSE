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


  int getIndexTile() {
    return indexTile;
  }
}

class Ex6b extends StatelessWidget {
  static const String nomExercice = "Echanger deux tuiles d'un plateau";

  const Ex6b({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MyHomePage();
  }

  String getExerciceName(){
    return nomExercice;
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Tile> listTiles;
  int tileVide = Random().nextInt(4*4);
  @override
  void initState() {
    super.initState();
    listTiles = List<Tile>.generate(16, (index) {
      if (index == tileVide) {
        return Tile(index, true);
      } else {
        return Tile(index, false);
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Ex6b.nomExercice),
        backgroundColor: const Color.fromARGB(255, 150, 131, 236),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
          crossAxisCount: 4,
          children: listTiles.map((tile) {
            return createTileWidgetFrom(tile);
          }).toList(),
        ),
      ),
    );
  }

  Widget createTileWidgetFrom(Tile tile) {
    return InkWell(
      child: tile.toWidget(),
      onTap: () {
        int index = tile.indexTile;
        // print("Tapped on tile at index: $index");
        if(index-1 >= 0 && listTiles[index-1].isEmpty){
          swapTiles(index-1, index);
        }else if(index+1 <= 4*4-1 && listTiles[index+1].isEmpty){
          swapTiles(index+1, index);
        }else if(index-4 >= 0 && listTiles[index-4].isEmpty){
          swapTiles(index-4, index);
        }else if(index+4 <= 4*4-1 && listTiles[index+4].isEmpty){
          swapTiles(index+4, index);
        }
        // print("---");
      },
    );
  }

  swapTiles(indexEmpty, indexAChanger) {
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
