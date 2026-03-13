import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post.dart';

/// Servicio que gestiona las pistas publicadas
class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Obtiene todas las pistas ordenadas por fecha
  Stream<List<Post>> getPosts() {
    return _firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Post.fromFirestore(doc.data(), doc.id);
          }).toList();
        });
  }

  /// Crear nueva pista
  Future<void> createPost(String text, String userId) async {
    await _firestore.collection('posts').add({
      'userId': userId,
      'text': text,
      'votes': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Contar número total de pistas
  Stream<int> getPostCount() {
    return _firestore
        .collection('posts')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  /// Incrementar votos de una pista
  Future<void> votePost(String postId) async {
    await _firestore.collection('posts').doc(postId).update({
      'votes': FieldValue.increment(1),
    });
  }
}
