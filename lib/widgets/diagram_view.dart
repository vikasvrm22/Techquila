import 'package:flutter/material.dart';

/// Shows a small original diagram for a chapter, keyed by [type].
/// These are simple flow/box diagrams drawn with Flutter widgets —
/// original illustrations, not screenshots of any real tool UI.
class DiagramView extends StatelessWidget {
  final String type;
  const DiagramView({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final steps = _stepsFor(type);
    if (steps.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          for (var i = 0; i < steps.length; i++) ...[
            _Box(label: steps[i]),
            if (i != steps.length - 1)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Icon(Icons.arrow_forward, size: 18, color: Color(0xFF64748B)),
              ),
          ],
        ],
      ),
    );
  }

  List<String> _stepsFor(String type) {
    switch (type) {
      case 'pw_flow':
        return ['Launch Browser', 'Navigate', 'Locate Element', 'Action', 'Assert'];
      case 'pw_trace':
        return ['Test Runs', 'Trace Recorded', 'Failure?', 'Open Trace Viewer', 'Debug'];
      case 'git_flow':
        return ['Working Dir', 'Staging (add)', 'Local Repo (commit)', 'Remote (push)'];
      case 'git_branch':
        return ['main', 'branch off', 'feature work', 'merge back'];
      case 'jenkins_pipeline':
        return ['Commit', 'Webhook', 'Checkout', 'Build', 'Test', 'Deploy'];
      case 'ts_compile':
        return ['.ts file', 'tsc compiler', 'type check', '.js output'];
      case 'java_thread':
        return ['New', 'Runnable', 'Running', 'Blocked/Waiting', 'Terminated'];
      default:
        return [];
    }
  }
}

class _Box extends StatelessWidget {
  final String label;
  const _Box({required this.label});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF1D4ED8)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Color(0xFF1D4ED8)),
      ),
    );
  }
}
