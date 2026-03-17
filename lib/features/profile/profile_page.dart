import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Página de perfil del usuario
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // Si no hay usuario autenticado, mostramos un mensaje
    if (user == null) {
      return const Scaffold(body: Center(child: Text("No hay usuario")));
    }

    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);

    return Scaffold(
      appBar: AppBar(title: const Text("Perfil")),

      // Usamos StreamBuilder para escuchar cambios en el perfil del usuario en tiempo real
      body: StreamBuilder<DocumentSnapshot>(
        stream: userRef.snapshots(),

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>?;

          if (data == null) {
            return const Center(child: Text("Sin datos"));
          }

          return Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Email
                Text(
                  "Email: ${data['email']}",
                  style: const TextStyle(fontSize: 18),
                ),

                const SizedBox(height: 10),

                /// Nivel
                Text(
                  "Nivel: ${data['nivel']}",
                  style: const TextStyle(fontSize: 18),
                ),

                const SizedBox(height: 10),

                /// Puntos
                Text(
                  "Puntos: ${data['puntos']}",
                  style: const TextStyle(fontSize: 18),
                ),

                // Contamos el número de pistas publicadas por el usuario
                const SizedBox(height: 20),
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
                      "Pistas publicadas: $count",
                      style: const TextStyle(fontSize: 18),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
