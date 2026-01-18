// Representa una reseña o comentario de una película
class Review {
  String author; // Nombre de la persona que escribió la reseña
  String comment; // Contenido/texto de la reseña
  double rating; // Calificación dada por el autor (0.0 a 10.0)
  
  // CONSTRUCTOR: inicializa los datos de la reseña
  Review({
    required this.author,
    required this.comment,
    required this.rating,
  });

  // Convierte un diccionario (Map) JSON en un objeto Review
  // Se usa cuando recibimos las reseñas de la API
  factory Review.fromJson(Map<String, dynamic> map) {
    return Review(
      author: map['name'] ?? '', // Nombre del autor o string vacío si no existe
      comment: map['content'] ?? '', // Contenido de la reseña o string vacío
      // Convierte la calificación a double (número decimal) o 0.0 si no existe
      rating: map['rating']?.toDouble() ?? 0.0,
    );
  }
}
