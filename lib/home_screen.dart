import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════════
//  CONSTANTS — single source of truth for theming
// ═══════════════════════════════════════════════════════════════
class AppColors {
  static const primary = Color(0xFF3F51B5);
  static const primaryDark = Color(0xFF303F9F);
  static const accent = Color(0xFFFF6D00);
  static const bg = Color(0xFFF5F5FA);
  static const card = Colors.white;
  static const textDark = Color(0xFF1A1A2E);
  static const textMuted = Color(0xFF7B7B8E);
  static const divider = Color(0xFFE8E8F0);
}

// ═══════════════════════════════════════════════════════════════
//  DATA MODELS
// ═══════════════════════════════════════════════════════════════
class Category {
  final IconData icon;
  final String label;
  final Color color;

  const Category(this.icon, this.label, this.color);
}

class Product {
  final String name;
  final String price;
  final IconData icon;
  final Color placeholderColor;
  final double rating;

  const Product(this.name, this.price, this.icon, this.placeholderColor, this.rating);
}

// ── Sample data ──
const categories = [
  Category(Icons.directions_run, 'Shoes', Color(0xFFE8EAF6)),
  Category(Icons.shopping_bag_outlined, 'Bags', Color(0xFFFFF3E0)),
  Category(Icons.devices_outlined, 'Electronics', Color(0xFFE0F2F1)),
  Category(Icons.checkroom_outlined, 'Clothes', Color(0xFFFCE4EC)),
];

const products = [
  Product('Running Shoes', '₹2,499', Icons.directions_run, Color(0xFFE8EAF6), 4.5),
  Product('Leather Bag', '₹1,899', Icons.shopping_bag_outlined, Color(0xFFFFF3E0), 4.2),
  Product('Wireless Buds', '₹3,299', Icons.headphones_outlined, Color(0xFFE0F2F1), 4.8),
  Product('Denim Jacket', '₹1,599', Icons.checkroom_outlined, Color(0xFFFCE4EC), 4.0),
];

const banners = [
  _BannerData('Summer Sale', 'Up to 50% off on top brands', Color(0xFF3F51B5), Color(0xFF5C6BC0)),
  _BannerData('New Arrivals', 'Fresh styles just dropped', Color(0xFFFF6D00), Color(0xFFFF9100)),
  _BannerData('Free Shipping', 'On orders above ₹999', Color(0xFF00897B), Color(0xFF26A69A)),
];

class _BannerData {
  final String title;
  final String subtitle;
  final Color colorStart;
  final Color colorEnd;

  const _BannerData(this.title, this.subtitle, this.colorStart, this.colorEnd);
}

// ═══════════════════════════════════════════════════════════════
//  HOME SCREEN
// ═══════════════════════════════════════════════════════════════
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBanner = 0;
  int _cartCount = 0;

  void _addToCart() {
    setState(() => _cartCount++);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added to cart  ($_cartCount items)'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            // ═══ TOP BAR ═══
            _buildTopBar(),

            const SizedBox(height: 20),

            // ═══ SEARCH BAR ═══
            _buildSearchBar(),

            const SizedBox(height: 24),

            // ═══ PROMO BANNER (PageView) ═══
            _buildBannerSection(),

            const SizedBox(height: 28),

            // ═══ CATEGORIES ═══
            _buildSectionTitle('Categories', 'See all'),
            const SizedBox(height: 14),
            _buildCategories(),

            const SizedBox(height: 28),

            // ═══ FEATURED PRODUCTS ═══
            _buildSectionTitle('Featured Products', 'See all'),
            const SizedBox(height: 14),
            _buildProductGrid(),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  //  TOP BAR — greeting + cart icon
  // ─────────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.person_rounded, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 12),

          // Greeting
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good morning 👋',
                  style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                ),
                SizedBox(height: 2),
                Text(
                  'ShopEase',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),

          // Notification bell
          _iconBtn(Icons.notifications_none_rounded, () {}),
          const SizedBox(width: 8),

          // Cart with badge
          Stack(
            children: [
              _iconBtn(Icons.shopping_cart_outlined, () {}),
              if (_cartCount > 0)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$_cartCount',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
        ),
        child: Icon(icon, color: AppColors.textDark, size: 22),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  //  SEARCH BAR
  // ─────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
        ),
        child: const Row(
          children: [
            Icon(Icons.search_rounded, color: AppColors.textMuted, size: 22),
            SizedBox(width: 12),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search products, brands...',
                  hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 15),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            Icon(Icons.tune_rounded, color: AppColors.primary, size: 22),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  //  BANNER / PROMO SECTION
  // ─────────────────────────────────────────────────────────
  Widget _buildBannerSection() {
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            itemCount: banners.length,
            controller: PageController(viewportFraction: 0.88),
            onPageChanged: (i) => setState(() => _currentBanner = i),
            itemBuilder: (ctx, i) {
              final b = banners[i];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [b.colorStart, b.colorEnd],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: b.colorStart.withValues(alpha: 0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Decorative circles
                      Positioned(
                        right: -20,
                        top: -20,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 30,
                        bottom: -30,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                      ),

                      // Content
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              b.title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              b.subtitle,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withValues(alpha: 0.85),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Shop Now',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: b.colorStart,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),

        // Dot indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            banners.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentBanner == i ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentBanner == i ? AppColors.primary : AppColors.divider,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────
  //  SECTION TITLE
  // ─────────────────────────────────────────────────────────
  Widget _buildSectionTitle(String title, String action) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          Text(
            action,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  //  CATEGORIES — horizontal row of 4
  // ─────────────────────────────────────────────────────────
  Widget _buildCategories() {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (ctx, i) {
          final c = categories[i];
          return SizedBox(
            width: 76,
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: c.color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(c.icon, color: AppColors.primary, size: 28),
                ),
                const SizedBox(height: 8),
                Text(
                  c.label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  //  PRODUCT GRID — 2×2
  // ─────────────────────────────────────────────────────────
  Widget _buildProductGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.72,
        ),
        itemCount: products.length,
        itemBuilder: (ctx, i) => _ProductCard(
          product: products[i],
          onAdd: _addToCart,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  PRODUCT CARD — extracted widget for cleanliness
// ═══════════════════════════════════════════════════════════════
class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAdd;

  const _ProductCard({required this.product, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Color(0x08000000), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image placeholder ──
          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: product.placeholderColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(product.icon, size: 48, color: AppColors.primary.withValues(alpha: 0.5)),
                  ),
                  // Wishlist heart
                  Positioned(
                    right: 10,
                    top: 10,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.favorite_border_rounded, size: 16, color: AppColors.textMuted),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Details ──
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Star rating
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFFC107)),
                      const SizedBox(width: 3),
                      Text(
                        '${product.rating}',
                        style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Price + Add button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.price,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      GestureDetector(
                        onTap: onAdd,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.add_rounded, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
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