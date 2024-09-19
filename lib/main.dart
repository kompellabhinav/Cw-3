import 'dart:async'; // Import dart:async for Timer
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
  late Timer _hungerTimer;
  late Timer _winConditionTimer;
  bool _isGameOver = false;
  bool _hasWon = false;
  int happinessAboveThresholdDuration = 0; // Track time happiness is above 80

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();

    // Start the timer to increase hunger every 30 seconds
    _hungerTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      setState(() {
        hungerLevel = (hungerLevel + 5).clamp(0, 100);
        if (hungerLevel >= 100) {
          happinessLevel = (happinessLevel - 20).clamp(0, 100);
        }
        _checkLossCondition();
      });
    });

    // Start the timer for the win condition check every second
    _winConditionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (happinessLevel > 80) {
        happinessAboveThresholdDuration++;
        if (happinessAboveThresholdDuration >= 30) {
          // 3 minutes (180 seconds)
          setState(() {
            _hasWon = true;
            _hungerTimer.cancel();
            _winConditionTimer.cancel();
          });
        }
      } else {
        happinessAboveThresholdDuration =
            0; // Reset duration if happiness falls below 80
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _hungerTimer.cancel(); // Cancel the timer to prevent memory leaks
    _winConditionTimer.cancel();
    super.dispose();
  }

// Function to increase happiness and update hunger when playing with the pet
  void _playWithPet() {
    if (_isGameOver || _hasWon) return; // Prevent interactions after game ends
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      _updateHunger();
    });
  }

// Function to decrease hunger and update happiness when feeding the pet
  void _feedPet() {
    if (_isGameOver || _hasWon) return; // Prevent interactions after game ends
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
    _checkLossCondition();
  }

// Increase hunger level slightly when playing with the pet
  void _updateHunger() {
    hungerLevel = (hungerLevel + 5).clamp(0, 100);
    if (hungerLevel > 100) {
      hungerLevel = 100;
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    }
    _checkLossCondition();
  }

// Check if the game is lost
  void _checkLossCondition() {
    if (hungerLevel == 100 && happinessLevel <= 10) {
      setState(() {
        _isGameOver = true;
        _hungerTimer.cancel();
        _winConditionTimer.cancel();
      });
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
                _isGameOver
                    ? 'Game Over!'
                    : _hasWon
                        ? 'You Win!'
                        : 'Happiness Level: $happinessLevel',
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
                    child: happinessLevel < 30 ? const Image(image: AssetImage("lib/assets/sad.png"))
                      : happinessLevel > 70 ? const Image(image: AssetImage("lib/assets/happy.png"))
                      : (happinessLevel >= 30 && happinessLevel < 50) ? const Image(image: AssetImage("lib/assets/angry.png"),) 
                      : const Image(image: AssetImage("lib/assets/dog.png")),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Text(
                    _isGameOver
                        ? "Game Over"
                        : _hasWon
                            ? "You Win!"
                            : happinessLevel < 30
                                ? "Unhappy 😢"
                                : happinessLevel > 70
                                    ? "Happy 😃"
                                    : (happinessLevel >= 30 && happinessLevel < 50) ? "Angry 😡" : "Neutral 🫤",
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
