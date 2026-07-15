import 'package:flutter/material.dart';
import '../models/tutorial.dart';
import '../services/progress_service.dart';
import '../widgets/content_view.dart';
import '../widgets/diagram_view.dart';

class ChapterReaderScreen extends StatefulWidget {
  final Chapter chapter;

  const ChapterReaderScreen({super.key, required this.chapter});

  @override
  State<ChapterReaderScreen> createState() => _ChapterReaderScreenState();
}

class _ChapterReaderScreenState extends State<ChapterReaderScreen> {
  final ProgressService _progress = ProgressService();
  bool _isComplete = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final completed = await _progress.getCompletedChapters();
    setState(() => _isComplete = completed.contains(widget.chapter.id));
  }

  Future<void> _toggleComplete() async {
    if (_isComplete) {
      await _progress.markChapterIncomplete(widget.chapter.id);
    } else {
      await _progress.markChapterComplete(widget.chapter.id);
    }
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.chapter.title)),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.chapter.diagram != null)
                    DiagramView(type: widget.chapter.diagram!),
                  ContentView(content: widget.chapter.content),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: _toggleComplete,
              icon: Icon(_isComplete ? Icons.check_circle : Icons.check_circle_outline),
              label: Text(_isComplete ? 'Complete kiya hua hai' : 'Complete mark karein'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isComplete ? const Color(0xFF166534) : const Color(0xFF1D4ED8),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
