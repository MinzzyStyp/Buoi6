import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';
import '../providers/audio_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double volume = 1.0;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AudioProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF191414),
      appBar: AppBar(
        backgroundColor: const Color(0xFF191414),
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Playback Settings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF282828),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  activeColor: const Color(0xFF1DB954),
                  title: const Text(
                    'Shuffle',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: const Text(
                    'Phát ngẫu nhiên bài hát',
                    style: TextStyle(color: Colors.grey),
                  ),
                  value: provider.isShuffleEnabled,
                  onChanged: (_) {
                    provider.toggleShuffle();
                  },
                ),

                const Divider(color: Colors.grey),

                ListTile(
                  leading: const Icon(Icons.repeat, color: Colors.white),
                  title: const Text(
                    'Repeat Mode',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    _repeatText(provider.loopMode),
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {
                    provider.toggleRepeat();
                  },
                ),

                const Divider(color: Colors.grey),

                ListTile(
                  leading: const Icon(Icons.volume_up, color: Colors.white),
                  title: const Text(
                    'Volume',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Slider(
                    value: volume,
                    min: 0,
                    max: 1,
                    activeColor: const Color(0xFF1DB954),
                    onChanged: (value) {
                      setState(() {
                        volume = value;
                      });
                      provider.setVolume(value);
                    },
                  ),
                ),
              ],
            ),
          ),

         
        ],
      ),
    );
  }

  String _repeatText(LoopMode mode) {
    switch (mode) {
      case LoopMode.off:
        return 'Repeat Off';
      case LoopMode.all:
        return 'Repeat All';
      case LoopMode.one:
        return 'Repeat One';
    }
  }
}