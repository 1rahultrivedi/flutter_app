
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/result_screen.dart';

class QuizScreen extends StatefulWidget {
  final String subject;
  final String name;
  final String logoPath;

  const QuizScreen({
    super.key,
    required this.subject,
    required this.name,
    required this.logoPath,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  Timer? _timer;
  int _secondsRemaining = 90;
  final Map<int, String> _userAnswers = {};

  @override
  void initState() {
    super.initState();
    _loadQuestions();
    _startTimer();
  }

  Future<void> _loadQuestions() async {
    final String response = await rootBundle.loadString('assets/quiz.json');
    final Map<String, dynamic> data = await json.decode(response);
    final List subjects = data['subjects'];
    final subjectData = subjects.firstWhere((d) => d['name'] == widget.subject, orElse: () => null);
    if (subjectData != null) {
      List allQuestions = List.from(subjectData['questions']);
      allQuestions.shuffle();
      setState(() {
        _questions = allQuestions.take(15).toList();
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer?.cancel();
          _showResult();
        }
      });
    });
  }

  void _answerQuestion(String answer) {
    setState(() {
      _userAnswers[_currentIndex] = answer;
    });

    if (_currentIndex < _questions.length - 1) {
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) {
          setState(() {
            _currentIndex++;
          });
        }
      });
    }
  }

  void _previousQuestion() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      _showResult();
    }
  }

  void _showResult() {
    _timer?.cancel();
    _score = 0;
    _userAnswers.forEach((index, userAnswer) {
      if (_questions[index]['answer'] == userAnswer) {
        _score++;
      }
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          score: _score,
          questions: _questions,
          userAnswers: _userAnswers,
          name: widget.name,
          subject: widget.subject,
          logoPath: widget.logoPath,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('${widget.subject} Quiz', style: const TextStyle(color: Colors.white)),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Time: $_secondsRemaining', style: const TextStyle(fontSize: 20, color: Colors.white)),
          )
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            widget.logoPath,
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.7),
            colorBlendMode: BlendMode.darken,
          ),
          _questions.isEmpty
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Question ${_currentIndex + 1}/${_questions.length}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _questions[_currentIndex]['question'],
                          style: const TextStyle(fontSize: 24, color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        ...(_questions[_currentIndex]['options'] as List).map((option) {
                          final isSelected = _userAnswers[_currentIndex] == option;
                          return Card(
                            color: isSelected ? Colors.lightBlue.withOpacity(0.5) : Colors.white.withOpacity(0.2),
                            child: ListTile(
                              title: Text(option, style: const TextStyle(color: Colors.white)),
                              onTap: () => _answerQuestion(option),
                            ),
                          );
                        }),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (_currentIndex > 0)
                              ElevatedButton(
                                onPressed: _previousQuestion,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white.withOpacity(0.8),
                                  foregroundColor: Colors.black,
                                ),
                                child: const Text('Previous'),
                              ),
                            if (_currentIndex < _questions.length - 1)
                              ElevatedButton(
                                onPressed: _nextQuestion,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white.withOpacity(0.8),
                                  foregroundColor: Colors.black,
                                ),
                                child: const Text('Next'),
                              )
                            else
                              ElevatedButton(
                                onPressed: _showResult,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Submit'),
                              ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
