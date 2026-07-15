class Note {
  final String id;
  final String title;
  final String body;
  final String? imagePath;
  final DateTime createdAt;

  Note({
    required this.id,
    required this.title,
    required this.body,
    this.imagePath,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'imagePath': imagePath,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'],
        title: json['title'],
        body: json['body'],
        imagePath: json['imagePath'],
        createdAt: DateTime.parse(json['createdAt']),
      );
}
