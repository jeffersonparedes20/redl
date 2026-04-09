import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/post_service.dart';

/// Widget que muestra el feed de pistas (sin Scaffold)
class PostsFeed extends StatelessWidget {
  const PostsFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .limit(20)
          .snapshots(),
      builder: (context, snapshot) {
        // ⏳ Cargando
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final posts = snapshot.data!.docs;

        // 📭 Sin posts
        if (posts.isEmpty) {
          return const Center(
            child: Text(
              "No hay pistas todavía",
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        // 📜 Lista de posts
        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final postDoc = posts[index];
            final data = postDoc.data() as Map<String, dynamic>;
            final userId = FirebaseAuth.instance.currentUser!.uid;

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1F2937),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.redAccent.withValues(alpha: 0.4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 👤 Usuario
                  Row(
                    children: [
                      const Icon(Icons.person, size: 14, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        data['userEmail'] ?? "Anónimo",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  /// 💬 Texto
                  Text(
                    data['text'] ?? "",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// 👍 Votos + botón dinámico
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Contador votos
                      Row(
                        children: [
                          const Icon(
                            Icons.thumb_up,
                            size: 16,
                            color: Colors.greenAccent,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "${data['votes'] ?? 0}",
                            style: const TextStyle(
                              color: Colors.greenAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      /// Botón con estado (ya votado o no)
                      StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('posts')
                            .doc(postDoc.id)
                            .collection('votes')
                            .doc(userId)
                            .snapshots(),
                        builder: (context, voteSnapshot) {
                          final hasVoted = voteSnapshot.data?.exists ?? false;

                          return IconButton(
                            icon: Icon(
                              hasVoted
                                  ? Icons.thumb_up
                                  : Icons.thumb_up_outlined,
                              color: hasVoted
                                  ? Colors.greenAccent
                                  : Colors.white,
                            ),
                            onPressed: () {
                              PostService().votePost(postDoc.id, userId);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
