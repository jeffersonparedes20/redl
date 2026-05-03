import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../home/home_page.dart';
import 'login_page.dart';

// AuthGate es el widget que decide qué pantalla mostrar según el estado de autenticación del usuario
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  // El widget escucha los cambios en el estado de autenticación del usuario
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Mientras se verifica el estado de autenticación, mostramos un indicador de carga
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Si el usuario está autenticado → Home
        if (snapshot.hasData) {
          return const HomePage();
        }

        /// Si no → Login
        return const LoginPage();
      },
    );
  }
}
