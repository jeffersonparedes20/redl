import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/challenge.dart';
import 'package:flutter/foundation.dart';

/// Servicio encargado de comunicarse con Firestore para obtener los retos del juego

class ChallengeService {
  /// Instancia de Firestore para conectarse a la base de datos y realizar consultas
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Obtiene el reto activo del día
  Future<Challenge?> getActiveChallenge() async {
    try {
      /// Consulta la colección "challenges" a la base de datos
      final query = await _firestore
          .collection('challenges')
          .where('status', isEqualTo: 'active')
          .limit(1) // Solo queremos un reto activo
          .get();

      /// Si no hay retos activos devolvemos null
      if (query.docs.isEmpty) {
        return null;
      }

      /// Tomamos el primer documento encontrado
      final doc = query.docs.first;

      /// Convertimos los datos de Firestore
      /// en un objeto Challenge
      return Challenge.fromFirestore(doc.data(), doc.id);
    } catch (e) {
      /// En caso de error lo mostramos en consola
      debugPrint("Error obteniendo challenge: $e");
      return null;
    }
  }
}
