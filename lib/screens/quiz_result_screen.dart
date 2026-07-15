import 'package:flutter/material.dart';
import '../models/quiz_question.dart';
import 'quiz_screen.dart';
import 'dashboard_screen.dart';

class QuizResultScreen extends StatelessWidget {
  final List<QuizQuestion> questions;
  final Map<String, int> answers;
  final int score;

  const QuizResultScreen({
    super.key,
    required this.questions,
    required this.answers,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    final percent = questions.isEmpty ? 0 : (score / questions.length * 100).round();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz result'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(14)),
            child: Column(
              children: [
                const Text('Aapka score', style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 8),
                Text('$score / ${questions.length}', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: Color(0xFF60A5FA))),
                const SizedBox(height: 4),
                Text('$percent% correct', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Answer breakdown', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          ...questions.map((q) {
            final userAnswer = answers[q.id];
            final isCorrect = userAnswer == q.correctIndex;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(10),
                border: Border(left: BorderSide(color: isCorrect ? const Color(0xFF4ADE80) : const Color(0xFFF87171), width: 3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(q.question, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text(
                    'Aapka jawab: ${userAnswer != null ? q.options[userAnswer] : "Skip kiya"}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  if (!isCorrect)
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(
                        'Sahi jawab: ${q.options[q.correctIndex]}',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF4ADE80)),
                      ),
                    ),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.lightbulb_outline, size: 15, color: Color(0xFFFBBF24)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            q.explanation,
                            style: const TextStyle(fontSize: 11.5, height: 1.5, color: Color(0xFFCBD5E1)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardScreen())),
                  child: const Text('Dashboard'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const QuizScreen())),
                  child: const Text('Dobara try karein'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
