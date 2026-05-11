import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// 🔥 LOGIN
  static Future<String> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "Đăng nhập thành công";
    } catch (e) {
      return e.toString();
    }
  }

  /// 🔥 REGISTER
  static Future<String> register(
      String email,
      String password, {
        required String name,
        required String phone,
      }) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Lưu thông tin bổ sung vào Firestore
      await _db.collection('users').doc(cred.user!.uid).set({
        'uid': cred.user!.uid,
        'name': name,
        'email': email,
        'phone': phone,
        'address': '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      return "Đăng ký thành công";
    } catch (e) {
      return e.toString();
    }
  }

  /// 🔥 FORGOT PASSWORD
  static Future<String> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return "📩 Đã gửi email đặt lại mật khẩu";
    } catch (e) {
      return "❌ Lỗi: $e";
    }
  }
}