import 'package:flutter/material.dart';
import 'dart:async';
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

        scaffoldBackgroundColor: const Color(0xFFB33A3A),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: const Color(0xFFB33A3A),
            padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 14.0),
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

    class MyHomePage extends StatefulWidget {
      final String title;
      const MyHomePage({super.key, required this.title});
      @override
      // ignore: library_private_types_in_public_api
      _MyHomePageState createState() => _MyHomePageState();
    }

class _MyHomePageState extends State<MyHomePage> {
  List<Pokemon> myfavPokemons = [];

  Future _showNewPokemonForm() async {

    Pokemon? newPokemon = await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
      return const AddPokemonFormPage();
    }));

    if (newPokemon != null) {
      await newPokemon.getImageUrl();
      myfavPokemons.add(newPokemon);
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

        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showNewPokemonForm,
          ),
        ],
      ),
      
      body: Center(
        child: PokemonList(myfavPokemons),
      ),
    );
  }
}
