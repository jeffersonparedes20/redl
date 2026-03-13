import 'package:flutter/material.dart';
import '../../services/post_service.dart';
import '../../models/post.dart';
import 'create_post_page.dart';

/// Pantalla que muestra el feed de pistas de la comunidad
class PostsPage extends StatelessWidget {
  final PostService _postService = PostService();

  PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pistas de la comunidad")),

      /// Botón flotante para crear una nueva pista
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreatePostPage()),
          );
        },
        child: const Icon(Icons.add),
      ),

      /// StreamBuilder escucha cambios en Firestore
      body: StreamBuilder<List<Post>>(
        stream: _postService.getPosts(),

        builder: (context, snapshot) {
          /// Mientras se cargan los datos
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final posts = snapshot.data!;

          /// Si no hay pistas
          if (posts.isEmpty) {
            return const Center(child: Text("No hay pistas todavía"));
          }

          /// Lista de pistas
          return ListView.builder(
            itemCount: posts.length,

            itemBuilder: (context, index) {
              final post = posts[index];

              return Card(
                margin: const EdgeInsets.all(10),

                child: ListTile(
                  title: Text(post.text),
                  subtitle: Text("Votos: ${post.votes}"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
