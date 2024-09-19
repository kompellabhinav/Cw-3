import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet";
  int happinessLevel = 20;
  int hungerLevel = 50;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

// Function to increase happiness and update hunger when playing with the pet
  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      _updateHunger();
    });
  }

// Function to decrease hunger and update happiness when feeding the pet
  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      _updateHappiness();
    });
  }

// Update happiness based on hunger level
  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    } else {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
    }
  }

// Increase hunger level slightly when playing with the pet
  void _updateHunger() {
    hungerLevel = (hungerLevel + 5).clamp(0, 100);
    if (hungerLevel > 100) {
      hungerLevel = 100;
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    }
  }

  void _submitName() {
    setState(() {
      petName = _nameController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Digital Pet'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Name: $petName',
                style: const TextStyle(fontSize: 20.0),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Happiness Level: $happinessLevel',
                style: const TextStyle(fontSize: 20.0),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Hunger Level: $hungerLevel',
                style: const TextStyle(fontSize: 20.0),
              ),
              const SizedBox(height: 32.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    color: happinessLevel < 30
                        ? Colors.red
                        : happinessLevel > 70
                            ? Colors.green
                            : Colors.yellow,
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Text(
                    happinessLevel < 30
                        ? "Unhappy"
                        : happinessLevel > 70
                            ? "Happy"
                            : "Neutral",
                    style: const TextStyle(fontSize: 24),
                  ),
                ],
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _playWithPet,
                child: const Text('Play with Your Pet'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _feedPet,
                child: const Text('Feed Your Pet'),
              ),
              const SizedBox(
                height: 32.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 150,
                    child: TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Pet name"),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _submitName,
                    child: const Text("Submit"),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
