import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/challenge.dart';
import 'package:flutter/foundation.dart';

// Servicio encargado de comunicarse con Firestore para gestionar retos
class ChallengeService {
  // Instancia de Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obtiene el reto activo del día
  Future<Challenge?> getActiveChallenge() async {
    try {
      final query = await _firestore
          .collection('challenges')
          .where('status', isEqualTo: 'active')
          .limit(1)
          .get();

      // Si no hay retos activos devolvemos null
      if (query.docs.isEmpty) {
        return null;
      }

      final doc = query.docs.first;

      return Challenge.fromFirestore(doc.data(), doc.id);
    } catch (e) {
      debugPrint("Error obteniendo challenge: $e");
      return null;
    }
  }

  // Crear nuevo reto (solo admin)
  Future<void> createChallenge(
    String title,
    String description,
    int requiredClues,
  ) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      // Verificar usuario logueado y permisos de administrador
      if (user == null) {
        throw Exception("Usuario no autenticado");
      }

      final email = user.email?.trim().toLowerCase();

      //Solo administrador con email específico puede crear retos
      if (email != "admin@redl.com") {
        throw Exception("No autorizado");
      }

      // Buscar retos activos
      final activeChallenges = await _firestore
          .collection('challenges')
          .where('status', isEqualTo: 'active')
          .get();

      // Desactivar retos anteriores
      for (var doc in activeChallenges.docs) {
        await doc.reference.update({'status': 'inactive'});
      }

      // Crear nuevo reto activo
      await _firestore.collection('challenges').add({
        'title': title,
        'description': description,
        'requiredClues': requiredClues,
        'status': 'active',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Si llegamos aquí, el reto se creó correctamente
      debugPrint("Challenge creado correctamente");
    } catch (e) {
      debugPrint("Error creando challenge: $e");
    }
  }
}
