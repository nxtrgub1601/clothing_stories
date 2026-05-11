import 'package:flutter/material.dart';
import '../data/cart_data.dart';
import '../models/cart_item.dart';
import 'payment_view.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final Set<CartItem> _selectedItems = {};

  // Đổi sang xanh biển nhạt
  static const _blue = Color(0xFF4FC3F7);

  String _fmt(double price) => price
      .toStringAsFixed(0)
      .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]}.');

  @override
  Widget build(BuildContext context) {
    final items = CartData.items;
    final total =
    _selectedItems.fold(0.0, (s, i) => s + i.product.price * i.quantity);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: const Text('Giỏ hàng',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: _blue,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: true,
      ),
      body: items.isEmpty
          ? const Center(
          child:
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.shopping_cart_outlined,
                size: 80, color: Colors.grey),
            SizedBox(height: 12),
            Text('Giỏ hàng trống',
                style: TextStyle(fontSize: 18, color: Colors.grey)),
          ]))
          : Column(children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (_, index) {
              final item = items[index];
              final selected = _selectedItems.contains(item);

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: selected
                          ? _blue
                          : const Color(0xFFEEEEEE),
                      width: selected ? 1.8 : 1.0),
                ),
                child: Row(children: [
                  // Checkbox
                  Checkbox(
                    value: selected,
                    activeColor: _blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    onChanged: (v) => setState(() => v!
                        ? _selectedItems.add(item)
                        : _selectedItems.remove(item)),
                  ),

                  // Ảnh
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(item.product.imageAsset,
                        width: 68,
                        height: 68,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                            width: 68,
                            height: 68,
                            color: Colors.grey[100],
                            child: const Icon(
                                Icons.image_not_supported,
                                color: Colors.grey))),
                  ),

                  const SizedBox(width: 12),

                  // Info
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.product.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14)),
                          const SizedBox(height: 4),
                          Text('${_fmt(item.product.price)}đ',
                              style: const TextStyle(
                                  color: _blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)),
                          const SizedBox(height: 8),
                          Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                // Tăng giảm SL
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color:
                                          Colors.grey.shade200),
                                      borderRadius:
                                      BorderRadius.circular(8)),
                                  child: Row(children: [
                                    _qtyBtn(
                                        Icons.remove,
                                            () => setState(() =>
                                            CartData.decrease(item))),
                                    Text('${item.quantity}',
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight:
                                            FontWeight.bold)),
                                    _qtyBtn(
                                        Icons.add,
                                            () => setState(() =>
                                            CartData.add(
                                                item.product))),
                                  ]),
                                ),

                                // Xóa
                                GestureDetector(
                                  onTap: () => setState(() {
                                    _selectedItems.remove(item);
                                    CartData.remove(item);
                                  }),
                                  child: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.redAccent,
                                      size: 22),
                                ),
                              ]),
                        ]),
                  ),
                ]),
              );
            },
          ),
        ),

        // Bottom bar
        Container(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            border:
            Border(top: BorderSide(color: Color(0xFFEEEEEE))),
          ),
          child: Column(children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${_selectedItems.length} sản phẩm đã chọn',
                      style: const TextStyle(
                          color: Colors.grey, fontSize: 13)),
                  Text('${_fmt(total)}đ',
                      style: const TextStyle(
                          color: _blue,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                ]),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _selectedItems.isEmpty
                    ? null
                    : () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => PaymentView(
                            selectedItems:
                            _selectedItems.toList()))),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _blue,
                  disabledBackgroundColor:
                  Colors.grey.shade300,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(14)),
                ),
                child: Text(
                  _selectedItems.isEmpty
                      ? 'Chọn sản phẩm để thanh toán'
                      : 'Thanh toán ngay →',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ]),
        ),
      ]),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Padding(
      padding:
      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Icon(icon, size: 16, color: _blue),
    ),
  );
}