import 'dart:math';
import 'package:flutter/material.dart';
import '../data/quiz_data.dart';
import '../models/quiz_question.dart';
import '../services/progress_service.dart';
import '../widgets/app_drawer.dart';
import 'quiz_result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<QuizQuestion> _questions;
  final Map<String, int> _answers = {};
  int _currentIndex = 0;
  bool _started = false;

  void _startQuiz() {
    final shuffled = List<QuizQuestion>.from(quizPool)..shuffle(Random());
    final count = shuffled.length < 10 ? shuffled.length : 10;
    setState(() {
      _questions = shuffled.take(count).toList();
      _answers.clear();
      _currentIndex = 0;
      _started = true;
    });
  }

  void _selectAnswer(int optionIndex) {
    setState(() {
      _answers[_questions[_currentIndex].id] = optionIndex;
    });
  }

  void _next() {
    if (_currentIndex < _questions.length - 1) {
      setState(() => _currentIndex++);
    } else {
      _submit();
    }
  }

  Future<void> _submit() async {
    int score = 0;
    for (final q in _questions) {
      if (_answers[q.id] == q.correctIndex) score++;
    }
    await ProgressService().addQuizScore(score, _questions.length);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => QuizResultScreen(
          questions: _questions,
          answers: _answers,
          score: score,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_started) {
      return Scaffold(
        appBar: AppBar(title: const Text('Daily quiz')),
        drawer: const AppDrawer(currentRoute: 'quiz'),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.psychology, size: 64, color: Color(0xFF60A5FA)),
                const SizedBox(height: 16),
                const Text('10 random questions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text('Playwright, TypeScript, Git, Jenkins, Java se', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _startQuiz,
                  style: ElevatedButton.styleFrom(minimumSize: const Size(200, 48)),
                  child: const Text('Quiz shuru karein'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final q = _questions[_currentIndex];
    final selected = _answers[q.id];

    return Scaffold(
      appBar: AppBar(title: Text('Question ${_currentIndex + 1} / ${_questions.length}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(value: (_currentIndex + 1) / _questions.length),
            const SizedBox(height: 20),
            Text(q.topic, style: const TextStyle(fontSize: 11, color: Color(0xFF60A5FA), fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(q.question, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            const SizedBox(height: 20),
            ...List.generate(q.options.length, (i) {
              final isSelected = selected == i;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Material(
                  color: isSelected ? const Color(0xFF1E3A5F) : const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => _selectAnswer(i),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Icon(
                            isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                            size: 18,
                            color: isSelected ? const Color(0xFF60A5FA) : Colors.grey,
                          ),
                          const SizedBox(width: 10),
                          Expanded(child: Text(q.options[i], style: const TextStyle(fontSize: 13))),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
            const Spacer(),
            ElevatedButton(
              onPressed: selected != null ? _next : null,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
              child: Text(_currentIndex < _questions.length - 1 ? 'Agla sawaal' : 'Submit karein'),
            ),
          ],
        ),
      ),
    );
  }
}
