// Página de detalle de un Pokémon: muestra la imagen, su nombre,
// tipos (levelPokemon) y permite al usuario votar mediante un slider.
import 'package:flutter/material.dart';
import 'pokemon_model.dart';
 
class PokemonDetailPage extends StatefulWidget {
  final Pokemon pokemon;
  const PokemonDetailPage(this.pokemon, {super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PokemonDetailPageState createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  // Tamaño del avatar circular que se muestra en la parte superior
  final double pokemonAvarterSize = 150.0;
  // Valor del slider de rating. Integro en 0..10
  double _sliderValue = 10.0;

  @override
  void initState() {
    super.initState();
    // Inicializar el slider con el rating actual del Pokemon
    _sliderValue = (widget.pokemon.rating).toDouble();
  }

  /// Widget que muestra el control para votar (slider) y el botón de submit.
  Widget get addYourRating {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Slider(
                  // Slider con color blanco (usuario solicitado)
                  activeColor: Colors.white,
                  min: 0.0,
                  max: 10.0,
                  divisions: 10,
                  value: _sliderValue.clamp(0.0, 10.0),
                  label: '${_sliderValue.toInt()}',
                  onChanged: (newRating) {
                    setState(() {
                      _sliderValue = newRating;
                    });
                  },
                ),
              ),
              Container(
                  width: 50.0,
                  alignment: Alignment.center,
                  child: Text(
                    '${_sliderValue.toInt()}',
                    // Número del slider en blanco para coincidir con el slider
                    style: const TextStyle(color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.w600),
                  )),
            ],
          ),
        ),
        // Botón de submit colocado debajo del control. Estilizado abajo.
        submitRatingButton,
      ],
    );
  }

  /// Guarda el rating seleccionado en el modelo y muestra un SnackBar
  /// de confirmación.
  void updateRating() {
    setState(() {
      widget.pokemon.rating = _sliderValue.toInt();
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Rating saved: ${widget.pokemon.rating}/10'),
      duration: const Duration(seconds: 1),
    ));
  }

  Widget get submitRatingButton {
    return ElevatedButton(
      onPressed: () => updateRating(),
      child: const Text('Submit'),
    );
  }

  /// Avatar circular con sombra que muestra la imagen del Pokemon. Usa
  /// `Hero` para animar la transición hacia la pantalla de detalle.
  Widget get pokemonImage {
    return Hero(
      tag: widget.pokemon,
      child: Container(
        height: pokemonAvarterSize,
            width: pokemonAvarterSize,
            constraints: const BoxConstraints(),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(offset: Offset(1.0, 2.0), blurRadius: 2.0, spreadRadius: -1.0, color: Color(0x33000000)),
                  BoxShadow(offset: Offset(2.0, 1.0), blurRadius: 3.0, spreadRadius: 0.0, color: Color(0x24000000)),
                  BoxShadow(offset: Offset(3.0, 1.0), blurRadius: 4.0, spreadRadius: 2.0, color: Color(0x1f000000))
                ],
                image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(widget.pokemon.imageUrl ?? ""))),
      ),
    );
  }

  /// Muestra el rating grande con un icono y el valor. Los colores vienen del tema.
  Widget get rating {
    return Row(
          mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
            Icon(
              Icons.star,
              size: 40.0,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            Text('${widget.pokemon.rating}/10', style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 30.0))
      ],
    );
  }

  /// Sección superior con el avatar, nombre y tipos del Pokemon.
  Widget get pokemonProfile {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          pokemonImage,
          Text(widget.pokemon.name, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 32.0)),
          Text('${widget.pokemon.levelPokemon}', style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 20.0)),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: rating,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meet ${widget.pokemon.name}'),
      ),
      body: ListView(
        children: <Widget>[pokemonProfile, addYourRating],
      ),
    );
  }
}
