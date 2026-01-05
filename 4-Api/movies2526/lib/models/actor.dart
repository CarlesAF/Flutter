import 'dart:convert';

class Actor {
  int id;
  String name;
  String profilePath;
  String knownForDepartment;
  double popularity;
  List<String> knownFor;

  Actor({
    required this.id,
    required this.name,
    required this.profilePath,
    required this.knownForDepartment,
    required this.popularity,
    required this.knownFor,
  });

  factory Actor.fromMap(Map<String, dynamic> map) {
    List<String> knownFor = [];
    if (map['known_for'] != null) {
      knownFor = List<String>.from(
        (map['known_for'] as List).map(
          (item) => item['title'] ?? item['name'] ?? 'Unknown',
        ),
      );
    }

    return Actor(
      id: map['id'] as int,
      name: map['name'] ?? 'Unknown',
      profilePath: map['profile_path'] ?? '',
      knownForDepartment: map['known_for_department'] ?? 'Acting',
      popularity: (map['popularity'] as num?)?.toDouble() ?? 0.0,
      knownFor: knownFor,
    );
  }

  factory Actor.fromJson(String source) => Actor.fromMap(json.decode(source));
}
