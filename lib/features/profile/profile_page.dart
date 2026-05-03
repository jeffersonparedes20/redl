import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/animated_redl_background.dart';

// Página de perfil del usuario
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    //Si no hay usuario autenticado
    if (user == null) {
      return const Scaffold(body: Center(child: Text("No hay usuario")));
    }

    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);

    return Scaffold(
      appBar: AppBar(title: const Text("Perfil")),

      // Fondo animado REDL
      body: AnimatedRedlBackground(
        child: StreamBuilder<DocumentSnapshot>(
          stream: userRef.snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final data = snapshot.data!.data() as Map<String, dynamic>?;

            // Sin datos del usuario
            if (data == null) {
              return const Center(
                child: Text("Sin datos", style: TextStyle(color: Colors.white)),
              );
            }

            return Center(
              child: Container(
                width: 380,
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(24),

                decoration: BoxDecoration(
                  color: const Color(0xFF111827).withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.redAccent.withValues(alpha: 0.5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.redAccent.withValues(alpha: 0.2),
                      blurRadius: 14,
                      spreadRadius: 1,
                    ),
                  ],
                ),

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título del perfil
                    const Center(
                      child: Text(
                        "PERFIL REDL",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Email del usuario
                    Text(
                      "📧 Email: ${data['email']}",
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),

                    const SizedBox(height: 12),

                    // Nivel del usuario
                    Text(
                      "⭐ Nivel: ${data['nivel']}",
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),

                    const SizedBox(height: 12),

                    // Puntos del usuario
                    Text(
                      "🏆 Puntos: ${data['puntos']}",
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),

                    const SizedBox(height: 20),

                    // Número de pistas publicadas
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .where('userId', isEqualTo: user.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        }

                        final count = snapshot.data!.docs.length;

                        return Text(
                          "💬 Pistas publicadas: $count",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
