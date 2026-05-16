import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/song_model.dart';
import '../providers/audio_provider.dart';
import '../widgets/song_tile.dart';
import 'now_playing_screen.dart';

class SearchScreen extends StatefulWidget {
  final List<SongModel> songs;

  const SearchScreen({
    super.key,
    required this.songs,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<SongModel> _filteredSongs = [];

  @override
  void initState() {
    super.initState();
    _filteredSongs = widget.songs;
  }

  void _searchSongs(String keyword) {
    final query = keyword.toLowerCase();

    setState(() {
      _filteredSongs = widget.songs.where((song) {
        final title = song.title.toLowerCase();
        final artist = song.artist.toLowerCase();
        final album = song.album?.toLowerCase() ?? '';

        return title.contains(query) ||
            artist.contains(query) ||
            album.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF191414),
      appBar: AppBar(
        backgroundColor: const Color(0xFF191414),
        title: const Text('Search Songs'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: _searchSongs,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search by title, artist, album...',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF282828),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Expanded(
            child: _filteredSongs.isEmpty
                ? const Center(
                    child: Text(
                      'No songs found',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredSongs.length,
                    itemBuilder: (context, index) {
                      final song = _filteredSongs[index];

                      return SongTile(
                        song: song,
                        onTap: () async {
                          await context
                              .read<AudioProvider>()
                              .setPlaylist(_filteredSongs, index);

                          if (!context.mounted) return;

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => NowPlayingScreen(),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}