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

  // Método para manejar login/registro con manejo de errores
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

      // Mostrar error al usuario
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

        // Configuración de partículas rojas con movimiento aleatorio
        behaviour: RandomParticleBehaviour(
          options: const ParticleOptions(
            baseColor: Colors.redAccent,
            spawnMinSpeed: 35,
            spawnMaxSpeed: 90,
            spawnMinRadius: 4,
            spawnMaxRadius: 9,
            particleCount: 140,
            opacityChangeRate: 0.35,
            minOpacity: 0.4,
            maxOpacity: 0.9,
          ),
        ),

        child: Stack(
          children: [
            Positioned.fill(
              child: Container(color: Colors.black.withValues(alpha: 0.35)),
            ),

            // Panel incio de sesion
            Center(
              child: Container(
                width: 340,
                padding: const EdgeInsets.all(24),

                decoration: BoxDecoration(
                  color: const Color(0xFF111827).withValues(alpha: 0.92),
                  border: Border.all(color: Colors.redAccent, width: 1.5),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.redAccent.withValues(alpha: 0.25),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // titulo de la app
                    const Text(
                      "REDL SYSTEM",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      ">> ACCESO RESTRINGIDO",
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Caja de email
                    TextField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: const TextStyle(color: Colors.white70),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.redAccent.withValues(alpha: 0.5),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.redAccent),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Caja de contraseña
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Contraseña",
                        labelStyle: const TextStyle(color: Colors.white70),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.redAccent.withValues(alpha: 0.5),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.redAccent),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    // Caja boton de login
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _submit,
                        child: Text(
                          isLogin ? "INICIAR SESIÓN" : "REGISTRARSE",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // opción para cambiar entre login y registro
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: Text(
                        isLogin ? "Crear cuenta" : "Ya tengo cuenta",
                        style: const TextStyle(color: Colors.white70),
                      ),
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
