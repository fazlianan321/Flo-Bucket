
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

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
              'My Orders',
              style: TextStyle(
                color: AppColors.text,
                fontSize: 23,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: 3),
            Text(
              'Setiap pesanan, cerita yang istimewa',
              style: TextStyle(
                color: AppColors.muted,
                fontSize: 10,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Premium introductory banner.
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFF8E3EA),
                      Color(0xFFFFF5EE),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(23),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'A little love,',
                            style: TextStyle(
                              color: AppColors.roseGold,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'on its way to you.',
                            style: TextStyle(
                              color: AppColors.text,
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 9),
                          Text(
                            'Pantau perjalanan bunga spesialmu '
                            'di halaman pesanan.',
                            style: TextStyle(
                              color: AppColors.text.withValues(alpha: 0.72),
                              fontSize: 11,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 74,
                      height: 88,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.local_florist_rounded,
                        size: 43,
                        color: AppColors.pinkDark,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                'Riwayat Pesanan',
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Semua pesananmu akan ditampilkan di sini.',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 22),

              // Empty state with entrance animation.
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 650),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 22 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(22, 30, 22, 28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppColors.divider,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.text.withValues(alpha: 0.025),
                        blurRadius: 20,
                        offset: const Offset(0, 7),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 144,
                            height: 144,
                            decoration: BoxDecoration(
                              color: AppColors.pinkLight.withValues(
                                alpha: 0.65,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            width: 108,
                            height: 108,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const Icon(
                            Icons.receipt_long_rounded,
                            size: 52,
                            color: AppColors.pinkDark,
                          ),
                          Positioned(
                            top: 17,
                            right: 10,
                            child: Container(
                              width: 31,
                              height: 31,
                              decoration: const BoxDecoration(
                                color: AppColors.green,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.favorite_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 15,
                            left: 8,
                            child: Container(
                              width: 27,
                              height: 27,
                              decoration: const BoxDecoration(
                                color: AppColors.roseGold,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.spa_rounded,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      const Text(
                        'Belum Ada Pesanan',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.text,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        'Belum ada bunga yang kamu pesan. '
                        'Temukan buket cantik untuk orang tersayang '
                        'dan momen yang ingin kamu rayakan.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 12,
                          height: 1.8,
                        ),
                      ),

                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        height: 49,
                        child: FilledButton.icon(
                          onPressed: () {
                            // Kembali jika halaman ini dibuka melalui route.
                            Navigator.maybePop(context);
                          },
                          icon: const Icon(
                            Icons.local_florist_rounded,
                            size: 18,
                          ),
                          label: const Text('Mulai Berbelanja'),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.pinkDark,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 26),

              // Informational order stages, not actual order statuses.
              const Text(
                'Bagaimana Pesanan Diproses?',
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 15),

              const _OrderStep(
                number: '01',
                icon: Icons.shopping_bag_outlined,
                title: 'Pilih bunga favorit',
                description:
                    'Temukan bunga atau buket yang sesuai dengan momenmu.',
              ),

              const _OrderStep(
                number: '02',
                icon: Icons.receipt_long_outlined,
                title: 'Konfirmasi pesanan',
                description:
                    'Periksa produk dan detail pesanan sebelum melanjutkan.',
              ),

              const _OrderStep(
                number: '03',
                icon: Icons.local_shipping_outlined,
                title: 'Bunga siap dikirim',
                description:
                    'Informasi pesanan dan pengiriman dapat dilihat setelah '
                    'alur pemesanan terhubung.',
                isLast: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderStep extends StatelessWidget {
  final String number;
  final IconData icon;
  final String title;
  final String description;
  final bool isLast;

  const _OrderStep({
    required this.number,
    required this.icon,
    required this.title,
    required this.description,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: AppColors.pinkLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: AppColors.pinkDark,
                  size: 21,
                ),
              ),
              if (!isLast)
                Container(
                  width: 1,
                  height: 30,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  color: AppColors.divider,
                ),
            ],
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LANGKAH $number',
                    style: const TextStyle(
                      color: AppColors.roseGold,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.text,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 11,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
