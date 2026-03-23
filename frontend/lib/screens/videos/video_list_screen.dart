import 'package:flutter/material.dart';
import 'video_player_screen.dart';

class VideoListScreen extends StatefulWidget {
  const VideoListScreen({super.key});

  @override
  State<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  // Sample video data
  final List<Map<String, dynamic>> _videos = [
    {
      'id': '1',
      'title': 'Plant Life Cycle',
      'subject': 'Science',
      'duration': '5:21',
      'thumbnail': 'https://via.placeholder.com/300x200?text=Plant+Life+Cycle',
      'videoUrl': 'https://www.youtube.com/watch?v=2SBVz4MgeIE',
    },
    {
      'id': '2',
      'title': 'Water Cycle Experiment',
      'subject': 'Science',
      'duration': '3:08',
      'thumbnail': 'https://via.placeholder.com/300x200?text=Water+Cycle',
      'videoUrl': 'https://www.youtube.com/watch?v=ncORPosDrjI',
    },
    {
      'id': '3',
      'title': 'Solar System Model',
      'subject': 'Science',
      'duration': '4:21',
      'thumbnail': 'https://via.placeholder.com/300x200?text=Solar+System',
      'videoUrl': 'https://www.youtube.com/watch?v=w36yxLgwUOc',
    },
    {
      'id': '4',
      'title': 'Chemical Reactions Demo',
      'subject': 'Science',
      'duration': '3:28',
      'thumbnail': 'https://via.placeholder.com/300x200?text=Chemical+Reactions',
      'videoUrl': 'https://www.youtube.com/watch?v=NRCn8z8gb1w',
    },
  ];

  String _selectedClass = 'All';
  final List<String> _classFilters = ['All'];

  @override
  Widget build(BuildContext context) {
    final filteredVideos = _selectedClass == 'All'
        ? _videos
        : _videos.where((v) => v['class'].toString() == _selectedClass).toList();

    return Scaffold(
      body: Column(
        children: [
          // Filter chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _classFilters.map((classLevel) {
                  final isSelected = _selectedClass == classLevel;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(classLevel == 'All' ? 'All Classes' : 'Class $classLevel'),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedClass = classLevel;
                        });
                      },
                      selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                      checkmarkColor: Theme.of(context).primaryColor,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          
          // Videos list
          Expanded(
            child: filteredVideos.isEmpty
                ? const Center(
                    child: Text('No videos available for this class'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredVideos.length,
                    itemBuilder: (context, index) {
                      return _buildVideoCard(context, filteredVideos[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Video upload feature coming soon for teachers!'),
            ),
          );
        },
        heroTag: null,
        icon: const Icon(Icons.upload),
        label: const Text('Upload Video'),
      ),
    );
  }

  Widget _buildVideoCard(BuildContext context, Map<String, dynamic> video) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VideoPlayerScreen(
                videoUrl: video['videoUrl'],
                title: video['title'],
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Stack(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.play_circle_outline,
                    size: 64,
                    color: Colors.white,
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      video['duration'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // Video info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withValues(alpha:0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Class ${video['class']}',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        video['subject'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.remove_red_eye, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${video['views']} views',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}