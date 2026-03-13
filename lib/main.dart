import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'features/auth/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'features/home/home_page.dart';

void main() async {
  // Necesario antes de usar código async en main
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase con la configuración generada
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Ejecuta la aplicación
  runApp(const MyApp());
}

// Página de prueba para verificar conexión con Firebase
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthWrapper(),
    );
  }
}

// Widget que decide qué pantalla mostrar según el estado de autenticación
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Mientras se comprueba el estado
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Si hay usuario logueado
        if (snapshot.hasData) {
          return const HomePage();
        }

        // Si no hay usuario
        return const LoginPage();
      },
    );
  }
}

// Página de prueba para verificar conexión con Firebase
class FirebaseTestPage extends StatelessWidget {
  const FirebaseTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "REDL conectado a Firebase 🔥",
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
