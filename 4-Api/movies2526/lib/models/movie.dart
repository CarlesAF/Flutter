import 'dart:convert';

// Representa una película o serie TV en la aplicación
// Contiene todas las propiedades que recibimos de la API de TMDB
class Movie {
  int id; // ID único de la película en la base de datos de TMDB
  String title; // Nombre/título de la película
  String posterPath; // Ruta de la imagen del póster (se concatena con imageBaseUrl)
  String backdropPath; // Ruta de la imagen de fondo/banner de la película
  String overview; // Descripción/sinopsis de la película
  String releaseDate; // Fecha de lanzamiento (formato: YYYY-MM-DD)
  double voteAverage; // Calificación promedio de la película (0.0 a 10.0)
  List<int> genreIds; // Lista de IDs de géneros a los que pertenece la película
  
  // CONSTRUCTOR: inicializa todas las propiedades de la película
  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.backdropPath,
    required this.overview,
    required this.releaseDate,
    required this.voteAverage,
    required this.genreIds,
  });

  // Convierte un diccionario (Map) JSON en un objeto Movie
  // Se usa cuando recibimos datos de la API (que vienen como JSON)
  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'] as int, // Obtiene el ID del diccionario
      // Para el título: intenta obtener 'title' (películas) o 'name' (series), sino usa vacío
      title: map['title'] ?? map['name'] ?? '',
      // Ruta del póster: si no existe, usa string vacío
      posterPath: map['poster_path'] ?? '',
      // Ruta del backdrop: si no existe, usa string vacío
      backdropPath: map['backdrop_path'] ?? '',
      // Sinopsis: si no existe, usa string vacío
      overview: map['overview'] ?? '',
      // Fecha: intenta 'release_date' (películas) o 'first_air_date' (series)
      releaseDate: map['release_date'] ?? map['first_air_date'] ?? '',
      // Convierte el voteAverage a double (número decimal) o 0.0 si no existe
      voteAverage: map['vote_average']?.toDouble() ?? 0.0,
      // Convierte la lista de IDs a List<int>, o lista vacía si no existe
      genreIds: List<int>.from(map['genre_ids'] ?? []),
    );
  }

  // Convierte un JSON string en un objeto Movie
  // Primero decodifica el string JSON a un Map, luego usa fromMap()
  factory Movie.fromJson(String source) => Movie.fromMap(json.decode(source));
}
