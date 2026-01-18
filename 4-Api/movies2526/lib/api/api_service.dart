import 'dart:convert'; // Paquete para decodificar JSON
import 'package:movies/api/api.dart'; // Importa las constantes de la API
import 'package:movies/models/movie.dart'; // Importa el modelo Movie
import 'package:http/http.dart' as http; // Paquete para hacer peticiones HTTP
import 'package:movies/models/review.dart'; // Importa el modelo Review
import 'package:movies/models/actor.dart'; // Importa el modelo Actor
import 'package:movies/models/actor_detail.dart'; // Importa el modelo ActorDetail

// CLASE DE SERVICIO API: contiene todos los métodos para hacer peticiones a la API de TMDB
// Todos los métodos son estáticos (static) porque no necesitamos crear instancias de esta clase
class ApiService {
  // TIMEOUT: establece un tiempo máximo de espera para cada petición (10 segundos)
  // Si la petición tarda más de 10 segundos, se cancela automáticamente
  static const Duration _timeout = Duration(seconds: 10);

  // Obtiene las películas mejor calificadas
  // Retorna una lista de Movies o null si hay error
  // async/await: permite esperar a que se complete la petición HTTP
  static Future<List<Movie>?> getTopRatedMovies() async {
    List<Movie> movies = []; // Lista vacía para guardar las películas
    try {
      // Hace una petición GET a la API de películas mejor calificadas
      // http.get() devuelve un Future<Response> (una respuesta futura)
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}movie/top_rated?api_key=${Api.apiKey}&language=en-US&page=1'))
          .timeout(_timeout); // Espera máximo 10 segundos
      
      // jsonDecode: convierte el JSON response en un diccionario (Map)
      var res = jsonDecode(response.body);
      
      // .skip(6): salta los primeros 6 resultados
      // .take(5): obtiene solo los próximos 5 elementos
      res['results'].skip(6).take(5).forEach(
            (m) {
              // Para cada película en la respuesta:
              Movie movie = Movie.fromMap(m); // Convierte el Map a un objeto Movie
              // Solo añade películas que tengan imagen de póster
              if (movie.posterPath.isNotEmpty) {
                movies.add(movie);
              }
            },
          );
      return movies; // Retorna la lista de películas
    } catch (e) {
      // Si hay error (sin internet, timeout, error en API, etc):
      return null; // Retorna null para indicar que hubo un error
    }
  }

  // Obtiene películas de una URL personalizada
  // url: parámetro que contiene el endpoint específico (ej: "popular?api_key=...")
  static Future<List<Movie>?> getCustomMovies(String url) async {
    List<Movie> movies = [];
    try {
      // Hace petición GET a la URL personalizada pasada como parámetro
      http.Response response =
          await http.get(Uri.parse('${Api.baseUrl}movie/$url')).timeout(_timeout);
      var res = jsonDecode(response.body);
      
      // .take(6): obtiene solo los primeros 6 resultados
      res['results'].take(6).forEach(
            (m) {
              Movie movie = Movie.fromMap(m);
              if (movie.posterPath.isNotEmpty) {
                movies.add(movie);
              }
            },
          );
      return movies;
    } catch (e) {
      return null;
    }
  }

  // Busca películas por nombre/título
  // query: el texto que el usuario quiere buscar
  static Future<List<Movie>?> getSearchedMovies(String query) async {
    List<Movie> movies = [];
    try {
      // Petición a endpoint de búsqueda de películas
      // query=$query: incluye el texto de búsqueda en la petición
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}search/movie?api_key=${Api.apiKey}&language=en-US&query=$query&page=1&include_adult=false')).timeout(_timeout);
      var res = jsonDecode(response.body);
      
      // .forEach: itera sobre cada película en los resultados
      res['results'].forEach(
        (m) {
          Movie movie = Movie.fromMap(m);
          if (movie.posterPath.isNotEmpty) {
            movies.add(movie);
          }
        },
      );
      return movies;
    } catch (e) {
      return null;
    }
  }

  // Busca actores por nombre
  // query: el texto para buscar el actor
  static Future<List<Actor>?> getSearchedActors(String query) async {
    List<Actor> actors = [];
    try {
      // Petición a endpoint de búsqueda de personas/actores
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}search/person?api_key=${Api.apiKey}&language=en-US&query=$query&page=1&include_adult=false')).timeout(_timeout);
      var res = jsonDecode(response.body);
      
      res['results'].forEach(
        (a) {
          Actor actor = Actor.fromMap(a);
          if (actor.profilePath.isNotEmpty) { // Solo actores con foto
            actors.add(actor);
          }
        },
      );
      return actors;
    } catch (e) {
      return null;
    }
  }

  // Busca series TV por nombre
  // query: el texto para buscar la serie
  static Future<List<Movie>?> getSearchedSeries(String query) async {
    List<Movie> series = [];
    try {
      // Petición a endpoint de búsqueda de series TV
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}search/tv?api_key=${Api.apiKey}&language=en-US&query=$query&page=1&include_adult=false')).timeout(_timeout);
      var res = jsonDecode(response.body);
      
      res['results'].forEach(
        (s) {
          Movie serie = Movie.fromMap(s); // Las series se guardan como Movie también
          if (serie.posterPath.isNotEmpty) {
            series.add(serie);
          }
        },
      );
      return series;
    } catch (e) {
      return null;
    }
  }

  // Obtiene las reseñas de una película
  // movieId: el ID único de la película
  static Future<List<Review>?> getMovieReviews(int movieId) async {
    List<Review> reviews = [];
    try {
      // Petición para obtener reseñas de una película específica
      http.Response response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/movie/$movieId/reviews?api_key=${Api.apiKey}&language=en-US&page=1')).timeout(_timeout);
      var res = jsonDecode(response.body);
      
      res['results'].forEach(
        (r) {
          // Crea un nuevo objeto Review con los datos
          reviews.add(
            Review(
                author: r['author'], // Quien escribió la reseña
                comment: r['content'], // El contenido de la reseña
                rating: r['author_details']['rating']), // La calificación dada
          );
        },
      );
      return reviews;
    } catch (e) {
      return null;
    }
  }

  // Obtiene los actores más populares
  static Future<List<Actor>?> getPopularActors() async {
    List<Actor> actors = [];
    try {
      // Petición a endpoint de actores populares
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}person/popular?api_key=${Api.apiKey}&language=en-US&page=1')).timeout(_timeout);
      var res = jsonDecode(response.body);
      
      // .skip(0).take(10): obtiene los primeros 10 actores
      res['results'].skip(0).take(10).forEach(
            (a) {
              Actor actor = Actor.fromMap(a);
              if (actor.profilePath.isNotEmpty) {
                actors.add(actor);
              }
            },
          );
      return actors;
    } catch (e) {
      return null;
    }
  }

  // Obtiene los actores en tendencia de la semana
  // page: número de página para paginación
  static Future<List<Actor>?> getTrendingActors(int page) async {
    List<Actor> actors = [];
    try {
      // Petición a endpoint de actores en tendencia
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}trending/person/week?api_key=${Api.apiKey}&language=en-US&page=$page')).timeout(_timeout);
      var res = jsonDecode(response.body);
      
      res['results'].forEach(
            (a) {
              Actor actor = Actor.fromMap(a);
              if (actor.profilePath.isNotEmpty) {
                actors.add(actor);
              }
            },
          );
      return actors;
    } catch (e) {
      return null;
    }
  }

  // Obtiene el elenco (cast) de una película
  // movieId: el ID de la película para obtener su elenco
  static Future<List<Actor>?> getMovieCast(int movieId) async {
    List<Actor> actors = [];
    try {
      // Petición para obtener los créditos/elenco de una película
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}movie/$movieId/credits?api_key=${Api.apiKey}&language=en-US')).timeout(_timeout);
      var res = jsonDecode(response.body);
      
      // .take(10): obtiene solo los primeros 10 actores del elenco
      res['cast'].take(10).forEach(
            (a) {
              Actor actor = Actor.fromMap(a);
              if (actor.profilePath.isNotEmpty) {
                actors.add(actor);
              }
            },
          );
      return actors;
    } catch (e) {
      return null;
    }
  }

  // Obtiene información detallada de un actor
  // actorId: el ID del actor para obtener sus detalles
  static Future<ActorDetail?> getActorDetail(int actorId) async {
    try {
      // Petición para obtener información completa del actor
      // append_to_response=movie_credits: incluye también las películas del actor
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}person/$actorId?api_key=${Api.apiKey}&language=en-US&append_to_response=movie_credits')).timeout(_timeout);
      var res = jsonDecode(response.body);
      return ActorDetail.fromMap(res); // Convierte la respuesta a objeto ActorDetail
    } catch (e) {
      return null;
    }
  }

  // Obtiene las series mejor calificadas
  static Future<List<Movie>?> getTopRatedSeries() async {
    List<Movie> series = [];
    try {
      // Petición a endpoint de series mejor calificadas
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}tv/top_rated?api_key=${Api.apiKey}&language=en-US&page=1')).timeout(_timeout);
      var res = jsonDecode(response.body);
      
      res['results'].skip(0).take(10).forEach(
            (s) {
              Movie serie = Movie.fromMap(s);
              if (serie.posterPath.isNotEmpty) {
                series.add(serie);
              }
            },
          );
      return series;
    } catch (e) {
      return null;
    }
  }

  // Obtiene las series populares con paginación
  // page: número de página para obtener diferentes resultados
  static Future<List<Movie>?> getPopularSeries(int page) async {
    List<Movie> series = [];
    try {
      // Petición a endpoint de series populares
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}tv/popular?api_key=${Api.apiKey}&language=en-US&page=$page')).timeout(_timeout);
      var res = jsonDecode(response.body);
      
      res['results'].forEach(
            (s) {
              Movie serie = Movie.fromMap(s);
              if (serie.posterPath.isNotEmpty) {
                series.add(serie);
              }
            },
          );
      return series;
    } catch (e) {
      return null;
    }
  }

}
