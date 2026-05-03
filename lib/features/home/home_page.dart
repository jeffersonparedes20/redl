import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../challenge/challenge_page.dart';
import '../posts/posts_page.dart';
import '../posts/posts_feed.dart';
import '../profile/profile_page.dart';
import '../auth/auth_service.dart';
import '../../widgets/animated_redl_background.dart';

// clase principal de la pantalla de inicio
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
          Padding(
            padding: const EdgeInsets.all(12),
            child: Center(
              child: Text(
                user?.email ?? "Usuario",
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),

          // Botón para ver perfil
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
          ),

          // Botón de cierre de sesión
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () async {
              await authService.logout();
            },
          ),
        ],
      ),

      // Fondo animado
      body: const AnimatedRedlBackground(child: HomeContent()),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => PostsPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// clase que contiene el contenido principal de la pantalla de inicio
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: ChallengePage(),
        ),

        SizedBox(height: 20),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            ">> PISTAS DE LA COMUNIDAD",
            style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              fontSize: 16,
            ),
          ),
        ),

        SizedBox(height: 10),
        // Feed de pistas
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: PostsFeed(),
          ),
        ),
      ],
    );
  }
}
