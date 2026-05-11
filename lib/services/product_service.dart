import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Product>> getProducts() {
    return _firestore.collection('products').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Lấy theo danh mục (nếu bạn có filter)
  Stream<List<Product>> getProductsByCategory(String category) {
    return _firestore
        .collection('products')
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Product.fromMap(doc.data(), doc.id)).toList();
    });
  }
}