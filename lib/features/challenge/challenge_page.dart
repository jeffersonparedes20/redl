import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/challenge_service.dart';
import '../../services/post_service.dart';
import '../../models/challenge.dart';

/// Widget que muestra el reto activo
class ChallengePage extends StatefulWidget {
  const ChallengePage({super.key});

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  final ChallengeService _challengeService = ChallengeService();
  final PostService _postService = PostService();

  late Future<Challenge?> _challengeFuture;

  @override
  void initState() {
    super.initState();
    _challengeFuture = _challengeService.getActiveChallenge();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isAdmin = user?.email == "admin@redl.com";

    return FutureBuilder<Challenge?>(
      future: _challengeFuture,
      builder: (context, snapshot) {
        /// ⏳ Cargando
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        /// ❌ Sin reto
        if (!snapshot.hasData || snapshot.data == null) {
          return Column(
            children: [
              const Text(
                "No hay retos disponibles",
                style: TextStyle(color: Colors.white),
              ),

              /// 👑 Botón admin incluso sin reto
              if (isAdmin) ...[
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                  onPressed: () {
                    ChallengeService().createChallenge(
                      "Nuevo reto",
                      "Descripción del reto",
                      10,
                    );
                  },
                  child: const Text("Crear reto del día"),
                ),
              ],
            ],
          );
        }

        final challenge = snapshot.data!;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 10),

          decoration: BoxDecoration(
            color: const Color(0xFF1F2937),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.redAccent.withValues(alpha: 0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.redAccent.withValues(alpha: 0.2),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔐 Título
              Text(
                challenge.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 10),

              /// 📄 Descripción
              Text(
                challenge.description,
                style: const TextStyle(color: Colors.white70),
              ),

              const SizedBox(height: 15),

              /// 📊 Progreso basado en votos
              StreamBuilder<int>(
                stream: _postService.getTotalVotes(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  final totalVotes = snapshot.data!;
                  final required = challenge.requiredClues;

                  final progress = totalVotes > required
                      ? required
                      : totalVotes;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Texto progreso
                      Text(
                        "Progreso: $progress / $required votos",
                        style: const TextStyle(color: Colors.white),
                      ),

                      const SizedBox(height: 8),

                      /// Barra progreso
                      LinearProgressIndicator(
                        value: (totalVotes / required).clamp(0.0, 1.0),
                        backgroundColor: Colors.grey.shade800,
                        color: Colors.greenAccent,
                        minHeight: 8,
                      ),

                      const SizedBox(height: 10),

                      /// 🔓 Estado
                      if (totalVotes >= required)
                        const Text(
                          "🔓 PUERTA DESBLOQUEADA",
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  );
                },
              ),

              /// 👑 Botón solo admin
              if (isAdmin) ...[
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                  onPressed: () {
                    ChallengeService().createChallenge(
                      "Nuevo reto",
                      "Descripción del reto",
                      10,
                    );
                  },
                  child: const Text("Crear reto del día"),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
