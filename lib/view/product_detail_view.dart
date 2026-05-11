import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';
import '../data/cart_data.dart';
import 'login_view.dart';

class ProductDetailView extends StatelessWidget {
  final Product product;

  const ProductDetailView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết sản phẩm')),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE
            AspectRatio(
              aspectRatio: 1,
              child: Image.asset(
                product.imageAsset,
                fit: BoxFit.contain,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// NAME
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// PRICE
                  Text(
                    "${product.price.toStringAsFixed(0)} đ",
                    style: const TextStyle(
                      fontSize: 26,
                      color: Colors.pink,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// RATING
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      const SizedBox(width: 5),
                      Text("${product.rating}"),
                      const SizedBox(width: 20),
                      Text("Đã bán ${product.sold}",
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Text("Mô tả",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                  const SizedBox(height: 6),

                  Text(product.description),

                  const SizedBox(height: 20),

                  const Text("Kích thước",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 8,
                    children: product.sizes
                        .map((e) => Chip(label: Text(e)))
                        .toList(),
                  ),

                  const SizedBox(height: 30),

                  /// BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (FirebaseAuth.instance.currentUser == null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginView()),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Vui lòng đăng nhập")),
                          );
                          return;
                        }

                        CartData.add(product);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Đã thêm vào giỏ")),
                        );
                      },
                      icon: const Icon(Icons.shopping_cart),
                      label: const Text("Thêm vào giỏ"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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
  }
}