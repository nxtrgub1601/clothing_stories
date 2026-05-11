import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/dummy_data.dart';
import '../data/cart_data.dart';
import '../widget/product_card.dart';
import 'cart_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _filteredProducts = [];

  /// Banner controller
  final PageController _bannerController =
  PageController(viewportFraction: 0.9);
  int _currentBanner = 0;

  final List<String> banners = [
    'assets/images/banner/banner1.jpg',
    'assets/images/banner/banner2.jpg',
    'assets/images/banner/banner3.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _filteredProducts = List.from(products);
    _searchController.addListener(_filterProducts);

    _autoBanner();
  }

  /// Auto banner
  void _autoBanner() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) return;

      _currentBanner = (_currentBanner + 1) % banners.length;

      _bannerController.animateToPage(
        _currentBanner,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _filterProducts() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      _filteredProducts = products.where((p) =>
      p.name.toLowerCase().contains(query) ||
          p.category.toLowerCase().contains(query)).toList();
    });
  }

  void _updateCart() => setState(() {});

  @override
  void dispose() {
    _searchController.dispose();
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fashion Clothes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      /// 🔥 BODY
      body: Column(
        children: [
          /// 🔍 SEARCH (CỐ ĐỊNH)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm sản phẩm...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                /// 🛒 CART
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart_outlined, size: 28),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const CartView()),
                        ).then((_) => _updateCart());
                      },
                    ),
                    if (CartData.getTotalQuantity() > 0)
                      Positioned(
                        right: 6,
                        top: 6,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            CartData.getTotalQuantity().toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          /// 📜 SCROLL TOÀN BỘ NỘI DUNG
          Expanded(
            child: _filteredProducts.isEmpty
                ? const Center(
              child: Text(
                'Không tìm thấy sản phẩm',
                style: TextStyle(fontSize: 18),
              ),
            )
                : ListView(
              children: [
                /// 🎯 BANNER (SCROLL)
                SizedBox(
                  height: 160,
                  child: PageView.builder(
                    controller: _bannerController,
                    itemCount: banners.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            banners[index],
                            fit: BoxFit.cover, // 🔥 quan trọng
                            width: double.infinity,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),

                /// 🛍️ GRID SẢN PHẨM
                GridView.builder(
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: _filteredProducts.length,
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: _filteredProducts[index],
                    );
                  },
                ),

                /// 📌 FOOTER
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  color: Colors.black87,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fashion Clothes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Chuyên cung cấp thời trang chất lượng cao.',
                        style: TextStyle(color: Colors.white70),
                      ),
                      SizedBox(height: 10),
                      Text('📍 Hà Nội',
                          style: TextStyle(color: Colors.white70)),
                      Text('📞 0123 456 789',
                          style: TextStyle(color: Colors.white70)),
                      Text('📧 shop@gmail.com',
                          style: TextStyle(color: Colors.white70)),
                    ],
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