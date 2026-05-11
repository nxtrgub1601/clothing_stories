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
            /// IMAGE + INFO ROW
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /// IMAGE (bên trái, chiếm 45% màn hình)
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Image.asset(
                      product.imageAsset,
                      fit: BoxFit.cover,
                    ),
                  ),

                  /// INFO (bên phải)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// NAME
                          Text(
                            product.name,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          /// PRICE
                          Text(
                            "${product.price.toStringAsFixed(0)} đ",
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.pink,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          /// RATING
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.amber, size: 18),
                              const SizedBox(width: 4),
                              Text("${product.rating}",
                                  style: const TextStyle(fontSize: 13)),
                            ],
                          ),

                          const SizedBox(height: 4),

                          /// SOLD
                          Text(
                            "Đã bán ${product.sold}",
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 13),
                          ),

                          const SizedBox(height: 12),

                          /// SIZES
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: product.sizes
                                .map((e) => Chip(
                              label: Text(e,
                                  style:
                                  const TextStyle(fontSize: 12)),
                              padding: EdgeInsets.zero,
                              materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                            ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// DESCRIPTION + BUTTON (full-width bên dưới)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Mô tả",
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 6),

                  Text(product.description),

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
                          const SnackBar(content: Text("Đã thêm vào giỏ")),
                        );
                      },
                      icon: const Icon(Icons.shopping_cart),
                      label: const Text("Thêm vào giỏ"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
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