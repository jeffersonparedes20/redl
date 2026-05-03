import 'package:flutter/material.dart';
import '../../services/post_service.dart';
import '../../models/post.dart';
import 'create_post_page.dart';
import '../../widgets/animated_redl_background.dart';

//Pantalla que muestra el feed de pistas de la comunidad
class PostsPage extends StatelessWidget {
  final PostService _postService = PostService();

  PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pistas de la comunidad")),

      //Botón para crear pista
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreatePostPage()),
          );
        },
        child: const Icon(Icons.add),
      ),

      //Fondo animado
      body: AnimatedRedlBackground(
        child: StreamBuilder<List<Post>>(
          stream: _postService.getPosts(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final posts = snapshot.data!;

            // caja de mensaje si no hay pistas
            if (posts.isEmpty) {
              return const Center(
                child: Text(
                  "No hay pistas todavía",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              );
            }

            //caja que muestra la lista de pistas
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color: const Color(0xFF111827).withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.redAccent.withValues(alpha: 0.45),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent.withValues(alpha: 0.18),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Texto del post
                      Text(
                        post.text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Contador de votos
                      Text(
                        "👍 Votos: ${post.votes}",
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
