import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

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
  static Future<String> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "Đăng ký thành công";
    } catch (e) {
      return e.toString();
    }
  }

  /// 🔥 FORGOT PASSWORD (QUÊN MẬT KHẨU)
  static Future<String> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return "📩 Đã gửi email đặt lại mật khẩu";
    } catch (e) {
      return "❌ Lỗi: $e";
    }
  }
}