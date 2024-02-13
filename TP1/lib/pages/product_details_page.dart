import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:media_app/providers/likes_provider.dart';
import 'package:media_app/classes/product_class.dart';
import 'package:media_app/global_variable.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;
  const ProductDetailsPage({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  String selectedVersion = ''; // Variable pour stocker la version sélectionnée

  void onTap() {
    if (selectedVersion == ''){
      selectedVersion = 'normal';
    }
    Provider.of<LikesProvider>(context, listen: false).addProduct({
      'id': widget.product.id,
      'title': widget.product.title,
      'imageUrl': widget.product.imageUrl,
      'category': widget.product.category,
      'players': widget.product.players,
      'duration': widget.product.duration,
      'description': widget.product.description,
      'version': selectedVersion, // Ajoutez la version sélectionnée
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Product liked!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: Column(
        children: [
          Text(
            widget.product.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(
              widget.product.imageUrl,
              height: 250,
            ),
          ),
          const Spacer(flex: 2),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.product.description, // Utilisation de la description
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 20), // Espacement entre la description et les détails
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Players: ${widget.product.players}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 20), // Espacement entre les détails
                  Text(
                    'Duration: ${widget.product.duration}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20), // Espacement entre les détails et les puces de version
              Text(
                  // '₱${widget.product.category}',
                  'Version :',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: versionsJeu.keys.map((versionKey) {
                  final versionName = versionsJeu[versionKey]!;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedVersion = versionKey;
                        });
                      },
                      child: Chip(
                        backgroundColor: selectedVersion == versionKey
                            ? Theme.of(context).colorScheme.primary
                            : null,
                        label: Text(versionName),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                fixedSize: const Size(350, 50),
              ),
              child: const Text(
                'Add To Likes',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w100,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
