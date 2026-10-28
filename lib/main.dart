import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

void main() {
  runApp(const CAExamForgeApp());
}

class CAExamForgeApp extends StatelessWidget {
  const CAExamForgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CA ExamForge',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ExamHomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ExamHomeScreen extends StatefulWidget {
  const ExamHomeScreen({super.key});

  @override
  State<ExamHomeScreen> createState() => _ExamHomeScreenState();
}

class _ExamHomeScreenState extends State<ExamHomeScreen> {
  int _remainingSeconds = 10800; // 3 hours in seconds for CA Foundation exam
  Timer? _timer;
  bool _isExamStarted = false;

  void _startExam() {
    setState(() {
      _isExamStarted = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
        _submitExam();
      }
    });
  }

  void _submitExam() {
    _timer?.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Exam Submitted"),
        content: const Text("Your time is up! Your answers have been auto-submitted."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _isExamStarted = false;
                _remainingSeconds = 10800;
              });
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;
    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CA ExamForge - Foundation Simulator'),
        actions: [
          if (_isExamStarted)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Text(
                "Time Left: ${_formatTime(_remainingSeconds)}",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.redAccent),
              ),
            ),
        ],
      ),
      body: Center(
        child: _isExamStarted
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Exam Mode Active (Simulated Environment)",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    const Expanded(
                      child: Center(
                        child: Text(
                          "Question Paper View Area\n(PDF/Questions rendered here)",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
        onPressed: () {
          // Add button action here
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
        child: const Text('End Exam'),
      ),
