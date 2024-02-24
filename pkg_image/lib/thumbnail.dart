// ignore_for_file: avoid_print

import 'dart:io';
import 'package:image/image.dart' as img;

void main() async {
  try {
    print('Début du traitement...');
    
    // Lire l'image WebP à partir d'un fichier.
    final image = img.decodePng(File('./wallebra.png').readAsBytesSync());
    
    // Vérifier si l'image est correctement lue.
    if (image != null) {
      print('Lecture de l\'image réussie.');
      
      // Redimensionner l'image pour que sa largeur soit de 120 pixels et que la hauteur maintienne le ratio.
      final thumbnail = img.copyResize(image, width: 120);
      
      // Enregistrer l'image redimensionnée dans un fichier PNG.
      File('./thumbnail.png').writeAsBytesSync(img.encodePng(thumbnail));
      
      print('Image redimensionnée enregistrée avec succès sous "thumbnail.png".');
    } else {
      print('Échec de la lecture de l\'image.');
    }
    
    print('Fin du traitement.');
  } catch (e) {
    print('Une erreur s\'est produite : $e');
  }
}
