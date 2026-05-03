import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'features/auth/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializamos Firebase con la configuración generada
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

// Widget principal de la aplicación
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'REDL',

      // Quitamos el banner de debug
      debugShowCheckedModeBanner: false,

      // Tema global estilo survival
      theme: ThemeData(
        brightness: Brightness.dark,

        // Fondo oscuro
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),

        // Color principal (rojo)
        primaryColor: Colors.red,

        // Colores secundarios
        colorScheme: const ColorScheme.dark(
          primary: Colors.red,
          secondary: Colors.green,
        ),

        // AppBar estilo oscuro
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
        ),

        // Texto por defecto
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      ),

      // Punto de entrada de la app (login o home)
      home: const AuthGate(),
    );
  }
}
