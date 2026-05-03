// Modelo que representa una pista publicada por un usuario
class Post {
  final String id;
  final String userId;
  final String text;
  final int votes;

  // Constructor del objeto Post creado en base a los datos de Firestore
  Post({
    required this.id,
    required this.userId,
    required this.text,
    required this.votes,
  });

  // Convierte datos de Firestore en objeto Post
  factory Post.fromFirestore(Map<String, dynamic> data, String id) {
    return Post(
      id: id,
      userId: data['userId'] ?? '',
      text: data['text'] ?? '',
      votes: data['votes'] ?? 0,
    );
  }
}
