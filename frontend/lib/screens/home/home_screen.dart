// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../ai_tutor/chat_screen.dart';
import '../games/games_list_screen.dart';
import '../quiz/quiz_subjects_screen.dart';
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
    const HomeTab(),
    const ChatScreen(),
    const GamesListScreen(),
    const QuizSubjectsScreen(),
    const VideoListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, LanguageProvider>(
      builder: (context, authProvider, langProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              _currentIndex == 0
                  ? 'Gyaan Saarthi - ज्ञान साथी'
                  : _getTitle(_currentIndex, langProvider),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.language),
                onSelected: (languageCode) {
                  langProvider.changeLanguage(languageCode);
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'en', child: Text('English')),
                  const PopupMenuItem(value: 'hi', child: Text('हिंदी')),
                  const PopupMenuItem(value: 'bn', child: Text('বাংলা')),
                  const PopupMenuItem(value: 'ta', child: Text('தமிழ்')),
                  const PopupMenuItem(value: 'te', child: Text('తెలుగు')),
                  const PopupMenuItem(value: 'mr', child: Text('मराठी')),
                ],
              ),
              IconButton(
                icon: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(
                    authProvider.user?.firstName.substring(0, 1).toUpperCase() ??
                    authProvider.user?.username.substring(0, 1).toUpperCase() ?? 'U',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
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
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                label: langProvider.translate('home'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.chat),
                label: langProvider.translate('ai_tutor'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.games),
                label: langProvider.translate('games'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.quiz),
                label: langProvider.translate('quizzes'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.video_library),
                label: langProvider.translate('videos'),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getTitle(int index, LanguageProvider langProvider) {
    switch (index) {
      case 1:
        return langProvider.translate('ai_tutor');
      case 2:
        return langProvider.translate('games');
      case 3:
        return langProvider.translate('quizzes');
      case 4:
        return langProvider.translate('videos');
      default:
        return 'Gyaan Saarthi';
    }
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, LanguageProvider>(
      builder: (context, authProvider, langProvider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.blue, Colors.blueAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        langProvider.translate('greeting'),
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        authProvider.user?.fullName ?? 
                        authProvider.user?.firstName ?? 
                        authProvider.user?.username ?? 
                        'Student',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        langProvider.translate('welcome_message'),
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Features Section
              Text(
                langProvider.translate('features'),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              
              // Features Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: [
                  _buildFeatureCard(
                    context,
                    icon: Icons.chat_bubble,
                    title: langProvider.translate('ai_tutor'),
                    subtitle: langProvider.translate('ai_tutor_desc'),
                    color: Colors.blue,
                    onTap: () {
                      // ✅ FIXED: Navigate to ChatScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ChatScreen()),
                      );
                    },
                  ),
                  _buildFeatureCard(
                    context,
                    icon: Icons.games,
                    title: langProvider.translate('games'),
                    subtitle: langProvider.translate('games_desc'),
                    color: Colors.green,
                    onTap: () {
                      // ✅ FIXED: Navigate to GamesListScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const GamesListScreen()),
                      );
                    },
                  ),
                  _buildFeatureCard(
                    context,
                    icon: Icons.quiz,
                    title: langProvider.translate('quizzes'),
                    subtitle: langProvider.translate('quizzes_desc'),
                    color: Colors.orange,
                    onTap: () {
                      // ✅ FIXED: Navigate to QuizSubjectsScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const QuizSubjectsScreen()),
                      );
                    },
                  ),
                  _buildFeatureCard(
                    context,
                    icon: Icons.video_library,
                    title: langProvider.translate('videos'),
                    subtitle: langProvider.translate('videos_desc'),
                    color: Colors.red,
                    onTap: () {
                      // ✅ FIXED: Navigate to VideoListScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const VideoListScreen()),
                      );
                    },
                  ),
                ],
              ),
              // ✅ REMOVED: Quick Stats section completely removed
            ],
          ),
        );
      },
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      // ✅ FIXED: No black background - removed color property
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
