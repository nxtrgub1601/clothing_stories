import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_view.dart';
import 'register_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

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
          const Icon(Icons.person_outline, size: 100, color: Colors.white),
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
    return Column(
      children: [

        /// 🔥 HEADER
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
                child: Icon(Icons.person, size: 50, color: Colors.pink),
              ),
              const SizedBox(height: 10),

              Text(
                user.email ?? "No Email",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),

        /// 🔥 MENU
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Column(
              children: [
                _tile(Icons.shopping_bag, "Đơn hàng"),
                _tile(Icons.location_on, "Địa chỉ"),
                _tile(Icons.payment, "Thanh toán"),
                _tile(Icons.favorite, "Yêu thích"),

                const Spacer(),

                /// 🔥 LOGOUT
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text("Đăng xuất"),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                  },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  // ================= ITEM =================
  Widget _tile(IconData icon, String title) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.pink),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}