
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/currency_formatter.dart';

class AdminDashboardScreen extends StatelessWidget {
  final VoidCallback onLogout;

  const AdminDashboardScreen({
    super.key,
    required this.onLogout,
  });

  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.logout_rounded,
                color: AppColors.pinkDark,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Keluar dari Admin?',
                  style: TextStyle(
                    color: AppColors.text,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          content: const Text(
            'Kamu akan kembali ke halaman utama Flo Bucket.',
            style: TextStyle(
              color: AppColors.muted,
              height: 1.6,
              fontSize: 13,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text(
                'Batal',
                style: TextStyle(color: AppColors.muted),
              ),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.pinkDark,
                foregroundColor: Colors.white,
              ),
              child: const Text('Ya, Keluar'),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      onLogout();
    }
  }

  void _showMenuInformation(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
  }) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 28),
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: AppColors.pinkLight,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Icon(
                    icon,
                    size: 32,
                    color: AppColors.pinkDark,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 12,
                    height: 1.7,
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(sheetContext),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.pinkDark,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('Mengerti'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 20,
        title: const Row(
          children: [
            Icon(
              Icons.local_florist_rounded,
              color: AppColors.pinkDark,
              size: 27,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Flo Bucket',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.4,
                  ),
                ),
                Text(
                  'ADMINISTRATION',
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: 8,
                    letterSpacing: 1.8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              tooltip: 'Keluar',
              onPressed: () => _confirmLogout(context),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.pinkLight.withValues(
                  alpha: 0.65,
                ),
                foregroundColor: AppColors.pinkDark,
              ),
              icon: const Icon(Icons.logout_rounded, size: 20),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final wide = width >= 1000;
          final medium = width >= 650;

          final horizontalPadding = wide
              ? 36.0
              : medium
                  ? 26.0
                  : 18.0;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              28,
              horizontalPadding,
              32,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1280),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPageHeading(),
                    const SizedBox(height: 24),
                    _buildWelcomeBanner(wide: wide),
                    const SizedBox(height: 30),
                    _buildSectionHeading(
                      title: 'Ringkasan Bisnis',
                      subtitle: 'Gambaran umum aktivitas toko.',
                      icon: Icons.insights_rounded,
                    ),
                    const SizedBox(height: 16),
                    _buildStatsGrid(
                      crossAxisCount: wide ? 4 : medium ? 2 : 2,
                      compact: !medium,
                    ),
                    const SizedBox(height: 32),
                    _buildSectionHeading(
                      title: 'Manajemen Toko',
                      subtitle: 'Akses cepat ke pengelolaan toko.',
                      icon: Icons.grid_view_rounded,
                    ),
                    const SizedBox(height: 16),
                    _buildManagementGrid(
                      context,
                      crossAxisCount: wide ? 3 : medium ? 2 : 2,
                    ),
                    const SizedBox(height: 28),
                    _buildDemoNotice(),
                    const SizedBox(height: 24),
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPageHeading() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dashboard Admin',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 29,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ),
        SizedBox(height: 7),
        Text(
          'Kelola toko bunga dan pantau aktivitas Flo Bucket.',
          style: TextStyle(
            color: AppColors.muted,
            fontSize: 12,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeBanner({required bool wide}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(wide ? 30 : 23),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFAD496F),
            Color(0xFFD96C91),
            Color(0xFFE99CB5),
          ],
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: AppColors.pinkDark.withValues(alpha: 0.17),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -14,
            top: -25,
            child: Icon(
              Icons.local_florist_rounded,
              size: wide ? 170 : 125,
              color: Colors.white.withValues(alpha: 0.10),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.20),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.waving_hand_rounded,
                            size: 14,
                            color: Colors.white,
                          ),
                          SizedBox(width: 7),
                          Text(
                            'ADMIN WORKSPACE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              letterSpacing: 1.1,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 17),
                    Text(
                      'Welcome back,\nAdmin!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: wide ? 31 : 25,
                        height: 1.15,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.7,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Saatnya membuat pengalaman belanja bunga '
                      'menjadi lebih istimewa.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        height: 1.7,
                      ),
                    ),
                  ],
                ),
              ),
              if (wide) ...[
                const SizedBox(width: 20),
                Container(
                  width: 112,
                  height: 112,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.25),
                      width: 1.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.spa_rounded,
                    color: Colors.white,
                    size: 61,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeading({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Row(
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
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid({
    required int crossAxisCount,
    required bool compact,
  }) {
    final stats = [
      _StatData(
        title: 'Total Penjualan',
        value: formatRupiah(12500000),
        icon: Icons.payments_outlined,
        note: 'Data contoh',
        iconColor: AppColors.green,
      ),
      _StatData(
        title: 'Pesanan',
        value: '48',
        icon: Icons.shopping_bag_outlined,
        note: 'Data contoh',
        iconColor: AppColors.pinkDark,
      ),
      _StatData(
        title: 'Produk',
        value: '26',
        icon: Icons.local_florist_outlined,
        note: 'Data contoh',
        iconColor: AppColors.roseGold,
      ),
      _StatData(
        title: 'Pelanggan',
        value: '120',
        icon: Icons.people_outline_rounded,
        note: 'Data contoh',
        iconColor: const Color(0xFF7D82B5),
      ),
    ];

    return GridView.builder(
      itemCount: stats.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 13,
        mainAxisSpacing: 13,
        mainAxisExtent: compact ? 155 : 165,
      ),
      itemBuilder: (context, index) {
        return _StatCard(data: stats[index]);
      },
    );
  }

  Widget _buildManagementGrid(
    BuildContext context, {
    required int crossAxisCount,
  }) {
    final menus = [
      _ManagementData(
        title: 'Produk',
        subtitle: 'Kelola katalog bunga',
        icon: Icons.inventory_2_outlined,
        description:
            'Menu ini nantinya digunakan untuk menambah, mengubah, '
            'menghapus, dan mengatur informasi produk bunga. '
            'Fitur belum terhubung dengan database.',
      ),
      _ManagementData(
        title: 'Pesanan',
        subtitle: 'Pantau pesanan pelanggan',
        icon: Icons.receipt_long_outlined,
        description:
            'Menu ini nantinya menampilkan daftar pesanan dan status '
            'pemesanan pelanggan. Data pesanan nyata belum tersedia.',
      ),
      _ManagementData(
        title: 'Kategori',
        subtitle: 'Atur kategori produk',
        icon: Icons.category_outlined,
        description:
            'Menu untuk mengatur kategori bunga dan jenis produk. '
            'Pengelolaan kategori belum terhubung ke penyimpanan data.',
      ),
      _ManagementData(
        title: 'Promosi',
        subtitle: 'Kelola diskon dan promo',
        icon: Icons.local_offer_outlined,
        description:
            'Menu ini direncanakan untuk mengatur promosi dan diskon '
            'produk. Fitur promosi belum diimplementasikan.',
      ),
      _ManagementData(
        title: 'Pengguna',
        subtitle: 'Lihat akun pengguna',
        icon: Icons.people_alt_outlined,
        description:
            'Menu ini nantinya digunakan untuk melihat dan mengelola '
            'data pengguna. Daftar pengguna nyata belum tersedia.',
      ),
      _ManagementData(
        title: 'Laporan',
        subtitle: 'Ringkasan aktivitas bisnis',
        icon: Icons.bar_chart_rounded,
        description:
            'Menu laporan direncanakan untuk merangkum penjualan, '
            'pesanan, dan aktivitas bisnis. Angka yang ada saat ini '
            'masih merupakan data demo.',
      ),
    ];

    return GridView.builder(
      itemCount: menus.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 13,
        mainAxisSpacing: 13,
        mainAxisExtent: 157,
      ),
      itemBuilder: (context, index) {
        final item = menus[index];

        return _ManagementCard(
          data: item,
          onTap: () => _showMenuInformation(
            context,
            title: item.title,
            description: item.description,
            icon: item.icon,
          ),
        );
      },
    );
  }

  Widget _buildDemoNotice() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4E8),
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: const Color(0xFFF0D9BC),
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: Color(0xFFAD7846),
            size: 22,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mode Demo',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Statistik pada dashboard ini adalah data contoh. '
                  'Pengelolaan data nyata membutuhkan database, '
                  'backend, dan autentikasi yang aman.',
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: 11,
                    height: 1.7,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Column(
        children: [
          const Icon(
            Icons.local_florist_rounded,
            color: AppColors.roseGold,
            size: 23,
          ),
          const SizedBox(height: 7),
          const Text(
            'FLO BUCKET',
            style: TextStyle(
              color: AppColors.text,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Admin workspace · Made with love',
            style: TextStyle(
              color: AppColors.muted.withValues(alpha: 0.9),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatData {
  final String title;
  final String value;
  final IconData icon;
  final String note;
  final Color iconColor;

  const _StatData({
    required this.title,
    required this.value,
    required this.icon,
    required this.note,
    required this.iconColor,
  });
}

class _StatCard extends StatelessWidget {
  final _StatData data;

  const _StatCard({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: AppColors.text.withValues(alpha: 0.025),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 39,
                height: 39,
                decoration: BoxDecoration(
                  color: data.iconColor.withValues(alpha: 0.11),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  data.icon,
                  color: data.iconColor,
                  size: 21,
                ),
              ),
              const Icon(
                Icons.more_horiz_rounded,
                color: AppColors.textLight,
                size: 20,
              ),
            ],
          ),
          const Spacer(),
          Text(
            data.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 19,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            data.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: data.iconColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                data.note,
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ManagementData {
  final String title;
  final String subtitle;
  final IconData icon;
  final String description;

  const _ManagementData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.description,
  });
}

class _ManagementCard extends StatelessWidget {
  final _ManagementData data;
  final VoidCallback onTap;

  const _ManagementCard({
    required this.data,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(21),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(21),
        child: Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(21),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    width: 43,
                    height: 43,
                    decoration: BoxDecoration(
                      color: AppColors.pinkLight,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      data.icon,
                      color: AppColors.pinkDark,
                      size: 22,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_outward_rounded,
                    color: AppColors.textLight,
                    size: 18,
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                data.title,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                data.subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 10,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
