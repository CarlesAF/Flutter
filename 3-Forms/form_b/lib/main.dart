import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MyStepperPage()));
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
              const Text("Personal", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const Text("Pulsi 'Contact' o pulsi el botó de 'Continue'."),
            ],
          ),
          isActive: _currentStep >= 0,
        ),
        Step(
          title: const Text("Contact"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Contact", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const Text("Pulsi 'Upload' o pulsi el botó de 'Continue'."),
            ],
          ),
          isActive: _currentStep >= 1,
        ),
        Step(
          title: const Text("Upload"),
          content: Column(
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email", prefixIcon: Icon(Icons.email)),
              ),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: "Address", prefixIcon: Icon(Icons.home)),
              ),
              TextField(
                controller: _mobileController,
                decoration: const InputDecoration(labelText: "Mobile No", prefixIcon: Icon(Icons.phone)),
              ),
            ],
          ),
          isActive: _currentStep >= 2,
        ),
      ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Salesians Sarrià 24/25")),
      body: Stepper(
        steps: getSteps(),
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < getSteps().length - 1) {
            setState(() => _currentStep += 1);
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
