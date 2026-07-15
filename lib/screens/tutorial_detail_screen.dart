import 'package:flutter/material.dart';
import '../models/tutorial.dart';
import '../services/progress_service.dart';
import 'chapter_reader_screen.dart';

class TutorialDetailScreen extends StatefulWidget {
  final Tutorial tutorial;

  const TutorialDetailScreen({super.key, required this.tutorial});

  @override
  State<TutorialDetailScreen> createState() => _TutorialDetailScreenState();
}

class _TutorialDetailScreenState extends State<TutorialDetailScreen> {
  final ProgressService _progress = ProgressService();
  Set<String> _completedChapters = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final completed = await _progress.getCompletedChapters();
    setState(() => _completedChapters = completed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.tutorial.name)),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: widget.tutorial.chapters.length,
        itemBuilder: (context, index) {
          final chapter = widget.tutorial.chapters[index];
          final done = _completedChapters.contains(chapter.id);
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Material(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (_) => ChapterReaderScreen(chapter: chapter)));
                  _load();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: done ? const Color(0xFF166534) : const Color(0xFF334155),
                        child: done
                            ? const Icon(Icons.check, size: 13, color: Color(0xFF4ADE80))
                            : Text('${index + 1}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(chapter.title, style: const TextStyle(fontSize: 13))),
                      const Icon(Icons.chevron_right, color: Colors.grey, size: 16),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
