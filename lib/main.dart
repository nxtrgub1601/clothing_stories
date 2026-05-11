import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'theme/app_theme.dart';
import 'view/main_screen.dart';

// Import script import sản phẩm
import 'scripts/import_products.dart';   // ← Thêm dòng này

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ==================== IMPORT SẢN PHẨM (Chạy 1 lần) ====================
  // Bỏ comment dòng dưới để import dữ liệu lần đầu
  await importProducts();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClothVN',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainScreen(),
    );
  }
}