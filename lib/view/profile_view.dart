import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_view.dart';
import 'register_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  bool isEdit = false;
  bool isSaving = false;

  Future<DocumentSnapshot> _getUserData(String uid) {
    return FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  Future<void> _saveProfile(String uid) async {
    setState(() => isSaving = true);
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'address': addressController.text.trim(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đã lưu thông tin")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi: $e")),
      );
    } finally {
      setState(() {
        isSaving = false;
        isEdit = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return snapshot.data != null
              ? _loggedInUI(context, snapshot.data!)
              : _guestUI(context);
        },
      ),
    );
  }

  Widget _guestUI(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xfff857a6), Color(0xffff5858)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person_outline, size: 100, color: Colors.white),
          const SizedBox(height: 20),
          const Text("Bạn chưa đăng nhập",
              style: TextStyle(color: Colors.white, fontSize: 22)),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const LoginView())),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.pink,
                minimumSize: const Size(double.infinity, 50)),
            child: const Text("Đăng nhập"),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const RegisterView())),
            style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50)),
            child: const Text("Đăng ký"),
          ),
        ],
      ),
    );
  }

  Widget _loggedInUI(BuildContext context, User user) {
    return FutureBuilder<DocumentSnapshot>(
      future: _getUserData(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          if (nameController.text.isEmpty) {
            nameController.text = data['name'] ?? '';
            phoneController.text = data['phone'] ?? '';
            addressController.text = data['address'] ?? '';
          }
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 60, bottom: 40),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xfff857a6), Color(0xffff5858)],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 60, color: Colors.pink),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      nameController.text.isNotEmpty
                          ? nameController.text
                          : (user.email ?? 'Người dùng'),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(user.email ?? '', style: const TextStyle(color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: isSaving
                          ? null
                          : () => isEdit
                          ? _saveProfile(user.uid)
                          : setState(() => isEdit = true),
                      icon: Icon(isEdit ? Icons.save : Icons.edit),
                      label: Text(isEdit ? "Lưu thông tin" : "Chỉnh sửa"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.pink,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Thông tin chính trong 1 Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Thông tin cá nhân",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink),
                      ),
                      const SizedBox(height: 20),
                      _buildInfoRow(Icons.person, "Họ và tên", nameController, isEdit),
                      const Divider(height: 32),
                      _buildInfoRow(Icons.phone, "Số điện thoại", phoneController, isEdit),
                      const Divider(height: 32),
                      _buildInfoRow(Icons.location_on, "Địa chỉ", addressController, isEdit, maxLines: 3),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Đăng xuất
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    nameController.clear();
                    phoneController.clear();
                    addressController.clear();
                    await FirebaseAuth.instance.signOut();
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text("Đăng xuất"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, TextEditingController controller, bool enabled, {int maxLines = 1}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.pink, size: 26),
        const SizedBox(width: 16),
        Expanded(
          child: enabled
              ? TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          )
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              const SizedBox(height: 4),
              Text(
                controller.text.isNotEmpty ? controller.text : "Chưa cập nhật",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}