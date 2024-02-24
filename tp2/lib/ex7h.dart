// ignore_for_file: avoid_print, library_private_types_in_public_api

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class Ex7h extends StatelessWidget {
  static const String nomExercice = "Prendre une photo";

  const Ex7h({super.key});

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
  late String imageURL = "assets/images/rainbow.jpg";
  
  int minGridSize = 2;
  int maxGridSize = 10;
  int _currentSliderValueGridCount = 3;
  double minDiffMixage = 0.99;
  double maxDiffMixage = 6.9077552789821370520539743640530926228033044658863189280999837029;
  double _currentSliderValueDiffMix = 3;
  int difficulteMixage = 15;
  int pas = 0;

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
        title: const Text(Ex7h.nomExercice),
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
          Text('Nombre de pas : $pas'),
          ElevatedButton(
            onPressed: () {
              regenerateTiles();
            },
            child: const Text('Nouvelle Partie'),
          ),
          Slider(
            divisions: maxGridSize-minGridSize,
            value: _currentSliderValueGridCount.toDouble(),
            min: minGridSize.toDouble(),
            max: maxGridSize.toDouble(),
            onChanged: (double value) {
              setState(() {
                if (_currentSliderValueGridCount != value.toInt()){
                  _currentSliderValueGridCount = value.toInt();
                  regenerateTiles();
                }
              });
            },
            label: "${_currentSliderValueGridCount.toInt()}",
          ),
          Slider(
            divisions: 5,
            value: _currentSliderValueDiffMix.toDouble(),
            min: minDiffMixage,
            max: maxDiffMixage,
            onChanged: (double value) {
              setState(() {
                if (_currentSliderValueDiffMix != value.toInt()){
                  _currentSliderValueDiffMix = value;
                  difficulteMixage = exp(value).toInt();
                  regenerateTiles();
                }
              });
            },
            label: "$difficulteMixage",
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CameraScreen(updateImageUrl: updateImageUrl)),
              );
            },
            child: const Text('Prendre une photo'),
          ),
        ],
      ),
    );
  }

  void updateImageUrl(String newImageUrl) {
    setState(() {
      imageURL = newImageUrl;
      regenerateTiles();
    });
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
      return false;
    }
    if (index > _currentSliderValueGridCount*_currentSliderValueGridCount-1){
      return false;
    }
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
        }

      }

      for (int i = 0; i < listTiles.length; i++) {
        listTiles[i].indexTile = i;
      }
      pas = 0;
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
    pas++;
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
    color = Color.fromARGB(255, Random().nextInt(255), Random().nextInt(255), Random().nextInt(255));
  }

  Widget toWidget(double taille) {
    if (imageURL.startsWith("assets/")){
      if (!isEmpty) {
        return FittedBox(
          fit: BoxFit.fill,
          child: ClipRect(
            child: Align(
              alignment: alignment,
              widthFactor: taille,
              heightFactor: taille,
              child: SizedBox(width: taille, height: taille, child: FittedBox(fit:BoxFit.cover ,child: Image.asset(imageURL))),
            ),
          ),
        );
      } else {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 150, 131, 236), width: 5.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: FittedBox(
            fit: BoxFit.fill,
            child: Opacity(
              opacity: 0.3,
              child: ClipRect(
                child: Align(
                  alignment: alignment,
                  widthFactor: taille,
                  heightFactor: taille,
                  child: SizedBox(width: taille, height: taille, child: FittedBox(fit:BoxFit.cover ,child: Image.asset(
                    imageURL,
                    color: const Color.fromARGB(255, 150, 131, 236),
                    colorBlendMode: BlendMode.overlay,
                    // colorBlendMode: BlendMode.overlay,
                  ))),
                ),
              ),
            ),
          ),
        );
      }
    } else {
      if (!isEmpty) {
        return FittedBox(
          fit: BoxFit.cover,
          child: ClipRect(
            child: Align(
              alignment: alignment,
              widthFactor: taille,
              heightFactor: taille,
              child: SizedBox(width: taille, height: taille, child: FittedBox(fit:BoxFit.cover ,child: Image.file(File(imageURL)))),
            ),
          ),
        );
      } else {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 150, 131, 236), width: 5.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: FittedBox(
            fit: BoxFit.cover,
            child: Opacity(
              opacity: 0.3,
              child: ClipRect(
                child: Align(
                  alignment: alignment,
                  widthFactor: taille,
                  heightFactor: taille,
                  child: SizedBox(width: taille, height: taille, child: FittedBox(fit:BoxFit.cover ,child: Image.file(
                    File(imageURL),
                    color: const Color.fromARGB(255, 150, 131, 236),
                    colorBlendMode: BlendMode.overlay,
                  ))),
                ),
              ),
            ),
          ),
        );
      }
    }
  }
}

class CameraScreen extends StatefulWidget {
  final Function(String) updateImageUrl;

  const CameraScreen({super.key, required this.updateImageUrl});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      const CameraDescription(
        name: "0",
        lensDirection: CameraLensDirection.back,
        sensorOrientation: 90,
        // resolutionPreset: ResolutionPreset.medium,
      ),
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();
            widget.updateImageUrl(image.path);
            print(image.path);
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
