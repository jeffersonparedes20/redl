import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../challenge/challenge_page.dart';
import '../posts/posts_page.dart';
import '../profile/profile_page.dart';
import '../auth/auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "REDL // SYSTEM",
          style: TextStyle(
            color: Colors.redAccent,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          // Email del usuario
          Padding(
            padding: const EdgeInsets.all(12),
            child: Center(
              child: Text(
                user?.email ?? "Usuario",
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),

          // Perfil
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
          ),

          /// 🔓 Logout
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () async {
              await authService.logout();
            },
          ),
        ],
      ),

      // Contenido principal (reto del día)
      body: const ChallengePage(),

      // Botón para ver/publicar pistas
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => PostsPage()),
          );
        },
        child: const Icon(Icons.forum),
      ),
    );
  }
}
