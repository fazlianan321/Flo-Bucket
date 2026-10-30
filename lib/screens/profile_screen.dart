
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  final bool isLoggedIn;
  final String customerName;
  final String customerEmail;
  final VoidCallback onLogout;
  final VoidCallback onLoginTap;

  const ProfileScreen({
    super.key,
    this.isLoggedIn = false,
    this.customerName = '',
    this.customerEmail = '',
    this.onLogout = _defaultAction,
    this.onLoginTap = _defaultAction,
  });

  static void _defaultAction() {}

  void _showInformation(
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
                const SizedBox(height: 25),
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
                    fontSize: 13,
                    height: 1.7,
                  ),
                ),
                const SizedBox(height: 24),
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

  void _showAccountInformation(BuildContext context) {
    _showInformation(
      context,
      title: 'Informasi Akun',
      icon: Icons.person_outline_rounded,
      description: isLoggedIn
          ? 'Nama: ${customerName.isEmpty ? 'Pelanggan Flo Bucket' : customerName}\n'
              'Email: ${customerEmail.isEmpty ? 'Belum tersedia' : customerEmail}\n\n'
              'Informasi ini berasal dari sesi login saat ini.'
          : 'Kamu belum login. Masuk ke akunmu untuk melihat informasi profil.',
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text(
            'Keluar dari akun?',
            style: TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: const Text(
            'Kamu perlu login kembali untuk membuka Cart, Orders, dan Profile.',
            style: TextStyle(
              color: AppColors.muted,
              height: 1.5,
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
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      onLogout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayName = customerName.trim().isNotEmpty
        ? customerName.trim()
        : 'Flower Lover';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 22,
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 23,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFF8E3EA),
                  Color(0xFFFFF5EF),
                ],
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 112,
                      height: 112,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.85),
                          width: 3,
                        ),
                      ),
                    ),
                    const CircleAvatar(
                      radius: 49,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 44,
                        backgroundColor: AppColors.pinkLight,
                        child: Icon(
                          Icons.person_rounded,
                          size: 49,
                          color: AppColors.pinkDark,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 3,
                      right: 5,
                      child: Container(
                        width: 31,
                        height: 31,
                        decoration: BoxDecoration(
                          color: isLoggedIn
                              ? AppColors.green
                              : AppColors.roseGold,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                        ),
                        child: Icon(
                          isLoggedIn
                              ? Icons.check_rounded
                              : Icons.person_outline_rounded,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  isLoggedIn ? displayName : 'Flower Lover',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  isLoggedIn
                      ? (customerEmail.isNotEmpty
                          ? customerEmail
                          : 'Pelanggan Flo Bucket')
                      : 'Welcome to Flo Bucket',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 17),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isLoggedIn
                            ? Icons.verified_user_rounded
                            : Icons.favorite_rounded,
                        color: AppColors.pinkDark,
                        size: 14,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        isLoggedIn
                            ? 'Akun pelanggan'
                            : 'Flowers make moments beautiful',
                        style: const TextStyle(
                          color: AppColors.text,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isLoggedIn) ...[
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: FilledButton(
                      onPressed: onLoginTap,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.pinkDark,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Masuk ke Akun',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 27),

          const Text(
            'Akun Saya',
            style: TextStyle(
              color: AppColors.text,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Kelola informasi dan preferensimu.',
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 15),

          _ProfileMenuCard(
            children: [
              _ProfileMenuItem(
                icon: Icons.person_outline_rounded,
                title: 'Informasi Akun',
                subtitle: isLoggedIn
                    ? 'Lihat nama dan email akunmu'
                    : 'Login untuk melihat informasi akun',
                onTap: () => _showAccountInformation(context),
              ),
              _ProfileMenuItem(
                icon: Icons.location_on_outlined,
                title: 'Alamat Saya',
                subtitle: 'Kelola alamat pengiriman',
                onTap: () => _showInformation(
                  context,
                  title: 'Alamat Saya',
                  description:
                      'Fitur untuk menambah, mengubah, dan memilih '
                      'alamat pengiriman akan dihubungkan pada tahap berikutnya.',
                  icon: Icons.location_on_outlined,
                ),
              ),
              _ProfileMenuItem(
                icon: Icons.notifications_none_rounded,
                title: 'Notifikasi',
                subtitle: 'Informasi dan pembaruan',
                onTap: () => _showInformation(
                  context,
                  title: 'Notifikasi',
                  description:
                      'Notifikasi pesanan dan promosi belum terhubung.',
                  icon: Icons.notifications_none_rounded,
                ),
                showDivider: false,
              ),
            ],
          ),

          const SizedBox(height: 25),

          const Text(
            'Bantuan & Informasi',
            style: TextStyle(
              color: AppColors.text,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 15),

          _ProfileMenuCard(
            children: [
              _ProfileMenuItem(
                icon: Icons.help_outline_rounded,
                title: 'Bantuan',
                subtitle: 'Pertanyaan dan dukungan',
                onTap: () => _showInformation(
                  context,
                  title: 'Pusat Bantuan',
                  description:
                      'Panduan berbelanja, informasi pemesanan, dan '
                      'kontak layanan pelanggan akan tersedia setelah fitur bantuan dibuat.',
                  icon: Icons.help_outline_rounded,
                ),
              ),
              _ProfileMenuItem(
                icon: Icons.info_outline_rounded,
                title: 'Tentang Flo Bucket',
                subtitle: 'Kenali aplikasi kami',
                showDivider: false,
                onTap: () => _showInformation(
                  context,
                  title: 'Tentang Flo Bucket',
                  description:
                      'Flo Bucket adalah aplikasi toko bunga yang '
                      'dirancang untuk membantu pengguna menemukan '
                      'bunga dan merencanakan buket untuk momen spesial.',
                  icon: Icons.local_florist_rounded,
                ),
              ),
            ],
          ),

          if (isLoggedIn) ...[
            const SizedBox(height: 25),
            SizedBox(
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () => _confirmLogout(context),
                icon: const Icon(Icons.logout_rounded, size: 19),
                label: const Text(
                  'Keluar dari Akun',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: BorderSide(
                    color: AppColors.error.withValues(alpha: 0.35),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ],

          const SizedBox(height: 25),

          Center(
            child: Column(
              children: [
                const Icon(
                  Icons.local_florist_rounded,
                  color: AppColors.roseGold,
                  size: 22,
                ),
                const SizedBox(height: 7),
                const Text(
                  'FLO BUCKET',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Made with love, for every moment.',
                  style: TextStyle(
                    color: AppColors.muted.withValues(alpha: 0.9),
                    fontSize: 10,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuCard extends StatelessWidget {
  final List<Widget> children;

  const _ProfileMenuCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: AppColors.text.withValues(alpha: 0.025),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool showDivider;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        splashColor: AppColors.pinkLight.withValues(alpha: 0.5),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              child: Row(
                children: [
                  Container(
                    width: 43,
                    height: 43,
                    decoration: BoxDecoration(
                      color: AppColors.pinkLight.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      icon,
                      color: AppColors.pinkDark,
                      size: 21,
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: AppColors.text,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textLight,
                    size: 22,
                  ),
                ],
              ),
            ),
            if (showDivider)
              const Padding(
                padding: EdgeInsets.only(left: 70),
                child: Divider(
                  height: 1,
                  thickness: 0.7,
                  color: AppColors.divider,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
