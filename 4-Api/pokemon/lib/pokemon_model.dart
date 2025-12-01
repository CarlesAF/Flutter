// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';
import 'dart:async';

/// Modelo de dominio que representa un Pokémon simple con nombre,
/// URL de imagen (cuando esté disponible), tipos (levelPokemon) y un rating.
class Pokemon {
  final String name;
  String? imageUrl;
  String? apiname;
  String? levelPokemon;

  // Valor de rating por defecto
  int rating = 10;

  Pokemon(this.name);

  /// Obtiene la URL de la imagen desde la PokeAPI para este Pokémon.
  ///
  /// Prefiere la imagen `official-artwork` cuando está disponible y si no
  /// existe, cae de vuelta a `sprites.front_default`.
  Future<void> getImageUrl() async {
    if (imageUrl != null) return;

    final HttpClient http = HttpClient();
    try {
      // Normalizar el nombre para la ruta de la API
      apiname = name.toLowerCase().trim();
      final uri = Uri.https('pokeapi.co', '/api/v2/pokemon/$apiname');
      final request = await http.getUrl(uri);
      final response = await request.close();
      if (response.statusCode != 200) return;
      final responseBody = await response.transform(utf8.decoder).join();
      final Map<String, dynamic> data = json.decode(responseBody);

        // Preferir la artwork oficial si existe, sino tomar el sprite
        imageUrl = (data['sprites']?['other']?['official-artwork']?['front_default'] as String?)
          ?? (data['sprites']?['front_default'] as String?);

      // Guardar los tipos como un string separado por comas en levelPokemon
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
      // Ignorar errores de red/parseo por ahora; la UI puede manejar falta de imagen
    }
  }

  /// Recupera los primeros 151 Pokémon desde la PokeAPI.
  ///
  /// Devuelve una lista de instancias `Pokemon`. Para cada elemento
  /// intenta cargar la URL de imagen y los tipos, en paralelo.
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

      // Construimos una lista de futures para pedir los detalles de cada
      // Pokemon en paralelo. Cada future retorna un `Pokemon` o null si falla.
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
                    // Preferir la artwork oficial cuando esté disponible
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
                // Ignorar errores por item y continuar
              }
            }
            return pokemon;
          } catch (_) {
            return null;
          }
        }());
      }

      // Esperar a que todos los requests terminen y agregar los que no sean nulos
      final resultsList = await Future.wait(futures);
      for (final p in resultsList) {
        if (p != null) list.add(p);
      }
    } catch (_) {
      // Ignorar errores generales
    }
    return list;
  }

}
