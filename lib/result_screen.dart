import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:myapp/home_screen.dart';
import 'package:myapp/quiz_screen.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final List questions;
  final Map<int, String> userAnswers;
  final String name;
  final String subject;
  final String logoPath;

  const ResultScreen({
    super.key,
    required this.score,
    required this.questions,
    required this.userAnswers,
    required this.name,
    required this.subject,
    required this.logoPath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Quiz Result', style: TextStyle(color: Colors.white)),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            logoPath,
            fit: BoxFit.cover,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('Congratulations, $name!', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 10),
                  Text('You have completed the $subject quiz.', style: const TextStyle(fontSize: 18, color: Colors.white)),
                  const SizedBox(height: 20),
                  Text('Your Score: $score / ${questions.length}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
                  const SizedBox(height: 30),
                  Expanded(
                    child: ListView.builder(
                      itemCount: questions.length,
                      itemBuilder: (context, index) {
                        final question = questions[index];
                        final userAnswer = userAnswers[index];
                        final isCorrect = userAnswer == question['answer'];

                        Color cardColor;
                        IconData cardIcon;
                        Color iconColor;
                        Color textColor = Colors.white;

                        if (userAnswer == null) {
                          cardColor = Colors.white.withOpacity(0.1);
                          cardIcon = Icons.help_outline;
                          iconColor = Colors.white70;
                        } else if (isCorrect) {
                          cardColor = Colors.green.withOpacity(0.3);
                          cardIcon = Icons.check;
                          iconColor = Colors.greenAccent;
                        } else {
                          cardColor = Colors.red.withOpacity(0.3);
                          cardIcon = Icons.close;
                          iconColor = Colors.redAccent;
                        }

                        return Card(
                          color: cardColor,
                          child: ListTile(
                            title: Text(question['question'], style: TextStyle(color: textColor)),
                            subtitle: Text('Your Answer: ${userAnswer ?? "Not Answered"}\nCorrect Answer: ${question['answer']}', style: TextStyle(color: textColor.withOpacity(0.8))),
                            leading: Icon(cardIcon, color: iconColor),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const HomeScreen()),
                            (Route<dynamic> route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.8),
                          foregroundColor: Colors.black,
                        ),
                        child: const Text('Play Again'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizScreen(subject: subject, name: name, logoPath: logoPath),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.withOpacity(0.8),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Re-test'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
