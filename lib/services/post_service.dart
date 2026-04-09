import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/post.dart';
import 'user_service.dart';

/// Servicio que gestiona las pistas publicadas
class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService _userService = UserService();

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

  // Crear una nueva pista
  Future<void> createPost(String text, String userId) async {
    if (text.trim().isEmpty) return;
    await _firestore.collection('posts').add({
      'userId': userId,
      'userEmail': FirebaseAuth.instance.currentUser?.email,
      'text': text,
      'votes': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });

    /// Añadimos puntos al usuario
    await _userService.addPoints(userId);
  }

  /// Contar número total de pistas
  Stream<int> getPostCount() {
    return _firestore
        .collection('posts')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  /// Incrementar votos de una pista
  Future<void> votePost(String postId, String userId) async {
    final voteRef = _firestore
        .collection('posts')
        .doc(postId)
        .collection('votes')
        .doc(userId);

    final voteDoc = await voteRef.get();

    //  Verificar si el usuario ya ha votado
    if (voteDoc.exists) return;

    // Registrar voto
    await voteRef.set({'voted': true});

    //  Incrementar contador
    await _firestore.collection('posts').doc(postId).update({
      'votes': FieldValue.increment(1),
    });
  }

  // Obtener total de votos en todas las pistas
  Stream<int> getTotalVotes() {
    return _firestore.collection('posts').snapshots().map((snapshot) {
      int total = 0;
      for (var doc in snapshot.docs) {
        total += (doc['votes'] ?? 0) as int;
      }
      return total;
    });
  }
}
