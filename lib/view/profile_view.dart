import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_view.dart';
import 'register_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  bool isEdit = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data != null) {
            return _loggedInUI(context, snapshot.data!);
          } else {
            return _guestUI(context);
          }
        },
      ),
    );
  }

  // ================= CHƯA LOGIN =================
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
          const Icon(Icons.person_outline,
              size: 100, color: Colors.white),

          const SizedBox(height: 20),

          const Text(
            "Bạn chưa đăng nhập",
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),

          const SizedBox(height: 30),

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginView()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.pink,
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text("Đăng nhập"),
          ),

          const SizedBox(height: 12),

          OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RegisterView()),
              );
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text("Đăng ký"),
          ),
        ],
      ),
    );
  }

  // ================= ĐÃ LOGIN =================
  Widget _loggedInUI(BuildContext context, User user) {

    nameController.text =
    nameController.text.isEmpty ? "Nguyễn Xuân Trường" : nameController.text;

    phoneController.text =
    phoneController.text.isEmpty ? "0123456789" : phoneController.text;

    addressController.text =
    addressController.text.isEmpty
        ? "Hà Nội, Việt Nam"
        : addressController.text;

    return SingleChildScrollView(
      child: Column(
        children: [

          /// HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, bottom: 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xfff857a6), Color(0xffff5858)],
              ),
            ),
            child: Column(
              children: [

                const CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person,
                      size: 50,
                      color: Colors.pink),
                ),

                const SizedBox(height: 10),

                Text(
                  user.email ?? "No Email",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      isEdit = !isEdit;
                    });
                  },
                  icon: Icon(
                    isEdit ? Icons.save : Icons.edit,
                  ),
                  label: Text(
                    isEdit ? "Lưu thông tin" : "Chỉnh sửa",
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.pink,
                  ),
                ),
              ],
            ),
          ),

          /// FORM
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [

                _buildTextField(
                  controller: nameController,
                  label: "Họ và tên",
                  icon: Icons.person,
                  enabled: isEdit,
                ),

                const SizedBox(height: 16),

                _buildTextField(
                  controller: phoneController,
                  label: "Số điện thoại",
                  icon: Icons.phone,
                  enabled: isEdit,
                ),

                const SizedBox(height: 16),

                _buildTextField(
                  controller: addressController,
                  label: "Địa chỉ",
                  icon: Icons.location_on,
                  enabled: isEdit,
                ),

                const SizedBox(height: 30),

                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                    },
                    icon: const Icon(Icons.logout, size: 18),
                    label: const Text(
                      "Đăng xuất",
                      style: TextStyle(fontSize: 13),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= TEXTFIELD =================
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool enabled,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.pink),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}