import 'package:pokemon/pokemon_card.dart';
import 'package:flutter/material.dart';
import 'pokemon_model.dart';

class PokemonList extends StatelessWidget {
  final List<Pokemon> pokemons;
  const PokemonList(this.pokemons, {super.key});

  @override
  Widget build(BuildContext context) {
    return _buildList(context);
  }

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
