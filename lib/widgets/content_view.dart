import 'package:flutter/material.dart';

/// Renders chapter content: plain paragraphs normally, and text wrapped in
/// ``` fences as styled "code screenshot" blocks (monospace, dark card,
/// copy-friendly). This gives every code sample a consistent, readable look
/// without needing bundled image assets.
class ContentView extends StatelessWidget {
  final String content;
  const ContentView({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final parts = content.split('```');
    final widgets = <Widget>[];

    for (var i = 0; i < parts.length; i++) {
      final piece = parts[i];
      if (piece.trim().isEmpty) continue;
      final isCode = i.isOdd;
      if (isCode) {
        widgets.add(_CodeBlock(code: piece.trim()));
      } else {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              piece.trim(),
              style: const TextStyle(fontSize: 14.5, height: 1.7),
            ),
          ),
        );
      }
      widgets.add(const SizedBox(height: 14));
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: widgets);
  }
}

class _CodeBlock extends StatelessWidget {
  final String code;
  const _CodeBlock({required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF313145)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              _Dot(color: Color(0xFFFF5F56)),
              SizedBox(width: 6),
              _Dot(color: Color(0xFFFFBD2E)),
              SizedBox(width: 6),
              _Dot(color: Color(0xFF27C93F)),
            ],
          ),
          const SizedBox(height: 10),
          SelectableText(
            code,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 13,
              height: 1.5,
              color: Color(0xFFD4D4E0),
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  const _Dot({required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
