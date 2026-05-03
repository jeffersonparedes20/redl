import 'package:cloud_firestore/cloud_firestore.dart';

// Servicio que gestiona datos del usuario
class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Añade puntos al usuario y actualiza su nivel
  Future<void> addPoints(String userId) async {
    final userRef = _firestore.collection('users').doc(userId);

    final snapshot = await userRef.get();

    // Si el usuario no existe, no hacemos nada
    if (!snapshot.exists) return;

    final data = snapshot.data()!;

    int points = data['puntos'] ?? 0;

    points = points + 1;

    String level = _calculateLevel(points);

    // Actualizamos los puntos y el nivel en Firestore
    await userRef.update({'puntos': points, 'nivel': level});
  }

  // Calcula el nivel según los puntos
  String _calculateLevel(int points) {
    if (points <= 5) {
      return "Novato";
    }

    if (points <= 10) {
      return "Explorador";
    }

    if (points <= 15) {
      return "Agente";
    }

    return "Supervisor";
  }
}
