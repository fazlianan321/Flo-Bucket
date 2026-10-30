
import 'package:flutter/material.dart';

import '../models/flower_product.dart';
import '../theme/app_theme.dart';
import '../utils/currency_formatter.dart';

class ProductCard extends StatefulWidget {
  final FlowerProduct product;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavorite;
  final VoidCallback onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onTap,
    required this.onFavorite,
    required this.onAddToCart,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isPressed = false;
  bool _isAdding = false;

  Future<void> _addToCart() async {
    if (_isAdding) return;

    setState(() => _isAdding = true);

    try {
      widget.onAddToCart();
    } finally {
      if (mounted) {
        Future.delayed(const Duration(milliseconds: 450), () {
          if (mounted) {
            setState(() => _isAdding = false);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return AnimatedScale(
      scale: _isPressed ? 0.975 : 1,
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: AppColors.divider,
            width: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.pinkDark.withValues(alpha: 0.055),
              blurRadius: 18,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(22),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: widget.onTap,
            onHighlightChanged: (pressed) {
              setState(() => _isPressed = pressed);
            },
            splashColor: AppColors.pinkLight.withValues(alpha: 0.55),
            highlightColor: AppColors.pinkLight.withValues(alpha: 0.2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 6,
                  child: Stack(
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
                              child: SizedBox(
                                width: 25,
                                height: 25,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.pinkDark,
                                  value: progress.expectedTotalBytes != null
                                      ? progress.cumulativeBytesLoaded /
                                          progress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppColors.ivory,
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.local_florist_rounded,
                                    size: 42,
                                    color: AppColors.pink.withValues(
                                      alpha: 0.7,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Flo Bucket',
                                    style: TextStyle(
                                      color: AppColors.muted,
                                      fontSize: 10,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      // Soft gradient at the bottom of the image.
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        height: 58,
                        child: IgnorePointer(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.22),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Product category.
                      Positioned(
                        left: 10,
                        bottom: 10,
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 130),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.94),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            product.category,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.pinkDark,
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),

                      // Animated favorite button.
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Material(
                          color: Colors.white.withValues(alpha: 0.96),
                          shape: const CircleBorder(),
                          elevation: 2,
                          shadowColor: AppColors.text.withValues(alpha: 0.08),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: widget.onFavorite,
                            child: Padding(
                              padding: const EdgeInsets.all(9),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 220),
                                transitionBuilder: (child, animation) {
                                  return ScaleTransition(
                                    scale: animation,
                                    child: child,
                                  );
                                },
                                child: Icon(
                                  widget.isFavorite
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  key: ValueKey(widget.isFavorite),
                                  size: 19,
                                  color: widget.isFavorite
                                      ? AppColors.pinkDark
                                      : AppColors.text,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Product information.
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.text,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            height: 1.25,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Color(0xFFE4AD54),
                              size: 16,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              product.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                color: AppColors.text,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Container(
                              width: 3,
                              height: 3,
                              decoration: const BoxDecoration(
                                color: AppColors.textLight,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Expanded(
                              child: Text(
                                'Pilihan favorit',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.muted,
                                  fontSize: 9,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),

                        Text(
                          'HARGA',
                          style: TextStyle(
                            color: AppColors.muted.withValues(alpha: 0.9),
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.1,
                          ),
                        ),

                        const SizedBox(height: 2),

                        Text(
                          formatRupiah(product.price),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.pinkDark,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                        ),

                        const SizedBox(height: 9),

                        SizedBox(
                          width: double.infinity,
                          height: 35,
                          child: FilledButton(
                            onPressed: _isAdding ? null : _addToCart,
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.pinkDark,
                              disabledBackgroundColor: AppColors.green,
                              foregroundColor: Colors.white,
                              disabledForegroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 180),
                              child: _isAdding
                                  ? const Row(
                                      key: ValueKey('added'),
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.check_circle_rounded,
                                          size: 15,
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          'Ditambahkan',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    )
                                  : const Row(
                                      key: ValueKey('add'),
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.shopping_bag_outlined,
                                          size: 15,
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          'Tambah ke Keranjang',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
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
      ),
    );
  }
}
