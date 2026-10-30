
import 'package:flutter/material.dart';
import '../data/flower_data.dart';
import '../services/cart_service.dart';
import '../theme/app_theme.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';
import '../models/flower_product.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String query = '';

  void addToCart(FlowerProduct product) {
    CartService.instance.addProduct(product);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${product.name} berhasil ditambahkan ke keranjang',
        ),
        backgroundColor: AppColors.pinkDark,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = flowerProducts
        .where(
          (product) =>
              product.name.toLowerCase().contains(query.toLowerCase()) ||
              product.category.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Explore Flowers',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      query = value;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Cari bunga...',
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppColors.pink,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (filtered.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.local_florist_outlined,
                      size: 60,
                      color: AppColors.pink,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Bunga tidak ditemukan',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Coba gunakan nama atau kategori bunga lain.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.muted),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = filtered[index];

                  return ProductCard(
                    product: product,
                    isFavorite: false,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ProductDetailScreen(product: product),
                        ),
                      );
                    },
                    onFavorite: () {},
                    onAddToCart: () {
                      addToCart(product);
                    },
                  );
                },
                childCount: filtered.length,
              ),
              gridDelegate:
                  const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 240,
                mainAxisExtent: 310,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
              ),
            ),
          ),
      ],
    );
  }
}
