import 'dart:convert';
import 'package:movies/api/api.dart';
import 'package:movies/models/movie.dart';
import 'package:http/http.dart' as http;
import 'package:movies/models/review.dart';
import 'package:movies/models/actor.dart';
import 'package:movies/models/actor_detail.dart';

class ApiService {
  static const Duration _timeout = Duration(seconds: 10);

  static Future<List<Movie>?> getTopRatedMovies() async {
    List<Movie> movies = [];
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}movie/top_rated?api_key=${Api.apiKey}&language=en-US&page=1')).timeout(_timeout);
      var res = jsonDecode(response.body);
      res['results'].skip(6).take(5).forEach(
            (m) {
              Movie movie = Movie.fromMap(m);
              if (movie.posterPath.isNotEmpty) {
                movies.add(movie);
              }
            },
          );
      return movies;
    } catch (e) {
      print('Error in getTopRatedMovies: $e');
      return null;
    }
  }

  static Future<List<Movie>?> getCustomMovies(String url) async {
    List<Movie> movies = [];
    try {
      http.Response response =
          await http.get(Uri.parse('${Api.baseUrl}movie/$url')).timeout(_timeout);
      var res = jsonDecode(response.body);
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
      print('Error in getCustomMovies: $e');
      return null;
    }
  }

  static Future<List<Movie>?> getSearchedMovies(String query) async {
    List<Movie> movies = [];
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}search/movie?api_key=${Api.apiKey}&language=en-US&query=$query&page=1&include_adult=false')).timeout(_timeout);
      var res = jsonDecode(response.body);
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
      print('Error in getSearchedMovies: $e');
      return null;
    }
  }

  static Future<List<Actor>?> getSearchedActors(String query) async {
    List<Actor> actors = [];
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}search/person?api_key=${Api.apiKey}&language=en-US&query=$query&page=1&include_adult=false')).timeout(_timeout);
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
      print('Error in getSearchedActors: $e');
      return null;
    }
  }

  static Future<List<Movie>?> getSearchedSeries(String query) async {
    List<Movie> series = [];
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}search/tv?api_key=${Api.apiKey}&language=en-US&query=$query&page=1&include_adult=false')).timeout(_timeout);
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
      print('Error in getSearchedSeries: $e');
      return null;
    }
  }

  static Future<List<Review>?> getMovieReviews(int movieId) async {
    List<Review> reviews = [];
    try {
      http.Response response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/movie/$movieId/reviews?api_key=${Api.apiKey}&language=en-US&page=1')).timeout(_timeout);
      var res = jsonDecode(response.body);
      res['results'].forEach(
        (r) {
          reviews.add(
            Review(
                author: r['author'],
                comment: r['content'],
                rating: r['author_details']['rating']),
          );
        },
      );
      return reviews;
    } catch (e) {
      print('Error in getMovieReviews: $e');
      return null;
    }
  }

  static Future<List<Actor>?> getPopularActors() async {
    List<Actor> actors = [];
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}person/popular?api_key=${Api.apiKey}&language=en-US&page=1')).timeout(_timeout);
      var res = jsonDecode(response.body);
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
      print('Error in getPopularActors: $e');
      return null;
    }
  }

  static Future<List<Actor>?> getTrendingActors(int page) async {
    List<Actor> actors = [];
    try {
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
      print('Error in getTrendingActors: $e');
      return null;
    }
  }

  static Future<List<Actor>?> getMovieCast(int movieId) async {
    List<Actor> actors = [];
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}movie/$movieId/credits?api_key=${Api.apiKey}&language=en-US')).timeout(_timeout);
      var res = jsonDecode(response.body);
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
      print('Error in getMovieCast: $e');
      return null;
    }
  }

  static Future<ActorDetail?> getActorDetail(int actorId) async {
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}person/$actorId?api_key=${Api.apiKey}&language=en-US&append_to_response=movie_credits')).timeout(_timeout);
      var res = jsonDecode(response.body);
      return ActorDetail.fromMap(res);
    } catch (e) {
      print('Error in getActorDetail: $e');
      return null;
    }
  }

  static Future<List<Movie>?> getTopRatedSeries() async {
    List<Movie> series = [];
    try {
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
      print('Error in getTopRatedSeries: $e');
      return null;
    }
  }

  static Future<List<Movie>?> getPopularSeries(int page) async {
    List<Movie> series = [];
    try {
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
      print('Error in getPopularSeries: $e');
      return null;
    }
  }

}
