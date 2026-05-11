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

class _HomeViewState extends State<HomeView>
    with AutomaticKeepAliveClientMixin {

  final TextEditingController _searchController = TextEditingController();
  final ProductService _productService = ProductService();

  String _searchQuery = '';

  final PageController _bannerController = PageController(viewportFraction: 0.9);
  int _currentBanner = 0;

  final List<String> banners = [
    'assets/images/banner/banner_01.jpg',
    'assets/images/banner/banner_02.jpg',
    'assets/images/banner/banner_03.jpg',
    'assets/images/banner/banner_04.jpg',
    'assets/images/banner/banner_05.jpg',
    'assets/images/banner/banner_06.jpg',
  ];

  static const _blue = Color(0xFF4FC3F7);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _autoBanner();
  }

  void _onSearchChanged() {
    setState(() => _searchQuery = _searchController.text.toLowerCase().trim());
  }

  void _autoBanner() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 4));
      if (!mounted) return;
      _currentBanner = (_currentBanner + 1) % banners.length;
      _bannerController.animateToPage(
        _currentBanner,
        duration: const Duration(milliseconds: 600),
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

  List<Product> _filterProducts(List<Product> products) {
    if (_searchQuery.isEmpty) return products;
    return products.where((p) =>
    p.name.toLowerCase().contains(_searchQuery) ||
        p.category.toLowerCase().contains(_searchQuery)).toList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: const Text(
          'Total Nine Shop',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: _blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          /// Search + Cart
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
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                /// Cart Icon
                Stack(
                  children: [
                    IconButton(
                      icon: Icon(Icons.shopping_cart_outlined,
                          size: 28, color: _blue),
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

          /// Main Content
          Expanded(
            child: StreamBuilder<List<Product>>(
              stream: _productService.getProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Lỗi: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Không có sản phẩm nào'));
                }

                final filteredProducts = _filterProducts(snapshot.data!);

                if (filteredProducts.isEmpty) {
                  return const Center(
                    child: Text('Không tìm thấy sản phẩm', style: TextStyle(fontSize: 18)),
                  );
                }

                return ListView(
                  children: [
                    /// Banner
                    SizedBox(
                      height: 220,
                      child: PageView.builder(
                        controller: _bannerController,
                        itemCount: banners.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                banners[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// Products Grid
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                          return ProductCard(product: filteredProducts[index]);
                        },
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// Footer
                    Container(
                      padding: const EdgeInsets.all(20),
                      color: Colors.black87,
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Fashion Clothes',
                              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text('Chuyên cung cấp thời trang chất lượng cao.',
                              style: TextStyle(color: Colors.white70)),
                          SizedBox(height: 8),
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