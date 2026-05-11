import 'package:flutter/material.dart';
import '../data/order_data.dart';

class OrderHistoryView extends StatelessWidget {
  const OrderHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = OrderData.orders.reversed.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Lịch sử đơn hàng')),
      body: orders.isEmpty
          ? const Center(child: Text('Chưa có đơn hàng nào'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🕒 ${order.createdAt}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 8),

                  ...order.items.map((item) => Text(
                    '${item.product.name} x${item.quantity}',
                  )),

                  const SizedBox(height: 8),

                  Text(
                    'Tổng: ${order.total.toStringAsFixed(0)}đ',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}