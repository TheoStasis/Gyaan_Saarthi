import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../ai_tutor/chat_screen.dart';
import '../games/games_list_screen.dart';
import '../quiz/quiz_list_screen.dart';
import '../videos/video_list_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const ChatScreen(),
    const GamesListScreen(),
    const QuizListScreen(),
    const VideoListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, LanguageProvider>(
      builder: (context, authProvider, langProvider, child) {
        final user = authProvider.user;
        
        return Scaffold(
          appBar: AppBar(
            title: const Text('Gyaan Saarthi'),
            actions: [
              // Language Selector
              PopupMenuButton<String>(
                icon: const Icon(Icons.language),
                onSelected: (languageCode) {
                  langProvider.changeLanguage(languageCode);
                },
                itemBuilder: (context) {
                  return langProvider.languages.entries.map((entry) {
                    return PopupMenuItem<String>(
                      value: entry.key,
                      child: Row(
                        children: [
                          if (entry.key == langProvider.currentLanguage)
                            const Icon(Icons.check, size: 20),
                          if (entry.key == langProvider.currentLanguage)
                            const SizedBox(width: 8),
                          Text(entry.value),
                        ],
                      ),
                    );
                  }).toList();
                },
              ),
              
              // Profile Button
              IconButton(
                icon: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    user?.fullName.substring(0, 1).toUpperCase() ?? 'S',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProfileScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.grey,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.psychology),
                activeIcon: const Icon(Icons.psychology),
                label: langProvider.translate('ai_tutor'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.games_outlined),
                activeIcon: const Icon(Icons.games),
                label: langProvider.translate('games'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.quiz_outlined),
                activeIcon: const Icon(Icons.quiz),
                label: langProvider.translate('quizzes'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.video_library_outlined),
                activeIcon: const Icon(Icons.video_library),
                label: langProvider.translate('videos'),
              ),
            ],
          ),
        );
      },
    );
  }
}