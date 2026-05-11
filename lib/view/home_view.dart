import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';
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
  final ProductService _productService = ProductService();

  String _searchQuery = '';

  /// Banner controller
  final PageController _bannerController = PageController(viewportFraction: 0.9);
  int _currentBanner = 0;

  final List<String> banners = [
    'assets/images/banner/banner1.jpg',
    'assets/images/banner/banner2.jpg',
    'assets/images/banner/banner3.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _autoBanner();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase().trim();
    });
  }

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

  @override
  void dispose() {
    _searchController.dispose();
    _bannerController.dispose();
    super.dispose();
  }

  // Lọc sản phẩm theo từ khóa tìm kiếm
  List<Product> _filterProducts(List<Product> products) {
    if (_searchQuery.isEmpty) return products;
    return products.where((p) =>
    p.name.toLowerCase().contains(_searchQuery) ||
        p.category.toLowerCase().contains(_searchQuery)).toList();
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
      body: Column(
        children: [
          /// 🔍 SEARCH
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
                          MaterialPageRoute(builder: (_) => const CartView()),
                        );
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

          /// 📜 Nội dung chính
          Expanded(
            child: StreamBuilder<List<Product>>(
              stream: _productService.getProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Lỗi: ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('Không có sản phẩm nào'),
                  );
                }

                final allProducts = snapshot.data!;
                final filteredProducts = _filterProducts(allProducts);

                if (filteredProducts.isEmpty) {
                  return const Center(
                    child: Text('Không tìm thấy sản phẩm', style: TextStyle(fontSize: 18)),
                  );
                }

                return ListView(
                  children: [
                    /// 🎯 BANNER
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
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// 🛍️ GRID SẢN PHẨM
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          return ProductCard(
                            product: filteredProducts[index],
                          );
                        },
                      ),
                    ),

                    /// Footer
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      color: Colors.black87,
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Fashion Clothes',
                              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Text('Chuyên cung cấp thời trang chất lượng cao.',
                              style: TextStyle(color: Colors.white70)),
                          SizedBox(height: 10),
                          Text('📍 Hà Nội', style: TextStyle(color: Colors.white70)),
                          Text('📞 0123 456 789', style: TextStyle(color: Colors.white70)),
                          Text('📧 shop@gmail.com', style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}