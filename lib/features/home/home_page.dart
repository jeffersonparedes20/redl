import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../challenge/challenge_page.dart';

/// Página principal de la aplicación
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    /// Usuario actualmente autenticado
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("REDL"),

        /// Mostramos el email del usuario en la parte derecha
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
        ],
      ),

      /// Mostramos la página del reto
      body: const ChallengePage(),
    );
  }
}
