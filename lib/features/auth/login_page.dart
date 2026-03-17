import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';
import 'auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// Necesario para animaciones
class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool isLogin = true;

  /// Método de login / registro
  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      if (isLogin) {
        await _authService.login(email, password);
      } else {
        await _authService.register(email, password);
      }
    } catch (e) {
      if (!mounted) return;

      // En caso de error, mostramos un SnackBar con el mensaje
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        vsync: this,

        // Partículas estilo infección
        behaviour: RandomParticleBehaviour(
          options: const ParticleOptions(
            baseColor: Colors.redAccent,
            spawnMinSpeed: 20,
            spawnMaxSpeed: 50,
            spawnMinRadius: 3,
            spawnMaxRadius: 6,
            particleCount: 80,
          ),
        ),

        child: Stack(
          children: [
            /// 🌑 Capa oscura para contraste
            Positioned.fill(
              child: Container(color: Colors.black.withValues(alpha: 0.6)),
            ),

            /// 🧩 Panel de login
            Center(
              child: Container(
                width: 320,
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: const Color(0xFF111827),
                  border: Border.all(color: Colors.redAccent),
                  borderRadius: BorderRadius.circular(10),
                ),

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Título
                    const Text(
                      "REDL SYSTEM",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      ">> ACCESO RESTRINGIDO",
                      style: TextStyle(color: Colors.white38, fontSize: 12),
                    ),

                    const SizedBox(height: 20),

                    // Email
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: "Email"),
                    ),

                    const SizedBox(height: 10),

                    //Password
                    TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: "Contraseña",
                      ),
                      obscureText: true,
                    ),

                    const SizedBox(height: 20),

                    // Botón principal
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                      ),
                      onPressed: _submit,
                      child: Text(isLogin ? "INICIAR SESIÓN" : "REGISTRARSE"),
                    ),

                    // Cambiar modo
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: Text(isLogin ? "Crear cuenta" : "Ya tengo cuenta"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
