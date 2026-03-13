import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/post_service.dart';

/// Pantalla que permite crear una nueva pista
class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _controller = TextEditingController();
  final PostService _postService = PostService();

  Future<void> _submitPost() async {
    final text = _controller.text.trim();

    if (text.isEmpty) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await _postService.createPost(text, user.uid);

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Publicar pista")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: "Escribe tu pista"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _submitPost,
              child: const Text("Publicar"),
            ),
          ],
        ),
      ),
    );
  }
}
