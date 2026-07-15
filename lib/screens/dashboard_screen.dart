import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../data/tutorial_content.dart';
import '../services/progress_service.dart';
import '../widgets/app_drawer.dart';
import 'quiz_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ProgressService _progress = ProgressService();
  Set<String> _completedChapters = {};
  double _avgQuizScore = 0;
  int _quizAttempts = 0;
  bool _loading = true;

  static const List<Color> _tutorialColors = [
    Color(0xFF60A5FA),
    Color(0xFF4ADE80),
    Color(0xFFFBBF24),
    Color(0xFFA78BFA),
    Color(0xFFF87171),
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final completed = await _progress.getCompletedChapters();
    final avg = await _progress.getAverageScorePercent();
    final scores = await _progress.getQuizScores();
    setState(() {
      _completedChapters = completed;
      _avgQuizScore = avg;
      _quizAttempts = scores.length;
      _loading = false;
    });
  }

  double _tutorialProgressPercent(int index) {
    final tutorial = tutorials[index];
    if (tutorial.chapters.isEmpty) return 0;
    final completedCount = tutorial.chapters.where((c) => _completedChapters.contains(c.id)).length;
    return (completedCount / tutorial.chapters.length) * 100;
  }

  double get _overallProgressPercent {
    final totalChapters = tutorials.fold<int>(0, (sum, t) => sum + t.chapters.length);
    if (totalChapters == 0) return 0;
    return (_completedChapters.length / totalChapters) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      drawer: const AppDrawer(currentRoute: 'dashboard'),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Row(
                    children: [
                      _statCard('Overall progress', '${_overallProgressPercent.round()}%', const Color(0xFF60A5FA)),
                      const SizedBox(width: 10),
                      _statCard('Quiz avg score', '${_avgQuizScore.round()}%', const Color(0xFF4ADE80)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('Tutorial progress', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey)),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 220,
                    child: BarChart(
                      BarChartData(
                        maxY: 100,
                        barGroups: List.generate(tutorials.length, (i) {
                          return BarChartGroupData(
                            x: i,
                            barRods: [
                              BarChartRodData(
                                toY: _tutorialProgressPercent(i),
                                color: _tutorialColors[i % _tutorialColors.length],
                                width: 26,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          );
                        }),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 32, interval: 25)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final idx = value.toInt();
                                if (idx < 0 || idx >= tutorials.length) return const SizedBox();
                                return Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(tutorials[idx].name, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                );
                              },
                            ),
                          ),
                        ),
                        gridData: const FlGridData(show: true, drawVerticalLine: false),
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Material(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizScreen())),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(Icons.psychology, color: Color(0xFF60A5FA)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Aaj ka quiz', style: TextStyle(fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 3),
                                  Text('$_quizAttempts attempts ab tak', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _statCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
      ),
    );
  }
}
