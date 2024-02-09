// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final String category;
  final String image;
  final String players;
  final String duration;
  final String description;
  final Color backgroundColor;
  const ProductCard({
    Key? key,
    required this.title,
    required this.category,
    required this.image,
    required this.players,
    required this.duration,
    required this.description,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 5),
          Text(
            category,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 5),
          Center(
            child: Image.asset(image, height: 175),
          )
        ],
      ),
    );
  }
}
