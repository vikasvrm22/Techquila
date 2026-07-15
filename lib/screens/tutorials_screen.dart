import 'package:flutter/material.dart';
import '../data/tutorial_content.dart';
import '../models/tutorial.dart';
import '../services/progress_service.dart';
import '../widgets/app_drawer.dart';
import 'tutorial_detail_screen.dart';

class TutorialsScreen extends StatefulWidget {
  const TutorialsScreen({super.key});

  @override
  State<TutorialsScreen> createState() => _TutorialsScreenState();
}

class _TutorialsScreenState extends State<TutorialsScreen> {
  final ProgressService _progress = ProgressService();
  Set<String> _completedChapters = {};

  static const Map<String, IconData> _icons = {
    'playwright': Icons.play_circle_outline,
    'typescript': Icons.code,
    'git': Icons.merge_type,
    'jenkins': Icons.settings_suggest,
    'java': Icons.coffee,
  };

  static const Map<String, Color> _colors = {
    'playwright': Color(0xFF60A5FA),
    'typescript': Color(0xFF4ADE80),
    'git': Color(0xFFFBBF24),
    'jenkins': Color(0xFFA78BFA),
    'java': Color(0xFFF87171),
  };

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final completed = await _progress.getCompletedChapters();
    setState(() => _completedChapters = completed);
  }

  double _progressPercent(Tutorial t) {
    if (t.chapters.isEmpty) return 0;
    final done = t.chapters.where((c) => _completedChapters.contains(c.id)).length;
    return (done / t.chapters.length) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tutorials')),
      drawer: const AppDrawer(currentRoute: 'tutorials'),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: tutorials.length,
          itemBuilder: (context, index) {
            final t = tutorials[index];
            final color = _colors[t.id] ?? Colors.grey;
            final pct = _progressPercent(t);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Material(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () async {
                    await Navigator.push(context, MaterialPageRoute(builder: (_) => TutorialDetailScreen(tutorial: t)));
                    _load();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                          child: Icon(_icons[t.id] ?? Icons.book, color: color, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(t.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                              const SizedBox(height: 3),
                              Text('${t.chapters.length} chapters · ${t.subtitle}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                            ],
                          ),
                        ),
                        Text('${pct.round()}%', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
                        const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
