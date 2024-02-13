import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:media_app/providers/likes_provider.dart';
import 'package:media_app/pages/product_details_page.dart';
import 'package:media_app/classes/product_class.dart';


class LikesPage extends StatelessWidget {
  const LikesPage({Key? key});

  @override
  Widget build(BuildContext context) {
    final likes = context.watch<LikesProvider>().likes;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Likes'),
      ),
      body: ListView.builder(
        itemCount: likes.length,
        itemBuilder: (context, index) {
          final likesItem = likes[index];
                      return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailsPage(
                    product: Product(
                      id: likesItem['id'],
                      title: likesItem['title'],
                      category: likesItem['category'],
                      players: likesItem['players'],
                      duration: likesItem['duration'],
                      imageUrl: likesItem['imageUrl'],
                      description: likesItem['description'],
                    ),
                  ),
                ),
              );
            },
            leading: CircleAvatar(
              backgroundImage: AssetImage(likesItem['imageUrl'] as String),
              radius: 20,
            ),
            trailing: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        'Delete Product',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      content: const Text('Are you sure you want to remove?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'No',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context
                                .read<LikesProvider>()
                                .removeProduct(likesItem);
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Yes',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
            title: Text(
              '${likesItem['title']}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            subtitle: Text('Version: ${likesItem['version']}'),
          );
        },
      ),
    );
  }
}
