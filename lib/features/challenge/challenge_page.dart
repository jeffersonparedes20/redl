import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/challenge_service.dart';
import '../../services/post_service.dart';
import '../../models/challenge.dart';

//clase que muestra el reto activo, su progreso y opciones de admin para crear retos y borrar pistas
class ChallengePage extends StatefulWidget {
  const ChallengePage({super.key});

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

// clase de estado del ChallengePage
class _ChallengePageState extends State<ChallengePage> {
  final ChallengeService _challengeService = ChallengeService();
  final PostService _postService = PostService();

  late Future<Challenge?> _challengeFuture;

  // Al iniciar el widget, se carga el reto activo
  @override
  void initState() {
    super.initState();
    _challengeFuture = _challengeService.getActiveChallenge();
  }

  // Popup para crear un nuevo reto, solo disponible para el admin
  void _showCreateChallengeDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final votesController = TextEditingController();

    // Mostramos un diálogo para que el admin edite los detalles del reto
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1F2937),
          title: const Text(
            "Crear reto del día",
            style: TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: Column(
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
                const SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Descripción",
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: votesController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Votos necesarios",
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
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
                await _challengeService.createChallenge(
                  titleController.text,
                  descriptionController.text,
                  int.tryParse(votesController.text) ?? 10,
                );

                setState(() {
                  _challengeFuture = _challengeService.getActiveChallenge();
                });

                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              child: const Text("Crear"),
            ),
          ],
        );
      },
    );
  }

  // Popup confirmar borrar pistas
  void _showDeletePostsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1F2937),
          title: const Text(
            "Borrar pistas",
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            "¿Seguro que deseas borrar todas las pistas publicadas?",
            style: TextStyle(color: Colors.white70),
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
                await _postService.deleteAllPosts();
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              child: const Text("Borrar"),
            ),
          ],
        );
      },
    );
  }

  // widget que muetra el reto activo
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

        // Si no hay reto activo, mostramos un mensaje
        if (!snapshot.hasData || snapshot.data == null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "No hay retos disponibles",
                style: TextStyle(color: Colors.white),
              ),

              if (isAdmin) ...[
                const SizedBox(height: 20),

                //boton admin para crear reto del día
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    _showCreateChallengeDialog();
                  },
                  child: const Text("Crear reto del día"),
                ),

                const SizedBox(height: 10),

                //boton admin para borrar pistas
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    _showDeletePostsDialog();
                  },
                  child: const Text("Borrar pistas"),
                ),
              ],
            ],
          );
        }

        // Si hay reto activo, lo mostramos con su progreso y opciones de admin

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
              // Título del reto
              Text(
                challenge.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 10),

              //Descripción del reto
              Text(
                challenge.description,
                style: const TextStyle(color: Colors.white70),
              ),

              const SizedBox(height: 15),

              // Progreso del reto
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

                      // Si se han alcanzado los votos necesarios, mostramos un mensaje de desbloqueo
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

              // opciones del administrador
              if (isAdmin) ...[
                const SizedBox(height: 20),

                //boton admin para crear reto del día
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    _showCreateChallengeDialog();
                  },
                  child: const Text("Crear reto del día"),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    _showCreateChallengeDialog();
                  },
                  child: const Text("Crear reto del día"),
                ),

                const SizedBox(height: 10),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    _showDeletePostsDialog();
                  },
                  child: const Text("Borrar pistas"),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
