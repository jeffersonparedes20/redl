import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/post_service.dart';
import '../../widgets/animated_redl_background.dart';

// clase para crear un nuevo post
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

  // widget para crear un nuevo post con fondo animado y estilo REDL
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Publicar pista")),

      // Fondo animado
      body: AnimatedRedlBackground(
        child: Center(
          child: Container(
            width: 420,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(24),

            decoration: BoxDecoration(
              color: const Color(0xFF111827).withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.redAccent.withValues(alpha: 0.45),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.redAccent.withValues(alpha: 0.18),
                  blurRadius: 14,
                  spreadRadius: 1,
                ),
              ],
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "NUEVA PISTA",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 24),

                //Campo de texto para la pista
                TextField(
                  controller: _controller,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Escribe tu pista",
                    labelStyle: const TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.redAccent.withValues(alpha: 0.45),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.redAccent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Botón publicar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _submitPost,
                    child: const Text(
                      "PUBLICAR",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
