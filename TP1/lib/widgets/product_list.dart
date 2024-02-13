import 'package:flutter/material.dart';
import 'package:media_app/classes/product_class.dart';
import 'package:media_app/widgets/product_card.dart';
import 'package:media_app/pages/product_details_page.dart';

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}


class _ProductListState extends State<ProductList> {
  final List<String> filters = const [
    'All',
    'Strategy',
    'Family',
    'Party',
    'Cooperative',
    'Abstract',
  ];
  late String selectedFilter;
  late List<Product> filteredProducts;
  late TextEditingController _searchController;


  @override
  void initState() {
    super.initState();
    selectedFilter = filters[0];
    filteredProducts = products;
    _searchController = TextEditingController();

  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void filterProducts(String category, String searchText) {
    setState(() {
      selectedFilter = category;
      if (category == 'All') {
        filteredProducts = products; // Affichez tous les produits si "Tous" est sélectionné
      } else {
        filteredProducts = products.where((product) => product.category == category).toList();
      }

      if (searchText.isNotEmpty) {
        filteredProducts = filteredProducts.where((product) =>
          product.title.toLowerCase().contains(searchText.toLowerCase())
        ).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
    borderSide: BorderSide(
      color: Color.fromRGBO(225, 225, 225, 1),
    ),
    borderRadius: BorderRadius.horizontal(
      left: Radius.circular(50),
    ),
  );

  return SafeArea(
    child: Column(
      children: [
        Container(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 5, 0),
                child: Text(
                  'Jeu\nJoue',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    filterProducts(selectedFilter, value);
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search),
                    border: border,
                    enabledBorder: border,
                    focusedBorder: border,
                  ),
                ),
              ),
              ],
            ),
          ),
          SizedBox(
            height: 60,
            child: ListView.builder(
              itemCount: filters.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final filter = filters[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 3.0,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFilter = filter;
                      });
                      filterProducts(selectedFilter, _searchController.text);

                    },
                    child: Chip(
                      backgroundColor: selectedFilter == filter
                          ? Theme.of(context).colorScheme.primary
                          : const Color.fromRGBO(245, 247, 249, 1),
                      side: const BorderSide(
                        color: Color.fromRGBO(245, 247, 249, 1),
                      ),
                      label: Text(filter),
                      labelStyle: const TextStyle(fontSize: 16),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 1000) {
                  return GridView.builder(
                    itemCount: filteredProducts.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.6,
                    ),
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return ProductDetailsPage(
                                  product: product,
                                );
                              },
                            ),
                          );
                        },
                        child: ProductCard(
                          title: product.title,
                          category: product.category,
                          players: product.players,
                          duration: product.duration,
                          image: product.imageUrl,
                          description: product.description,
                          backgroundColor: index.isEven
                              ? const Color.fromRGBO(216, 240, 253, 1)
                              : const Color.fromRGBO(245, 247, 249, 1),
                        ),
                      );
                    },
                  );
                } else {
                  return ListView.builder(
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return ProductDetailsPage(
                                  product: product,
                                );
                              },
                            ),
                          );
                        },
                        child: ProductCard(
                          title: product.title,
                          category: product.category,
                          players: product.players,
                          duration: product.duration,
                          image: product.imageUrl,
                          description: product.description,
                          backgroundColor: index.isEven
                              ? const Color.fromRGBO(216, 240, 253, 1)
                              : const Color.fromRGBO(245, 247, 249, 1),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
