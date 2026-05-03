import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/challenge_service.dart';
import '../../services/post_service.dart';
import '../../models/challenge.dart';

// clase principal de la pantalla de retos
class ChallengePage extends StatefulWidget {
  const ChallengePage({super.key});

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

// clase que maneja el estado de la pantalla de retos
class _ChallengePageState extends State<ChallengePage> {
  final ChallengeService _challengeService = ChallengeService();
  final PostService _postService = PostService();

  late Future<Challenge?> _challengeFuture;

  @override
  void initState() {
    super.initState();
    _challengeFuture = _challengeService.getActiveChallenge();
  }

  //caja de dialogo para crear un nuevo reto, solo visible para el admin
  Future<void> _showCreateChallengeDialog() async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final cluesController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1F2937),
          title: const Text(
            "Crear reto",
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Título",
                  labelStyle: TextStyle(color: Colors.white70),
                ),
              ),
              TextField(
                controller: descriptionController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Descripción",
                  labelStyle: TextStyle(color: Colors.white70),
                ),
              ),
              TextField(
                controller: cluesController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Votos necesarios",
                  labelStyle: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                final title = titleController.text.trim();
                final description = descriptionController.text.trim();
                final clues = int.tryParse(cluesController.text.trim()) ?? 0;

                if (title.isEmpty || description.isEmpty || clues <= 0) {
                  return;
                }

                await _challengeService.createChallenge(
                  title,
                  description,
                  clues,
                );

                if (!mounted) return;

                Navigator.pop(context);

                setState(() {
                  _challengeFuture = _challengeService.getActiveChallenge();
                });

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("Reto creado")));
              },
              child: const Text("Crear"),
            ),
          ],
        );
      },
    );
  }

  // botones de admin para crear retos y borrar pistas
  Widget _adminButtons() {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: _showCreateChallengeDialog,
          child: const Text("Crear reto del día"),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: () async {
            await _postService.deleteAllPosts();

            if (!mounted) return;

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Pistas eliminadas")));
          },
          child: const Text("Borrar pistas"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isAdmin = user?.email == "admin@redl.com";

    return FutureBuilder<Challenge?>(
      future: _challengeFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Si no hay retos activos, muestra un mensaje
        if (!snapshot.hasData || snapshot.data == null) {
          return Column(
            children: [
              const Text(
                "No hay retos disponibles",
                style: TextStyle(color: Colors.white),
              ),
              if (isAdmin) ...[const SizedBox(height: 20), _adminButtons()],
            ],
          );
        }

        final challenge = snapshot.data!;

        // Muestra el reto activo con su progreso y opciones de admin
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
              Text(
                challenge.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                challenge.description,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 15),

              // StreamBuilder para mostrar el progreso del reto en tiempo real, basado en el número de votos recibidos
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
                      Text(
                        "Progreso: $progress / $required votos",
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: (totalVotes / required).clamp(0.0, 1.0),
                        backgroundColor: Colors.grey.shade800,
                        color: Colors.greenAccent,
                        minHeight: 8,
                      ),
                      const SizedBox(height: 10),
                      if (totalVotes >= required)
                        const Text(
                          // Si el número de votos es igual o mayor al requerido, muestra un mensaje indicando que la puerta está desbloqueada
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

              // si el usuario es admin, muestra los botones para crear retos y borrar pistas
              if (isAdmin) ...[const SizedBox(height: 20), _adminButtons()],
            ],
          ),
        );
      },
    );
  }
}
