import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../challenge/challenge_page.dart';
import '../posts/posts_page.dart';
import '../posts/posts_feed.dart';
import '../profile/profile_page.dart';
import '../auth/auth_service.dart';

/// Página principal que muestra el reto activo y el feed de pistas
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  // Construimos la interfaz de la página principal
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
          // Email
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

          // Logout
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () async {
              await authService.logout();
            },
          ),
        ],
      ),

      // CONTENIDO PRINCIPAL
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reto del día
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ChallengePage(),
          ),

          SizedBox(height: 20),

          //Título
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

          // Feed (scroll aquí)
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: PostsFeed(),
            ),
          ),
        ],
      ),

      // Botón para publicar pistas
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
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
