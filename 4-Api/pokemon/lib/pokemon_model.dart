import 'dart:convert';
import 'dart:io';
import 'dart:async';

class Pokemon {
  final String name;
  String? imageUrl;
  String? apiname;
  String? levelPokemon;

  int rating = 10;

  Pokemon(this.name);

  Future<void> getImageUrl() async {
    if (imageUrl != null) return;

    final HttpClient http = HttpClient();
    try {
      apiname = name.toLowerCase().trim();
      final uri = Uri.https('pokeapi.co', '/api/v2/pokemon/$apiname');
      final request = await http.getUrl(uri);
      final response = await request.close();
      if (response.statusCode != 200) return;
      final responseBody = await response.transform(utf8.decoder).join();
      final Map<String, dynamic> data = json.decode(responseBody);

        imageUrl = (data['sprites']?['other']?['official-artwork']?['front_default'] as String?)
          ?? (data['sprites']?['front_default'] as String?);

      if (data['types'] is List && data['types'].isNotEmpty) {
        try {
          final types = (data['types'] as List)
              .map((t) => t['type']?['name']?.toString() ?? '')
              .where((s) => s.isNotEmpty)
              .toList();
          levelPokemon = types.join(', ');
        } catch (_) {
          levelPokemon = null;
        }
      }
    } catch (exception) {
      //
    }
  }

  static Future<List<Pokemon>> fetchFirst151() async {
    final List<Pokemon> list = [];
    final HttpClient http = HttpClient();
    try {
      final uri = Uri.https('pokeapi.co', '/api/v2/pokemon', {'limit': '151'});
      final request = await http.getUrl(uri);
      final response = await request.close();
      if (response.statusCode != 200) return list;
      final responseBody = await response.transform(utf8.decoder).join();
      final Map<String, dynamic> data = json.decode(responseBody);
      final results = data['results'] as List<dynamic>?;
      if (results == null) return list;

      final futures = <Future<Pokemon?>>[];
      for (final item in results) {
        futures.add(() async {
          try {
            final name = (item['name'] as String?) ?? '';
            final url = (item['url'] as String?) ?? '';
            final pokemon = Pokemon(name);
            if (url.isNotEmpty) {
              try {
                final detailUri = Uri.parse(url);
                final req = await http.getUrl(detailUri);
                final resp = await req.close();
                if (resp.statusCode == 200) {
                  final body = await resp.transform(utf8.decoder).join();
                  final Map<String, dynamic> det = json.decode(body);
                    pokemon.imageUrl = (det['sprites']?['other']?['official-artwork']?['front_default'] as String?)
                      ?? (det['sprites']?['front_default'] as String?);
                  if (det['types'] is List && det['types'].isNotEmpty) {
                    final types = (det['types'] as List)
                        .map((t) => t['type']?['name']?.toString() ?? '')
                        .where((s) => s.isNotEmpty)
                        .toList();
                    pokemon.levelPokemon = types.join(', ');
                  }
                }
              } catch (_) {
              }
            }
            return pokemon;
          } catch (_) {
            return null;
          }
        }());
      }

      final resultsList = await Future.wait(futures);
      for (final p in resultsList) {
        if (p != null) list.add(p);
      }
    } catch (_) {
    }
    return list;
  }

}
