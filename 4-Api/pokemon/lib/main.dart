// Componentes y utilidades de Flutter
import 'package:flutter/material.dart';
// Usado para `Future` y operaciones asíncronas
import 'dart:async';
// Modelo de dominio y vistas de la aplicación
import 'pokemon_model.dart';
import 'pokemon_list.dart';
import 'new_pokemon_form.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My fav Pokemons',
      theme: ThemeData(
        brightness: Brightness.light,
        // Rojo tipo Pokéball, desaturado, para el fondo de los `Scaffold`
        scaffoldBackgroundColor: const Color(0xFFB33A3A),
        // Estilo global para ElevatedButton: usar el rojo de fondo para el texto
        // y aumentar padding/ tamaño de fuente para botones principales.
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: const Color(0xFFB33A3A),
            padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 14.0),
            textStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      home: const MyHomePage(
        title: 'My fav Pokemons',
      ),
    );
  }
}

    /// Página principal de la aplicación.
    ///
    /// Muestra la lista de Pokemons añadidos y ofrece un botón para abrir
    /// el formulario de alta (`AddPokemonFormPage`). Hereda los estilos del
    /// `ThemeData` definido en `MyApp`.
    class MyHomePage extends StatefulWidget {
      // Título que aparece en el AppBar
      final String title;
      const MyHomePage({super.key, required this.title});

      @override
      // ignore: library_private_types_in_public_api
      _MyHomePageState createState() => _MyHomePageState();
    }

class _MyHomePageState extends State<MyHomePage> {
  List<Pokemon> initialPokemons = [];

  Future _showNewPokemonForm() async {
    // Abre la pantalla de añadir Pokemon y espera el resultado.
    // Si el usuario devuelve un `Pokemon`, se solicita su imagen desde la
    // API (para obtener la artwork oficial) y se añade a la lista en memoria.
    Pokemon? newPokemon = await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
      return const AddPokemonFormPage();
    }));

    if (newPokemon != null) {
      // Asegurar que el objeto tenga la URL de la imagen antes de mostrarlo
      await newPokemon.getImageUrl();
      initialPokemons.add(newPokemon);
      // Re-renderizar la UI para que aparezca el nuevo Pokemon
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var key = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: key,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        // backgroundColor and text/icon colors are handled by ThemeData.appBarTheme
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showNewPokemonForm,
          ),
        ],
      ),
      body: Center(
        child: PokemonList(initialPokemons),
      ),
    );
  }
}
