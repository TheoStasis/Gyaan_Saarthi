import 'package:flutter/material.dart';
import 'dart:math';

class NumberArrangementGame extends StatefulWidget {
  const NumberArrangementGame({super.key});

  @override
  State<NumberArrangementGame> createState() => _NumberArrangementGameState();
}

class _NumberArrangementGameState extends State<NumberArrangementGame> {
  final Random _random = Random();
  List<int> _numbers = [];
  List<int> _userArrangement = [];
  int _currentLevel = 1;
  int _score = 0;
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    _generateLevel();
  }

  void _generateLevel() {
    final count = 5 + (_currentLevel - 1) * 2; // Start with 5, increase by 2 each level
    final maxNumber = min(20 + _currentLevel * 10, 100);
    
    final numberSet = <int>{};
    while (numberSet.length < count) {
      numberSet.add(_random.nextInt(maxNumber) + 1);
    }
    
    _numbers = numberSet.toList()..shuffle();
    _userArrangement = [];
    setState(() {});
  }

  void _checkArrangement() {
    setState(() => _isChecking = true);
    
    final correctOrder = List<int>.from(_numbers)..sort();
    final isCorrect = _listEquals(_userArrangement, correctOrder);
    
    if (isCorrect) {
      _score += 10 * _currentLevel;
      _showFeedback(true);
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _currentLevel++;
          _isChecking = false;
        });
        _generateLevel();
      });
    } else {
      _showFeedback(false);
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _userArrangement = [];
          _isChecking = false;
        });
      });
    }
  }

  bool _listEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  void _showFeedback(bool isCorrect) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isCorrect 
            ? '🎉 Perfect! Moving to level ${_currentLevel + 1}!' 
            : '❌ Not quite! Try again!',
          style: const TextStyle(fontSize: 18),
        ),
        backgroundColor: isCorrect ? Colors.green : Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Arrangement'),
        backgroundColor: Colors.green,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Level $_currentLevel', style: const TextStyle(fontSize: 16)),
                  Text('Score: $_score', style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Instructions
            Card(
              color: Colors.green[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      '📊 Arrange numbers in ascending order!',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap numbers to add them to your arrangement',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Available Numbers
            const Text(
              'Available Numbers:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _numbers.map((number) {
                final isUsed = _userArrangement.contains(number);
                return ElevatedButton(
                  onPressed: isUsed || _isChecking
                      ? null
                      : () {
                          setState(() {
                            _userArrangement.add(number);
                          });
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isUsed ? Colors.grey : Colors.green,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(60, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    number.toString(),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 30),
            
            // User's Arrangement
            const Text(
              'Your Arrangement:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 2),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: _userArrangement.isEmpty
                  ? const Center(
                      child: Text(
                        'Tap numbers above to arrange them',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _userArrangement.asMap().entries.map((entry) {
                        final index = entry.key;
                        final number = entry.value;
                        return Chip(
                          label: Text(
                            number.toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          deleteIcon: const Icon(Icons.close, size: 18),
                          onDeleted: _isChecking
                              ? null
                              : () {
                                  setState(() {
                                    _userArrangement.removeAt(index);
                                  });
                                },
                          backgroundColor: Colors.green[100],
                        );
                      }).toList(),
                    ),
            ),
            
            const Spacer(),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _userArrangement.isEmpty || _isChecking
                        ? null
                        : () {
                            setState(() {
                              _userArrangement = [];
                            });
                          },
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _userArrangement.length != _numbers.length || _isChecking
                        ? null
                        : _checkArrangement,
                    icon: _isChecking
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.check),
                    label: Text(_isChecking ? 'Checking...' : 'Check'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}