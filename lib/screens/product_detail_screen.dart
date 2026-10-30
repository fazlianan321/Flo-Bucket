
import 'package:flutter/material.dart';

import '../models/flower_product.dart';
import '../services/cart_service.dart';
import '../theme/app_theme.dart';
import '../utils/currency_formatter.dart';
import 'custom_bouquet_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final FlowerProduct product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _isAdding = false;

  FlowerProduct get product => widget.product;

  void _addToCart() {
    if (_isAdding) return;

    setState(() => _isAdding = true);

    CartService.instance.addProduct(product);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '${product.name} berhasil ditambahkan ke keranjang',
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.green,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          duration: const Duration(seconds: 2),
        ),
      );

    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        setState(() => _isAdding = false);
      }
    });
  }

  void _openCustomBouquet() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CustomBouquetScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 390,
            pinned: true,
            stretch: true,
            backgroundColor: AppColors.background,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(7),
              child: Material(
                color: Colors.white.withValues(alpha: 0.94),
                shape: const CircleBorder(),
                child: IconButton(
                  tooltip: 'Kembali',
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: AppColors.text,
                    size: 20,
                  ),
                  onPressed: () => Navigator.maybePop(context),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(7),
                child: Material(
                  color: Colors.white.withValues(alpha: 0.94),
                  shape: const CircleBorder(),
                  child: IconButton(
                    tooltip: 'Bagikan produk',
                    icon: const Icon(
                      Icons.ios_share_rounded,
                      color: AppColors.text,
                      size: 19,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Fitur berbagi produk belum tersedia.',
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                    },
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.fadeTitle,
              ],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'flower-image-${product.id}',
                    child: Image.network(
                      product.image,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;

                        return Container(
                          color: AppColors.ivory,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.pinkDark,
                            value: progress.expectedTotalBytes != null
                                ? progress.cumulativeBytesLoaded /
                                    progress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.ivory,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.local_florist_rounded,
                            size: 76,
                            color: AppColors.pink,
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 125,
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.35),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 22,
                    bottom: 22,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.94),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.spa_rounded,
                            size: 15,
                            color: AppColors.pinkDark,
                          ),
                          const SizedBox(width: 7),
                          Text(
                            product.category,
                            style: const TextStyle(
                              color: AppColors.pinkDark,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 25, 22, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 18 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 2,
                              decoration: BoxDecoration(
                                color: AppColors.roseGold,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            const SizedBox(width: 9),
                            const Text(
                              'FLOWERS, WITH LOVE',
                              style: TextStyle(
                                color: AppColors.roseGold,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          product.name,
                          style: const TextStyle(
                            color: AppColors.text,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                            letterSpacing: -0.7,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF2D9),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    size: 17,
                                    color: Color(0xFFD89B32),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    product.rating.toStringAsFixed(1),
                                    style: const TextStyle(
                                      color: AppColors.text,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Icon(
                              Icons.verified_outlined,
                              size: 17,
                              color: AppColors.green,
                            ),
                            const SizedBox(width: 5),
                            const Expanded(
                              child: Text(
                                'Pilihan bunga Flo Bucket',
                                style: TextStyle(
                                  color: AppColors.muted,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 23),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: AppColors.divider,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'HARGA PRODUK',
                                style: TextStyle(
                                  color: AppColors.muted,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.3,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                formatRupiah(product.price),
                                style: const TextStyle(
                                  color: AppColors.pinkDark,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 29),
                        const Text(
                          'Tentang Bunga Ini',
                          style: TextStyle(
                            color: AppColors.text,
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          product.description,
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 13,
                            height: 1.8,
                          ),
                        ),
                        const SizedBox(height: 25),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.pinkLight.withValues(
                              alpha: 0.48,
                            ),
                            borderRadius: BorderRadius.circular(17),
                          ),
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.local_shipping_outlined,
                                color: AppColors.pinkDark,
                                size: 25,
                              ),
                              SizedBox(width: 13),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Dikemas dengan penuh perhatian',
                                      style: TextStyle(
                                        color: AppColors.text,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Bunga dikemas dengan hati-hati agar '
                                      'tampil cantik saat diterima.',
                                      style: TextStyle(
                                        color: AppColors.muted,
                                        fontSize: 11,
                                        height: 1.6,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        const Text(
                          'Jadikan Momen Lebih Spesial',
                          style: TextStyle(
                            color: AppColors.text,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Bunga yang tepat untuk menyampaikan perasaan.',
                          style: TextStyle(
                            color: AppColors.muted,
                            fontSize: 12,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _openCustomBouquet,
                            icon: const Icon(Icons.auto_awesome_rounded),
                            label: const Text('Buat Buket Custom'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.pinkDark,
                              minimumSize: const Size.fromHeight(50),
                              side: const BorderSide(
                                color: AppColors.pink,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // Fixed purchase button.
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(18, 10, 18, 12),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.divider),
            boxShadow: [
              BoxShadow(
                color: AppColors.text.withValues(alpha: 0.06),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total harga',
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        formatRupiah(product.price),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.pinkDark,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 48,
                  child: FilledButton(
                    onPressed: _isAdding ? null : _addToCart,
                    style: FilledButton.styleFrom(
                      backgroundColor: _isAdding
                          ? AppColors.green
                          : AppColors.pinkDark,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: AppColors.green,
                      disabledForegroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      child: _isAdding
                          ? const Row(
                              key: ValueKey('added'),
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle_rounded, size: 18),
                                SizedBox(width: 7),
                                Flexible(
                                  child: Text(
                                    'Ditambahkan',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const Row(
                              key: ValueKey('add'),
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.shopping_bag_outlined,
                                  size: 18,
                                ),
                                SizedBox(width: 7),
                                Flexible(
                                  child: Text(
                                    'Tambah ke Keranjang',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
