import 'package:flutter/material.dart';
import '../screens/dashboard_screen.dart';
import '../screens/tutorials_screen.dart';
import '../screens/quiz_screen.dart';
import '../screens/notes_screen.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;

  const AppDrawer({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0F172A),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Text('Tech Learn', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
            ),
            _drawerItem(context, Icons.dashboard, 'Dashboard', 'dashboard', const DashboardScreen()),
            _drawerItem(context, Icons.menu_book, 'Tutorials', 'tutorials', const TutorialsScreen()),
            _drawerItem(context, Icons.psychology, 'Daily quiz', 'quiz', const QuizScreen()),
            _drawerItem(context, Icons.note_alt, 'My notes', 'notes', const NotesScreen()),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(BuildContext context, IconData icon, String label, String route, Widget screen) {
    final isActive = currentRoute == route;
    return ListTile(
      leading: Icon(icon, color: isActive ? const Color(0xFF60A5FA) : Colors.grey, size: 20),
      title: Text(label, style: TextStyle(color: isActive ? const Color(0xFF60A5FA) : Colors.white70, fontSize: 14)),
      selected: isActive,
      selectedTileColor: const Color(0xFF1E3A5F),
      onTap: () {
        Navigator.pop(context);
        if (!isActive) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => screen));
        }
      },
    );
  }
}
