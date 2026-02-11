import 'package:flutter/material.dart';

class AudioRecorderWidget extends StatefulWidget {
  final Function(String) onAudioRecorded;
  
  const AudioRecorderWidget({
    super.key,
    required this.onAudioRecorded,
  });

  @override
  State<AudioRecorderWidget> createState() => _AudioRecorderWidgetState();
}

class _AudioRecorderWidgetState extends State<AudioRecorderWidget> {
  bool _isRecording = false;

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
    });
    
    if (!_isRecording) {
      // Simulate audio recording completion
      widget.onAudioRecorded('audio_file_path.mp3');
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _isRecording ? Icons.stop : Icons.mic,
        color: _isRecording ? Colors.red : null,
      ),
      onPressed: _toggleRecording,
    );
  }
}