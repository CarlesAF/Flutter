import 'dart:convert';

class ActorDetail {
  int id;
  String name;
  String profilePath;
  String biography;
  double popularity;
  String placeOfBirth;
  String birthday;
  List<MovieInCast> filmography;

  ActorDetail({
    required this.id,
    required this.name,
    required this.profilePath,
    required this.biography,
    required this.popularity,
    required this.placeOfBirth,
    required this.birthday,
    required this.filmography,
  });

  factory ActorDetail.fromMap(Map<String, dynamic> map) {
    List<MovieInCast> filmography = [];
    if (map['movie_credits'] != null && map['movie_credits']['cast'] != null) {
      filmography = List<MovieInCast>.from(
        (map['movie_credits']['cast'] as List)
            .take(20)
            .map((item) => MovieInCast.fromMap(item)),
      );
      // Ordenar películas por rating de manera descendente
      filmography.sort((a, b) => b.voteAverage.compareTo(a.voteAverage));
    }

    return ActorDetail(
      id: map['id'] as int,
      name: map['name'] ?? 'Unknown',
      profilePath: map['profile_path'] ?? '',
      biography: map['biography'] ?? 'No biography available',
      popularity: (map['popularity'] as num?)?.toDouble() ?? 0.0,
      placeOfBirth: map['place_of_birth'] ?? 'Unknown',
      birthday: map['birthday'] ?? 'Unknown',
      filmography: filmography,
    );
  }

  factory ActorDetail.fromJson(String source) =>
      ActorDetail.fromMap(json.decode(source));
}

class MovieInCast {
  int id;
  String title;
  String posterPath;
  String character;
  double voteAverage;
  String releaseDate;

  MovieInCast({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.character,
    required this.voteAverage,
    required this.releaseDate,
  });

  factory MovieInCast.fromMap(Map<String, dynamic> map) {
    return MovieInCast(
      id: map['id'] as int,
      title: map['title'] ?? 'Unknown',
      posterPath: map['poster_path'] ?? '',
      character: map['character'] ?? 'Unknown',
      voteAverage: (map['vote_average'] as num?)?.toDouble() ?? 0.0,
      releaseDate: map['release_date'] ?? 'Unknown',
    );
  }

  factory MovieInCast.fromJson(String source) =>
      MovieInCast.fromMap(json.decode(source));
}
