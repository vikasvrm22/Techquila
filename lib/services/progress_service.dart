import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressService {
  static const _completedChaptersKey = 'completed_chapters';
  static const _quizScoresKey = 'quiz_scores';

  // ---------- CHAPTER PROGRESS ----------
  Future<Set<String>> getCompletedChapters() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_completedChaptersKey) ?? [];
    return list.toSet();
  }

  Future<void> markChapterComplete(String chapterId) async {
    final prefs = await SharedPreferences.getInstance();
    final completed = (prefs.getStringList(_completedChaptersKey) ?? []).toSet();
    completed.add(chapterId);
    await prefs.setStringList(_completedChaptersKey, completed.toList());
  }

  Future<void> markChapterIncomplete(String chapterId) async {
    final prefs = await SharedPreferences.getInstance();
    final completed = (prefs.getStringList(_completedChaptersKey) ?? []).toSet();
    completed.remove(chapterId);
    await prefs.setStringList(_completedChaptersKey, completed.toList());
  }

  // ---------- QUIZ SCORES ----------
  // Stores a list of {date, score, total} maps as JSON strings.
  Future<List<Map<String, dynamic>>> getQuizScores() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_quizScoresKey) ?? [];
    return list.map((s) => jsonDecode(s) as Map<String, dynamic>).toList();
  }

  Future<void> addQuizScore(int score, int total) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_quizScoresKey) ?? [];
    final entry = jsonEncode({
      'date': DateTime.now().toIso8601String(),
      'score': score,
      'total': total,
    });
    list.add(entry);
    await prefs.setStringList(_quizScoresKey, list);
  }

  Future<double> getAverageScorePercent() async {
    final scores = await getQuizScores();
    if (scores.isEmpty) return 0;
    double totalPercent = 0;
    for (final s in scores) {
      final score = s['score'] as int;
      final total = s['total'] as int;
      if (total > 0) totalPercent += (score / total) * 100;
    }
    return totalPercent / scores.length;
  }
}
