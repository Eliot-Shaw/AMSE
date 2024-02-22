import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:math' as math;

math.Random random = math.Random();

class Ex7c extends StatelessWidget {
  static const String nomExercice = "Jeu de taquin avec une image";

  const Ex7c({Key? key});

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
  static const String imageURL = "assets/images/wallebra.png";
  int sliderMin = 2;
  int sliderMax = 10;
  int _currentSliderValueGridCount = 3;
  int difficulteMixage = 20;

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
        title: const Text(Ex7c.nomExercice),
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
      child: tile.toWidget(1 / _currentSliderValueGridCount),
      onTap: () {
        int index = tile.indexTile;
        if(listTiles[index].isEmpty){
          print("Tu as trouvé la tile vide !");
        }
        trySwap(index);
        partieGagnee();
      },
    );
  }

  bool trySwap(index){
    if (index < 0){
      print("index<0");
      return false;
    };
    if (index > _currentSliderValueGridCount*_currentSliderValueGridCount-1){
      print("index>${_currentSliderValueGridCount*_currentSliderValueGridCount-1}");
      return false;
    };
    bool succeed = false;
    if(index-1 >= 0 && listTiles[index-1].isEmpty){
      if(index%_currentSliderValueGridCount != 0){
        succeed = true;
        swapTiles(index-1, index);
      }
    }else if(index+1 <= _currentSliderValueGridCount*_currentSliderValueGridCount-1 && listTiles[index+1].isEmpty){
      if((index+1)%_currentSliderValueGridCount != 0){
        succeed = true;
        swapTiles(index+1, index);
      }
    }else if(index-_currentSliderValueGridCount >= 0 && listTiles[index-_currentSliderValueGridCount].isEmpty){
      succeed = true;
      swapTiles(index-_currentSliderValueGridCount, index);
    }else if(index+_currentSliderValueGridCount <= _currentSliderValueGridCount*_currentSliderValueGridCount-1 && listTiles[index+_currentSliderValueGridCount].isEmpty){
      succeed = true;
      swapTiles(index+_currentSliderValueGridCount, index);
    }
    return succeed;
  }

  void regenerateTiles() {
    int tileVide = Random().nextInt(_currentSliderValueGridCount*_currentSliderValueGridCount);
    setState(() {
      listTiles = List<Tile>.generate(_currentSliderValueGridCount * _currentSliderValueGridCount, (index) {
        if (index == tileVide) {
          return Tile(index, true, index, imageURL, calculateAlignment(index));
        } else {
          return Tile(index, false, index, imageURL, calculateAlignment(index));
        }
      });
      
      for(int i = 0; i < difficulteMixage; i++) {
        int direction;
        bool shuffled = false;
        int offset;
        while (!shuffled) {
          direction = Random().nextInt(4);
          offset = 0;
          switch (direction) {
            case 0:
              offset = -1;
              break;
            case 1:
              offset = 1;
              break;
            case 2:
              offset = -_currentSliderValueGridCount;
              break;
            case 3:
              offset = _currentSliderValueGridCount;
              break;
            default:
              print("Erreur: le générateur de nombres aléatoires est cassé");
          }
          shuffled = trySwap(tileVide + offset);
          for(int j = 0; j< _currentSliderValueGridCount*_currentSliderValueGridCount; j++){
            if(listTiles[j].isEmpty){
              tileVide = j;
              break;
            }
          }
          print("while i:$i current:$_currentSliderValueGridCount, shuffled = trySwap($tileVide + $offset); ${listTiles[tileVide].isEmpty}");
        }

      }

      for (int i = 0; i < listTiles.length; i++) {
        listTiles[i].indexTile = i;
      }
    });
  }

  Alignment calculateAlignment(int index) {
    int row = index ~/ _currentSliderValueGridCount; 
    int column = index % _currentSliderValueGridCount; 

    double horizontalAlignment = (column / (_currentSliderValueGridCount - 1)) * 2 - 1; 
    double verticalAlignment = (row / (_currentSliderValueGridCount - 1)) * 2 - 1; 
    return Alignment(horizontalAlignment, verticalAlignment);
  }

  bool partieGagnee(){
    if (listTiles[0].indexPosFinale != 0) return false;
    for(int i = 1; i< listTiles.length; i++) {
      if(listTiles[i].indexPosFinale-listTiles[i-1].indexPosFinale != 1) return false;
    }
    print("youhou");
    return true;
  }

  void swapTiles(indexEmpty, indexAChanger) {
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
  }
}

class Tile {
  late String imageURL;
  late Alignment alignment;
  late int indexTile;
  late int indexPosFinale;
  late Color color;
  bool isEmpty = false;

  Tile(this.indexTile, this.isEmpty, this.indexPosFinale, this.imageURL, this.alignment) {
    color = Color.fromARGB(255, random.nextInt(255), random.nextInt(255), random.nextInt(255));
  }

  Widget toWidget(double taille) {
    if (!isEmpty) {
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
    } else {
      return FittedBox(
        fit: BoxFit.fill,
        child: Opacity(
          opacity: 0.3,
          child: ClipRect(
            child: Align(
              alignment: alignment,
              widthFactor: taille,
              heightFactor: taille,
              child: Image.asset(imageURL, color: const Color.fromARGB(255, 150, 131, 236), colorBlendMode: BlendMode.overlay),
            ),
          ),
        ),
      );
    }
  }
}