// Importa el modelo `Pokemon` para crear nuevas instancias
import 'package:pokemon/pokemon_model.dart';
import 'package:flutter/material.dart';


/// Página con el formulario para añadir un nuevo Pokémon.
///
/// Proporciona un `Autocomplete` que sugiere nombres (primeros 151) y
/// devuelve un objeto `Pokemon` al `Navigator.pop` cuando el usuario lo
/// envía. Los comentarios explican cada parte para facilitar la lectura.
class AddPokemonFormPage extends StatefulWidget {
  const AddPokemonFormPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddPokemonFormPageState createState() => _AddPokemonFormPageState();
}

class _AddPokemonFormPageState extends State<AddPokemonFormPage> {
  TextEditingController nameController = TextEditingController();
  List<String> pokemonNames = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    // Carga asíncrona de los primeros 151 Pokémon para ofrecer
    // autocompletado en el formulario. `fetchFirst151` retorna una lista
    // de `Pokemon`; aquí solo guardamos los nombres formateados para la UI.
    Pokemon.fetchFirst151().then((list) {
      setState(() {
        pokemonNames = list.map((p) => _normalizeDisplayName(p.name)).toList();
        loading = false;
      });
    });
  }

  String _normalizeDisplayName(String name) {
    if (name.isEmpty) return name;
    // Capitaliza la primera letra para mostrar nombres más agradables
    return name[0].toUpperCase() + name.substring(1);
  }

  void submitPokemon(BuildContext context) {
    final input = nameController.text.trim();
    if (input.isEmpty) {
      // Validación: si el campo está vacío mostramos un SnackBar con error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).colorScheme.error,
        content: const Text('You forgot to insert the pokemon name'),
      ));
      return;
    }

    // Si ya cargamos la lista de nombres, obligamos a que el nombre
    // coincida con una sugerencia (ignora mayúsculas/minúsculas) para
    // evitar errores de escritura.
    if (!loading && pokemonNames.isNotEmpty) {
      final found = pokemonNames.where((n) => n.toLowerCase() == input.toLowerCase()).isNotEmpty;
      if (!found) {
        // Indicamos al usuario que debe elegir una opción válida
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          content: const Text('Please choose a name from the suggestions to ensure correct spelling'),
        ));
        return;
      }
    }

    var newPokemon = Pokemon(input);
    Navigator.of(context).pop(newPokemon);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new pokemon'),
      ),
      body: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: loading
                  ? SizedBox(
                      height: 56,
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color?>(Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    )
                  : Autocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text == '') {
                          return const Iterable<String>.empty();
                        }
                        return pokemonNames.where((String option) {
                          return option.toLowerCase().startsWith(textEditingValue.text.toLowerCase());
                        });
                      },
                      onSelected: (String selection) {
                        nameController.text = selection;
                      },
                      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                        // El Autocomplete nos proporciona un controller; lo
                        // reasignamos a `nameController` para que `submitPup`
                        // lea el valor correcto al enviar.
                        nameController = textEditingController;
                        return TextField(
                          controller: textEditingController,
                          focusNode: focusNode,
                          // Texto en blanco y cursor blanco según petición
                          style: const TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            labelText: 'Pokemon Name',
                            // Etiqueta blanca
                            labelStyle: const TextStyle(color: Colors.white),
                            // Borde blanco para destacar el campo
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white70),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () => submitPokemon(context),
                    child: const Text('Submit Pokemon'),
                  );
                },
              ),
            )
          ]),
        ),
      ),
    );
  }
}
