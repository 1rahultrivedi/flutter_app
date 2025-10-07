import 'package:flutter/material.dart';
import 'package:myapp/quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _nameController = TextEditingController();
  final _subjects = ['Python', 'Java', 'SQL', 'DSA', 'HTML'];
  final _logos = {
    'Python': 'assets/images/python.png',
    'Java': 'assets/images/java.png',
    'SQL': 'assets/images/sql_back.jpg',
    'DSA': 'assets/images/dsa.png',
    'HTML': 'assets/images/html.jpg',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Enter your name',
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _subjects.length,
                itemBuilder: (context, index) {
                  final subject = _subjects[index];
                  final logoPath = _logos[subject];

                  return Card(
                    child: ListTile(
                      leading: logoPath != null
                          ? Image.asset(
                              logoPath,
                              width: 40,
                              height: 40,
                              fit: BoxFit.contain,
                            )
                          : const Icon(Icons.quiz),
                      title: Text(subject),
                      onTap: () {
                        if (_nameController.text.isNotEmpty) {
                          if (logoPath != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuizScreen(
                                  subject: subject,
                                  name: _nameController.text,
                                  logoPath: logoPath,
                                ),
                              ),
                            );
                          } else {
                            // Handle case where logo is not found
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Logo not found for this subject.'),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter your name'),
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
