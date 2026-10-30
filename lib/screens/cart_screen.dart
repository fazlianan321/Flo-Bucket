
import 'package:flutter/material.dart';

import '../services/cart_service.dart';
import '../theme/app_theme.dart';
import '../utils/currency_formatter.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  Future<void> _confirmRemove(
    BuildContext context,
    CartService cart,
    int productId,
    String productName,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          icon: const Icon(
            Icons.delete_outline_rounded,
            size: 34,
            color: AppColors.pinkDark,
          ),
          title: const Text(
            'Hapus produk?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'Apakah kamu yakin ingin menghapus "$productName" '
            'dari keranjang?',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.muted,
              height: 1.5,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.pinkDark,
              ),
              child: const Text('Ya, hapus'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      cart.removeProduct(productId);

      if (context.mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text('$productName dihapus dari keranjang.'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppColors.text,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 22,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Cart',
              style: TextStyle(
                color: AppColors.text,
                fontSize: 23,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Bunga pilihanmu, siap dikirim dengan cinta',
              style: TextStyle(
                color: AppColors.muted,
                fontSize: 10,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: AnimatedBuilder(
        animation: CartService.instance,
        builder: (context, _) {
          final cart = CartService.instance;
          final items = cart.items;

          if (items.isEmpty) {
            return _EmptyCart(
              onExplore: () {
                // Kembali ke halaman sebelumnya jika tersedia.
                Navigator.maybePop(context);
              },
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFF8E3EA),
                            Color(0xFFFFF4F0),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.favorite_rounded,
                              color: AppColors.pinkDark,
                            ),
                          ),
                          const SizedBox(width: 13),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Pilihan penuh makna',
                                  style: TextStyle(
                                    color: AppColors.text,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${cart.itemCount} bunga dalam keranjangmu',
                                  style: const TextStyle(
                                    color: AppColors.muted,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.spa_rounded,
                            color: AppColors.roseGold,
                            size: 23,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 23),
                    const Text(
                      'Produk Pilihanmu',
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Periksa kembali pesanan sebelum checkout.',
                      style: TextStyle(
                        color: AppColors.muted,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 15),

                    ...items.map((item) {
                      final product = item.product;

                      return Padding(
                        key: ValueKey(product.id),
                        padding: const EdgeInsets.only(bottom: 13),
                        child: _CartProductCard(
                          image: product.image,
                          name: product.name,
                          category: product.category,
                          price: product.price,
                          quantity: item.quantity,
                          onDecrease: () {
                            cart.decreaseQuantity(product.id);
                          },
                          onIncrease: () {
                            cart.increaseQuantity(product.id);
                          },
                          onRemove: () {
                            _confirmRemove(
                              context,
                              cart,
                              product.id,
                              product.name,
                            );
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),

              _CartSummary(
                itemCount: cart.itemCount,
                totalPrice: cart.totalPrice,
                onCheckout: () {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Keranjang siap. Checkout akan dihubungkan '
                          'ke login dan pemesanan.',
                        ),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  final VoidCallback onExplore;

  const _EmptyCart({
    required this.onExplore,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: AppColors.pinkLight.withValues(alpha: 0.65),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.shopping_bag_outlined,
                  size: 65,
                  color: AppColors.pinkDark,
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Keranjangmu Masih Kosong',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.text,
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Ada banyak bunga cantik yang menunggu untuk '
              'menjadi bagian dari momen spesialmu.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.muted,
                fontSize: 13,
                height: 1.7,
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: 220,
              height: 49,
              child: FilledButton.icon(
                onPressed: onExplore,
                icon: const Icon(Icons.local_florist_rounded, size: 19),
                label: const Text('Jelajahi Bunga'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.pinkDark,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartProductCard extends StatelessWidget {
  final String image;
  final String name;
  final String category;
  final int price;
  final int quantity;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final VoidCallback onRemove;

  const _CartProductCard({
    required this.image,
    required this.name,
    required this.category,
    required this.price,
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: AppColors.text.withValues(alpha: 0.025),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              image,
              width: 88,
              height: 104,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 88,
                  height: 104,
                  color: AppColors.ivory,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.local_florist_rounded,
                    color: AppColors.pink,
                    size: 34,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.roseGold,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  formatRupiah(price),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.pinkDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _QuantityButton(
                      icon: Icons.remove_rounded,
                      onPressed: onDecrease,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child: Text(
                          '$quantity',
                          key: ValueKey(quantity),
                          style: const TextStyle(
                            color: AppColors.text,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    _QuantityButton(
                      icon: Icons.add_rounded,
                      onPressed: onIncrease,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 3),
          IconButton(
            tooltip: 'Hapus produk',
            onPressed: onRemove,
            visualDensity: VisualDensity.compact,
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: AppColors.muted,
              size: 21,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _QuantityButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.pinkLight.withValues(alpha: 0.8),
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(9),
        child: SizedBox(
          width: 29,
          height: 29,
          child: Icon(
            icon,
            color: AppColors.pinkDark,
            size: 16,
          ),
        ),
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  final int itemCount;
  final int totalPrice;
  final VoidCallback onCheckout;

  const _CartSummary({
    required this.itemCount,
    required this.totalPrice,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.text.withValues(alpha: 0.055),
            blurRadius: 18,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Total Belanja',
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    formatRupiah(totalPrice),
                    key: ValueKey(totalPrice),
                    style: const TextStyle(
                      color: AppColors.pinkDark,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '$itemCount item dalam keranjang',
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 10,
                ),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: onCheckout,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.pinkDark,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_outline_rounded, size: 18),
                    SizedBox(width: 9),
                    Text(
                      'Lanjutkan Checkout',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, size: 17),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
