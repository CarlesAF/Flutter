import 'dart:convert';

// Representa un actor/actriz en la aplicación
// Contiene información básica del actor obtenida de la API de TMDB
class Actor {
  int id; // ID único del actor en TMDB
  String name; // Nombre del actor
  String profilePath; // Ruta de la foto de perfil del actor
  String knownForDepartment; // Departamento por el que es conocido (ej: "Acting", "Directing")
  double popularity; // Puntuación de popularidad del actor
  List<String> knownFor; // Lista de títulos de películas/series por las que es conocido

  // CONSTRUCTOR: inicializa todas las propiedades del actor
  Actor({
    required this.id,
    required this.name,
    required this.profilePath,
    required this.knownForDepartment,
    required this.popularity,
    required this.knownFor,
  });

  // Convierte un diccionario (Map) JSON en un objeto Actor
  factory Actor.fromMap(Map<String, dynamic> map) {
    // PROCESA LA LISTA "knownFor": convierte la información de películas en una lista de títulos
    List<String> knownFor = [];
    if (map['known_for'] != null) {
      // Mapea cada elemento de la lista known_for
      knownFor = List<String>.from(
        (map['known_for'] as List).map(
          // Para cada película/serie, obtiene su título ('title' o 'name') o 'Unknown' si no existe
          (item) => item['title'] ?? item['name'] ?? 'Unknown',
        ),
      );
    }

    // RETORNA un nuevo objeto Actor con los datos del Map
    return Actor(
      id: map['id'] as int, // ID del actor
      name: map['name'] ?? 'Unknown', // Nombre o 'Unknown' si no existe
      profilePath: map['profile_path'] ?? '', // Ruta foto o string vacío
      knownForDepartment: map['known_for_department'] ?? 'Acting', // Departamento o 'Acting' por defecto
      // Convierte popularity a double, o 0.0 si no existe
      popularity: (map['popularity'] as num?)?.toDouble() ?? 0.0,
      knownFor: knownFor, // Lista procesada de películas/series
    );
  }

  // Convierte un JSON string en un objeto Actor
  factory Actor.fromJson(String source) => Actor.fromMap(json.decode(source));
}
