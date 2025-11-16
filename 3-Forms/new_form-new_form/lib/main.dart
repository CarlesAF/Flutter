import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Recuperar el valor d' 'un camp de text',
      home: MyCustomForm(),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});
  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar el valor d\'un camp de text'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: myController,
            ),
            Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 244, 229),
                      foregroundColor: Colors.black87,
                      side: const BorderSide(
                          color: Color.fromARGB(255, 255, 237, 209)),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return SimpleDialog(
                            title: const Text('SimpleDialog'),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(myController.text),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text('simpleDialog'),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 229, 255, 242),
                      foregroundColor: Colors.black87,
                      side: const BorderSide(
                          color: Color.fromARGB(255, 171, 207, 196)),
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return AlertDialog(
                                title: const Text('Warning'),
                                content: Text(myController.text),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('Tancar'),
                                  )
                                ]);
                          });
                    },
                    child: const Text('alertDialog'),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 229, 235, 255),
                      foregroundColor: Colors.black87,
                      side: const BorderSide(
                          color: Color.fromARGB(255, 209, 225, 255)),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Això és un SnackBar'),
                        duration: Duration(seconds: 2),
                      ));
                    },
                    child: const Text('snackBar'),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 253, 229, 255),
                      foregroundColor: Colors.black87,
                      side: const BorderSide(
                          color: Color.fromARGB(255, 239, 201, 247)),
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                                decoration: const BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25),
                                    topRight: Radius.circular(25),
                                  ),
                                ),
                                height: 200,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(myController.text),
                                      ElevatedButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text('Tancar BottomSheet'),
                                      )
                                    ],
                                  ),
                                ));
                          });
                    },
                    child: const Text('bottomSheet'),
                  ),
                ]))
          ],
        ),
      ),
    );
  }
}
