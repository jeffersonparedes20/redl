// Modelo que representa un reto del juego
class Challenge {
  // ID del documento en Firestore
  final String id;

  // Título del reto
  final String title;

  // Descripción del reto
  final String description;

  // Número de pistas necesarias para completar el reto
  final int requiredClues;

  // Constructor del objeto Challenge creado en base a los datos de Firestore
  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.requiredClues,
  });

  // "Factory" es un constructor que convierte datos de Firestore en un objeto Challenge
  factory Challenge.fromFirestore(Map<String, dynamic> data, String id) {
    return Challenge(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      requiredClues: data['requiredClues'] ?? 0,
    );
  }
}
