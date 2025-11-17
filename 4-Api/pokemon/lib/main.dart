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
      title: 'My fav Digimons',
      theme: ThemeData(brightness: Brightness.dark),
      home: const MyHomePage(
        title: 'My fav Digimons',
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
  List<Digimon> initialDigimons = [Digimon('Gatomon'), Digimon('Gomamon'), Digimon('Leomon')];

  Future _showNewDigimonForm() async {
    Digimon newDigimon = await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
      return const AddDigimonFormPage();
    }));
    //print(newDigimon);
    initialDigimons.add(newDigimon);
      setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var key = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: key,
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF0B479E),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showNewDigimonForm,
          ),
        ],
      ),
      body: Container(
          color: const Color.fromARGB(255, 88, 111, 137),
          child: Center(
            child: DigimonList(initialDigimons),
          )),
    );
  }
}
