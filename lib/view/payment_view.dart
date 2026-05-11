import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../data/cart_data.dart';
import '../models/cart_item.dart';
import 'order_success_view.dart';
import '../data/order_data.dart';

class PaymentView extends StatefulWidget {
  final List<CartItem> selectedItems;
  const PaymentView({super.key, required this.selectedItems});

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  int _method = 0;

  // Đổi sang xanh biển nhạt
  static const _blue = Color(0xFF4FC3F7);

  double get _total => widget.selectedItems.fold(
      0.0, (sum, item) => sum + item.product.price * item.quantity);

  String get _totalStr => _total
      .toStringAsFixed(0)
      .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]}.');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: const Text('Thanh toán',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: _blue,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          // Tổng tiền
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _blue,
              borderRadius: BorderRadius.circular(16),
            ),
            child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Tổng thanh toán',
                  style: TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 6),
              Text('${_totalStr}đ',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('${widget.selectedItems.length} sản phẩm',
                  style: const TextStyle(
                      color: Colors.white60, fontSize: 12)),
            ]),
          ),

          const SizedBox(height: 20),

          // Chọn phương thức
          _option(0, Icons.local_shipping_outlined,
              'Thanh toán khi nhận hàng (COD)'),
          const SizedBox(height: 10),
          _option(1, Icons.qr_code_2_outlined, 'Chuyển khoản QR'),

          // QR code
          if (_method == 1) ...[
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border:
                Border.all(color: const Color(0xFFB3E5FC)),
              ),
              child: Column(children: [
                const Text('Quét mã để thanh toán',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('${_totalStr}đ',
                    style: const TextStyle(
                        color: _blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                const SizedBox(height: 16),
                QrImageView(
                  data: 'ClothVN_${_total.toStringAsFixed(0)}',
                  size: 190,
                ),
                const SizedBox(height: 8),
                const Text('Mã có hiệu lực 15 phút',
                    style: TextStyle(
                        color: Colors.grey, fontSize: 12)),
              ]),
            ),
          ],

          const SizedBox(height: 28),

          // Nút đặt hàng
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                final items =
                List<CartItem>.from(widget.selectedItems);

                OrderData.addOrder(items);

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            OrderSuccessView(cartItems: items)));

                CartData.removeSelected(widget.selectedItems);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _blue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(
                _method == 0
                    ? 'Xác nhận đặt hàng →'
                    : 'Hoàn tất thanh toán QR →',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _option(int value, IconData icon, String label) {
    final selected = _method == value;

    return GestureDetector(
      onTap: () => setState(() => _method = value),
      child: Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFE1F5FE)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: selected
                  ? _blue
                  : const Color(0xFFE0E0E0),
              width: selected ? 1.8 : 1.0),
        ),
        child: Row(children: [
          Icon(icon,
              color: selected ? _blue : Colors.grey,
              size: 22),
          const SizedBox(width: 12),
          Expanded(
              child: Text(label,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? _blue
                          : const Color(0xFF2D2D2D)))),
          Radio<int>(
              value: value,
              groupValue: _method,
              onChanged: (v) => setState(() => _method = v!),
              activeColor: _blue,
              materialTapTargetSize:
              MaterialTapTargetSize.shrinkWrap),
        ]),
      ),
    );
  }
}