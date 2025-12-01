// Lista que renderiza las tarjetas de Pokemon recibidas.
import 'package:pokemon/pokemon_card.dart';
import 'package:flutter/material.dart';
import 'pokemon_model.dart';

/// `PokemonList` es un `StatelessWidget` que muestra una `ListView`
/// construida dinámicamente a partir de la lista de `Pokemon` pasada.
class PokemonList extends StatelessWidget {
  final List<Pokemon> pokemons;
  const PokemonList(this.pokemons, {super.key});

  @override
  Widget build(BuildContext context) {
    return _buildList(context);
  }

  // Construye la ListView usando ListView.builder para eficiencia con
  // listas largas. Cada elemento crea un `PokemonCard`.
  ListView _buildList(context) {
    return ListView.builder(
      itemCount: pokemons.length,
      // ignore: avoid_types_as_parameter_names
      itemBuilder: (context, int) {
        return PokemonCard(pokemons[int]);
      },
    );
  }
}
