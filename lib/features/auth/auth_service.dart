import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/* Servicio de autenticación
-Registro, login y logout de los usuarios
-Creacion de perfil en Firestore al registrarse
*/
class AuthService {
  // Firebase Auth para autenticación
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Firestore para almacenar perfiles de usuario
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /*
- Crea un nuevo usuario en Firebase Authentication mediante email y contraseña.
- Si el registro es exitoso, también crea un documento en la colección 'users' de Firestore con información adicional.
- Devuelve el usuario registrado o null en caso de error.
*/
  Future<User?> register(String email, String password) async {
    try {
      // Crea usuario en Firebase Auth
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user;
      // Si el usuario se creó correctamente, se genera un perfil en Firestore
      if (user != null) {
        /*
        Se crea un documento con ID = UID del usuario.
        Esto garantiza correspondencia 1:1 entre Auth y Firestore.

        Campos almacenados:
        - email: identificador visible
        - nivel: estado inicial del usuario
        - puntos: sistema de gamificación
         - createdAt: timestamp generado por el servidor
        */
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'nivel': 'Novato',
          'puntos': 0,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      // Devolvemos el usuario registrado
      return user;
    } catch (e) {
      // En caso de error, lo imprimimos y devolvemos null
      debugPrint("Error en registro: $e");
      return null;
    }
  }

  /*INICIO DE SESIÓN

- Intenta iniciar sesión con email y contraseña.
- Si el inicio de sesión es exitoso, verifica si el usuario tiene un perfil en Firestore.
- Si el perfil no existe (caso raro, pero posible), lo crea con los valores predeterminados.
- Devuelve el usuario autenticado o null en caso de error.
  */
  Future<User?> login(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;

      if (user != null) {
        final userDoc = _firestore.collection('users').doc(user.uid);

        final snapshot = await userDoc.get();

        /// Si el usuario no existe en Firestore lo creamos
        if (!snapshot.exists) {
          await userDoc.set({
            'email': email,
            'nivel': 'Novato',
            'puntos': 0,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }

      return user;
    } catch (e) {
      debugPrint("Error en login: $e");
      return null;
    }
  }

  // LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
  }
}
