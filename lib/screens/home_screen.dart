
import 'package:flutter/material.dart';
import '../data/flower_data.dart';
import '../models/flower_product.dart';
import '../services/cart_service.dart';
import '../theme/app_theme.dart';
import '../widgets/product_card.dart';
import 'custom_bouquet_screen.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();

  String category = 'All';
  final Set<int> favorites = {};

  final List<String> categories = [
    'All',
    'Bouquets',
    'Fresh Flower',
    'Indoor Plant',
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void openDetail(FlowerProduct product) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, animation, secondaryAnimation) =>
            ProductDetailScreen(product: product),
        transitionsBuilder: (_, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.04, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                ),
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }

  void openCustomBouquet() {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, animation, secondaryAnimation) =>
            const CustomBouquetScreen(),
        transitionsBuilder: (_, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.05),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                ),
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }

  void addToCart(FlowerProduct product) {
    CartService.instance.addProduct(product);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                color: Colors.white,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${product.name} ditambahkan ke keranjang',
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.pinkDark,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
  }

  Widget _fadeSlide({
    required Widget child,
    required int index,
  }) {
    return TweenAnimationBuilder<double>(
      key: ValueKey('home-section-$index'),
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 500 + (index * 100)),
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
      child: child,
    );
  }

  Widget _sectionTitle({
    required String title,
    String? subtitle,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 28, 22, 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                    letterSpacing: -0.6,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 25),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF7E5E9),
            Color(0xFFFFF8F4),
            Color(0xFFF4E4E8),
          ],
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(
                    color: Colors.white,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.pinkDark.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.local_florist_rounded,
                  color: AppColors.pinkDark,
                  size: 27,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'F L O   B U C K E T',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.text,
                        letterSpacing: 1.1,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Flowers made with love',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.muted,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.spa_outlined,
                  size: 21,
                  color: AppColors.roseGold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 27),
          const Text(
            'A little beauty,',
            style: TextStyle(
              fontSize: 29,
              height: 1.15,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
              color: AppColors.text,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'for every moment.',
            style: TextStyle(
              fontSize: 29,
              height: 1.2,
              fontWeight: FontWeight.w800,
              color: AppColors.pinkDark,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Temukan rangkaian bunga spesial untuk orang tersayang.',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.muted,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 22),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: AppColors.pinkDark.withOpacity(0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: TextField(
              controller: searchController,
              onChanged: (_) => setState(() {}),
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Cari bunga impianmu...',
                hintStyle: const TextStyle(
                  color: AppColors.textLight,
                  fontSize: 13,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.pinkDark,
                  size: 23,
                ),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        tooltip: 'Hapus pencarian',
                        onPressed: () {
                          searchController.clear();
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.close_rounded,
                          size: 19,
                        ),
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 17,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(
                    color: AppColors.pink,
                    width: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomBouquetBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.97, end: 1),
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutBack,
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: child,
          );
        },
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: openCustomBouquet,
            child: Ink(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFAD496F),
                    Color(0xFFD77D9C),
                    Color(0xFFE9A5B8),
                  ],
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.pinkDark.withOpacity(0.16),
                    blurRadius: 20,
                    offset: const Offset(0, 9),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -20,
                    top: -35,
                    child: Container(
                      width: 155,
                      height: 155,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.12),
                          width: 28,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 20,
                    bottom: 13,
                    child: Icon(
                      Icons.local_florist_rounded,
                      size: 105,
                      color: Colors.white.withOpacity(0.13),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(22),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.17),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.25),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.auto_awesome,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'MADE JUST FOR YOU',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15),
                              const Text(
                                'Your Flower,',
                                style: TextStyle(
                                  fontSize: 23,
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w400,
                                  height: 1.25,
                                ),
                              ),
                              const Text(
                                'Your Story.',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  height: 1.25,
                                  letterSpacing: -0.6,
                                ),
                              ),
                              const SizedBox(height: 9),
                              Text(
                                'Racik buket spesial sesuai seleramu.',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white.withOpacity(0.9),
                                  height: 1.6,
                                ),
                              ),
                              const SizedBox(height: 18),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 11,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Buat Buket',
                                      style: TextStyle(
                                        color: AppColors.pinkDark,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      color: AppColors.pinkDark,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.card_giftcard_rounded,
                          size: 57,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 45,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 9),
        itemBuilder: (context, index) {
          final item = categories[index];
          final selected = category == item;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              color: selected ? AppColors.pinkDark : Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: selected
                    ? AppColors.pinkDark
                    : AppColors.divider,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: AppColors.pinkDark.withOpacity(0.14),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () {
                  setState(() {
                    category = item;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 17),
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        color: selected ? Colors.white : AppColors.muted,
                        fontSize: 12,
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.w500,
                      ),
                      child: Text(item),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 45, 28, 45),
        child: Center(
          child: Column(
            children: [
              Container(
                width: 85,
                height: 85,
                decoration: const BoxDecoration(
                  color: AppColors.pinkLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.local_florist_outlined,
                  size: 40,
                  color: AppColors.pinkDark,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Belum ada bunga yang cocok',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Coba kata kunci atau kategori lainnya.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 12,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 18),
              OutlinedButton.icon(
                onPressed: () {
                  searchController.clear();
                  setState(() {
                    category = 'All';
                  });
                },
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Lihat Semua Bunga'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = flowerProducts.where((product) {
      final matchesCategory =
          category == 'All' || product.category == category;

      final matchesSearch = product.name
          .toLowerCase()
          .contains(searchController.text.trim().toLowerCase());

      return matchesCategory && matchesSearch;
    }).toList();

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: _fadeSlide(
            index: 0,
            child: _buildHeader(),
          ),
        ),

        SliverToBoxAdapter(
          child: _fadeSlide(
            index: 1,
            child: _sectionTitle(
              title: 'Made with love',
              subtitle: 'Buket personal untuk momen istimewa.',
              trailing: TextButton(
                onPressed: openCustomBouquet,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.pinkDark,
                ),
                child: const Text(
                  'Custom',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: _fadeSlide(
            index: 2,
            child: _buildCustomBouquetBanner(),
          ),
        ),

        SliverToBoxAdapter(
          child: _fadeSlide(
            index: 3,
            child: _sectionTitle(
              title: 'Discover Flowers',
              subtitle: 'Temukan bunga favoritmu hari ini.',
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: _fadeSlide(
            index: 4,
            child: _buildCategories(),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 23, 22, 12),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Pilihan untukmu',
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Text(
                    '${filteredProducts.length} produk',
                    key: ValueKey(filteredProducts.length),
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        if (filteredProducts.isEmpty)
          _buildEmptyState()
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 22),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = filteredProducts[index];

                  return TweenAnimationBuilder<double>(
                    key: ValueKey(
                      '${category}_${searchController.text}_${product.id}',
                    ),
                    tween: Tween<double>(
                      begin: 0,
                      end: 1,
                    ),
                    duration: Duration(
                      milliseconds: 350 + (index.clamp(0, 5) * 90),
                    ),
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
                    child: ProductCard(
                      product: product,
                      isFavorite: favorites.contains(product.id),
                      onTap: () => openDetail(product),
                      onFavorite: () {
                        setState(() {
                          if (!favorites.add(product.id)) {
                            favorites.remove(product.id);
                          }
                        });
                      },
                      onAddToCart: () => addToCart(product),
                    ),
                  );
                },
                childCount: filteredProducts.length,
              ),
              gridDelegate:
                  const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 260,
                mainAxisExtent: 310,
                mainAxisSpacing: 17,
                crossAxisSpacing: 15,
              ),
            ),
          ),

        const SliverToBoxAdapter(
          child: SizedBox(height: 24),
        ),
      ],
    );
  }
}
