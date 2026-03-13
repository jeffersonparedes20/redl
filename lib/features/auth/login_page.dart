import 'package:flutter/material.dart';
import 'auth_service.dart';

/* Pantalla de autenticación
- Permite a los usuarios registrarse o iniciar sesión con email y contraseña.
- Utiliza AuthService para interactuar con Firebase Authentication y Firestore.
*/
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// Estado de la pantalla de login
class _LoginPageState extends State<LoginPage> {
  // Controladores para los campos de texto introducidos por el usuario
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Instancia del servicio de autenticación
  final AuthService _authService = AuthService();

  //Variable que determina si estamos en modo login o registro
  bool isLogin = true;

  /*
  Método que gestiona el envío del formulario de login/registro.
- Obtiene el email y contraseña de los controladores.
- Llama al método correspondiente de AuthService
  */
  Future<void> _submit() async {
    //Se eliminan espacios en blanco al inicio y final de los campos
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      /*
      Según el estado de isLogin:
      -true → se intenta iniciar sesión
      -false → se intenta registrar usuario
       */
      if (isLogin) {
        await _authService.login(email, password);
      } else {
        await _authService.register(email, password);
      }

      /*
        No se realiza navegación manual aquí.
        La redirección se gestiona automáticamente mediante
        el AuthWrapper que escucha authStateChanges().
      */
    } catch (e) {
      // Verificación de seguridad tras operación asíncrona
      // Evita usar context si el widget fue desmontado
      if (!mounted) return;

      // En caso de error, se muestra un mensaje al usuario
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // Centra el contenido en la pantalla
        child: SizedBox(
          width: 300, // limita el ancho en version web
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, //centra verticalmente
            children: [
              // Título dinámico según el modo actual
              Text(
                isLogin ? "Iniciar Sesión" : "Registrarse",
                style: const TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 20),

              //Campo de contraseña con ocultación de texto
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: "Contraseña"),
                obscureText: true,
              ),
              const SizedBox(height: 20),

              //Botón principal que ejecuta la función de envío
              ElevatedButton(
                onPressed: _submit,
                child: Text(isLogin ? "Login" : "Register"),
              ), // Botón secundario para cambiar entre modos
              TextButton(
                onPressed: () {
                  // Cambia entre modo login y registro
                  setState(() {
                    isLogin = !isLogin;
                  });
                },
                child: Text(
                  isLogin
                      ? "¿No tienes cuenta? Regístrate"
                      : "¿Ya tienes cuenta? Inicia sesión",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
