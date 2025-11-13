import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: MyStepperPage(),
    theme: ThemeData(
      primaryColor: const Color(0xFF90CAF9),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF90CAF9),
        foregroundColor: Colors.black87,
      ),
      colorScheme: ColorScheme.light(
        primary: const Color(0xFF35618E),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF35618E),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    ),
  ));
}

class MyStepperPage extends StatefulWidget {
  const MyStepperPage({super.key});
  @override
  State<MyStepperPage> createState() => _MyStepperPageState();
}

class _MyStepperPageState extends State<MyStepperPage> {
  int _currentStep = 0;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  List<Step> getSteps() => [
        Step(
          title: const Text("Pers."),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text("Personal", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              const Text("Pulsi 'Contact' o pulsi el botó de 'Continue'."),
            ],
          ),
          isActive: _currentStep >= 0,
          state: StepState.indexed,
        ),
        Step(
          title: const Text("Contact"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text("Contact", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              const Text("Pulsi 'Upload' o pulsi el botó de 'Continue'."),
            ],
          ),
          isActive: _currentStep >= 1,
          state: StepState.editing,
        ),
        Step(
          title: const Text("Upload"),
          content: Column(
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: const TextStyle(color: Color(0xFF90CAF9)),
                  prefixIcon: const Icon(Icons.email, color: Color(0xFF90CAF9)),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF90CAF9), width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF35618E), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _addressController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Address",
                  hintStyle: const TextStyle(color: Color(0xFF90CAF9)),
                  prefixIcon: const Icon(Icons.home, color: Color(0xFF90CAF9)),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 48,
                    minHeight: 48,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF90CAF9), width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF35618E), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _mobileController,
                decoration: InputDecoration(
                  hintText: "Mobile No",
                  hintStyle: const TextStyle(color: Color(0xFF90CAF9)),
                  prefixIcon: const Icon(Icons.phone, color: Color(0xFF90CAF9)),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF90CAF9), width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF35618E), width: 2),
                  ),
                ),
              ),
            ],
          ),
          isActive: _currentStep >= 2,
          state: StepState.complete,
        ),
      ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: const Text("Salesians Sarrià 24/25 Carles Aguilar")),
      body: Stepper(
        type: StepperType.horizontal,
        steps: getSteps(),
        currentStep: _currentStep,
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          return Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: details.onStepContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF35618E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('CONTINUE'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: details.onStepCancel,
                  child: const Text(
                    'CANCEL',
                    style: TextStyle(color: Color(0xFF35618E)),
                  ),
                ),
              ],
            ),
          );
        },
        onStepTapped: (step) {
          if (step == _currentStep + 1) {
            setState(() => _currentStep = step);
          }
        },
        onStepContinue: () {
          if (_currentStep < getSteps().length - 1) {
            setState(() => _currentStep += 1);
          } else {
            // Último step: mostrar dialog
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  icon: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF35618E),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, color: Colors.white, size: 32),
                  ),
                  title: const Text(
                    "Submission\nCompleted",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  content: Text(
                    "{Email: ${_emailController.text}, Address: ${_addressController.text}, Mobile: ${_mobileController.text}}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                  actions: [
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          "Close",
                          style: TextStyle(color: Color(0xFF35618E), fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep -= 1);
          }
        },
      ),
    );
  }
}
