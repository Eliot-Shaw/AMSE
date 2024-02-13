import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

void main() async {
  try {
    // Chemin de l'image d'entrée
    const String inputImagePath = './wallebra.png';

    // Chemin de l'image de sortie
    const String outputImagePath = './square_crop.png';

    // Charger l'image depuis le fichier
    final File inputFile = File(inputImagePath);
    final List<int> inputImageBytes = await inputFile.readAsBytes();

    // Décoder l'image
    final img.Image inputImage = img.decodeImage(Uint8List.fromList(inputImageBytes))!;

    // Déterminer les dimensions de l'image carrée de sortie (par exemple, 200x200 pixels)
    const int squareSize = 720;

    // Recadrer l'image pour la rendre carrée
    final img.Image outputImage = img.copyResizeCropSquare(inputImage, size: squareSize);

    // Enregistrer l'image recadrée dans un fichier
    File(outputImagePath).writeAsBytesSync(img.encodePng(outputImage));

    print('L\'image a été recadrée avec succès et enregistrée sous $outputImagePath.');
  } catch (e) {
    print('Une erreur s\'est produite : $e');
  }
}
