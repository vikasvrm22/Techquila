class Chapter {
  final String id;
  final String title;
  final String content;
  final String? diagram; // optional diagram key, rendered by DiagramView

  const Chapter({
    required this.id,
    required this.title,
    required this.content,
    this.diagram,
  });
}

class Tutorial {
  final String id;
  final String name;
  final String subtitle;
  final List<Chapter> chapters;

  const Tutorial({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.chapters,
  });
}
