import 'package:pokemon/pokemon_model.dart';
import 'pokemon_detail_page.dart';
import 'package:flutter/material.dart';

class PokemonCard extends StatefulWidget {
  final Pokemon pokemon;
  const PokemonCard(this.pokemon, {super.key});
  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _PokemonCardState createState() => _PokemonCardState(pokemon);
}

class _PokemonCardState extends State<PokemonCard> {
  Pokemon pokemon;
  String? renderUrl;

  _PokemonCardState(this.pokemon);

  @override
  void initState() {
    super.initState();
    renderPokemonPic();
  }

  Widget get pokemonImage {
    var pokemonAvatar = Hero(
      tag: pokemon,
      child: Container(
        width: 100.0,
        height: 100.0,
        decoration:
            BoxDecoration(shape: BoxShape.circle, image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(renderUrl ?? ''))),
      ),
    );

    var placeholder = Container(
      width: 100.0,
      height: 100.0,
      decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient:
              LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.black54, Colors.black, Color.fromARGB(255, 84, 110, 122)])),
      alignment: Alignment.center,
      child: const Text(
        'POKE',
        textAlign: TextAlign.center,
      ),
    );

    var crossFade = AnimatedCrossFade(
      firstChild: placeholder,
      secondChild: pokemonAvatar,
      // Mostrar placeholder mientras no tengamos URL
      crossFadeState: renderUrl == null ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 1000),
    );

    return crossFade;
  }

  void renderPokemonPic() async {
    await pokemon.getImageUrl();
    if (mounted) {
      setState(() {
        renderUrl = pokemon.imageUrl;
      });
    }
  }

  Widget get pokemonCard {
    return Positioned(
      right: 0.0,
      child: SizedBox(
        width: 290,
        height: 115,
          child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          color: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8, left: 64),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  widget.pokemon.name,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 27.0),
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.star, color: Theme.of(context).colorScheme.onSurface),
                    Text(': ${widget.pokemon.rating}/10', style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 14.0))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  showPokemonDetailPage() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return PokemonDetailPage(pokemon);
    })).then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showPokemonDetailPage(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: SizedBox(
          height: 115.0,
          child: Stack(
            children: <Widget>[
              pokemonCard,
              Positioned(top: 7.5, child: pokemonImage),
            ],
          ),
        ),
      ),
    );
  }
}
