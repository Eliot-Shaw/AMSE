// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'dart:math';


void main() async {
  int numberImages = 16;
  int numberRowCol = sqrt(numberImages).round();
  int smallImageWidthHeight = 720~/numberRowCol;

  try {
    // Chemin de l'image d'entrée
    const String inputImagePath = './square_crop.png';

    // Charger l'image depuis le fichier
    final File inputFile = File(inputImagePath);
    final Uint8List inputImageBytes = await inputFile.readAsBytes();

    // Convertir les bytes en Uint8List
    final img.Image? inputImage = img.decodeImage(Uint8List.fromList(inputImageBytes));

    if (inputImage != null) {
      // Dimensions de chaque petite image

      // Créer un répertoire pour stocker les images découpées
      final Directory outputDir = Directory('./separated_image');
      if (!outputDir.existsSync()) {
        outputDir.createSync();
      }

      int count = 1;
      // Découper l'image en 16 images régulières
      for (int i = 0; i < numberRowCol; i++) {
        for (int j = 0; j < numberRowCol; j++) {
          // Découper la partie de l'image correspondante
          final img.Image smallImage = img.copyCrop(
            inputImage,
            x: j * smallImageWidthHeight,
            y: i * smallImageWidthHeight,
            width: smallImageWidthHeight,
            height: smallImageWidthHeight,
          );

          // Enregistrer l'image découpée dans un fichier
          final String outputPath = './separated_image/image_$count.png';
          File(outputPath).writeAsBytesSync(img.encodePng(smallImage));

          print('Image $count découpée avec succès et enregistrée sous $outputPath.');

          count++;
        }
      }
    } else {
      print('Impossible de décoder l\'image d\'entrée.');
    }
  } catch (e) {
    print('Une erreur s\'est produite : $e');
  }
}
