import 'package:flutter/material.dart';
import '../../services/challenge_service.dart';
import '../../services/post_service.dart';
import '../../models/challenge.dart';

/// Página que muestra el reto activo del juego
class ChallengePage extends StatefulWidget {
  const ChallengePage({super.key});

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  /// Servicio que obtiene el reto desde Firestore
  final ChallengeService _challengeService = ChallengeService();

  /// Servicio que gestiona las pistas
  final PostService _postService = PostService();

  /// Future que almacenará el reto activo
  late Future<Challenge?> _challengeFuture;

  @override
  void initState() {
    super.initState();

    /// Al abrir la página consultamos el reto activo
    _challengeFuture = _challengeService.getActiveChallenge();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Puerta del Día")),

      /// FutureBuilder espera la respuesta de Firebase
      body: FutureBuilder<Challenge?>(
        future: _challengeFuture,

        builder: (context, snapshot) {
          /// Mientras se carga el reto
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          /// Si no hay reto disponible
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("No hay retos disponibles"));
          }

          /// Obtenemos el reto
          final challenge = snapshot.data!;

          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  /// Título del reto
                  Text(
                    challenge.title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Descripción del reto
                  Text(
                    challenge.description,
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 30),

                  /// Número de pistas necesarias
                  Text(
                    "Pistas necesarias: ${challenge.requiredClues}",
                    style: const TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 30),

                  /// StreamBuilder escucha cambios en Firestore
                  StreamBuilder<int>(
                    stream: _postService.getPostCount(),

                    builder: (context, snapshot) {
                      /// Mientras carga el contador
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      }

                      final postCount = snapshot.data!;
                      final required = challenge.requiredClues;
                      final progress = postCount > required
                          ? required
                          : postCount;

                      return Column(
                        children: [
                          /// Texto de progreso
                          Text(
                            "Progreso: $progress / $required pistas",
                            style: const TextStyle(fontSize: 16),
                          ),

                          const SizedBox(height: 10),

                          /// Barra de progreso
                          LinearProgressIndicator(
                            value: (postCount / required).clamp(0.0, 1.0),
                            backgroundColor: Colors.grey[300],
                            color: Colors.green,
                          ),

                          const SizedBox(height: 20),

                          /// Si se alcanza el objetivo
                          if (postCount >= required)
                            const Text(
                              "PUERTA DESBLOQUEADA",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
