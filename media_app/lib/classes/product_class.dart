import 'package:media_app/global_variable.dart'; // Assurez-vous de mettre le bon chemin d'accès

class Product {
  final String id;
  final String title;
  final String category;
  final String players;
  final String duration;
  final String imageUrl;
  final String description;

  Product({
    required this.id,
    required this.title,
    required this.category,
    required this.players,
    required this.duration,
    required this.imageUrl,
    required this.description,
  });

  factory Product.fromMap(Map<String, String> map) {
    return Product(
      id: map['id']!,
      title: map['title']!,
      category: map['category']!,
      players: map['players']!,
      duration: map['duration']!,
      imageUrl: map['imageUrl']!,
      description: map['description']!,
    );
  }
}

List<Product> products = productsData.map((data) => Product.fromMap(data)).toList();
