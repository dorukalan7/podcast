import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:podcast/podcast_service.dart';
import 'package:audioplayers/audioplayers.dart';

class PodcastDetailScreen extends StatefulWidget {
  final String podcastId;

  const PodcastDetailScreen({Key? key, required this.podcastId})
    : super(key: key);

  @override
  _PodcastDetailScreenState createState() => _PodcastDetailScreenState();
}

class _PodcastDetailScreenState extends State<PodcastDetailScreen> {
  final PodcastService _podcastService = PodcastService();
  Map<String, dynamic>? _podcastDetails;
  bool _isLoading = true;
  AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  String _currentAudioUrl = '';
  String _currentEpisodeTitle = '';
  String _currentEpisodeImage = '';
  bool _isBottomSheetOpen =
      false; // BottomSheet'in açık olup olmadığını takip et

  // 📌 Manuel olarak girdiğin ses dosyaları (Bölüm başlıkları ile eşleşmeli)
  Map<String, String> manualAudioUrls = {
    "Introducing Shadow Kingdom: God’s Banker (coming March 17)":
        "https://dcs-spotify.megaphone.fm/CROOKEDMEDIAINC1955759803.mp3?key=add3aa6a99c47ec1b4e0c7aa75703160&request_event_id=cd68c2d2-b432-4937-8492-f7bae2b26b67&timetoken=1741879955_0CA867852EF28F686DAD81DC0101BDB4",
    "Shadow Kingdom - Episode 2": "https://example.com/audio2.mp3",
    "Shadow Kingdom - Episode 3": "https://example.com/audio3.mp3",
    "Shadow Kingdom - Episode 4": "https://example.com/audio4.mp3",
    "Shadow Kingdom - Episode 5": "https://example.com/audio5.mp3",
    "Shadow Kingdom - Episode 6": "https://example.com/audio6.mp3",
    "Shadow Kingdom - Episode 7": "https://example.com/audio7.mp3",
    "Shadow Kingdom - Episode 8": "https://example.com/audio8.mp3",
    "Shadow Kingdom - Episode 9": "https://example.com/audio9.mp3",
    "Shadow Kingdom - Episode 10": "https://example.com/audio10.mp3",
  };

  @override
  void initState() {
    super.initState();
    _loadPodcastDetails();
  }

  Future<void> _loadPodcastDetails() async {
    try {
      final details = await _podcastService.getPodcastDetails(widget.podcastId);
      setState(() {
        _podcastDetails = details;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading podcast details: $e');
    }
  }

  void _playAudio(String url, String episodeTitle, String episodeImage) async {
    if (_isPlaying && _currentAudioUrl == url) {
      await _audioPlayer.pause(); // Eğer aynı ses çalınıyorsa durdur
      setState(() {
        _isPlaying = false;
      });
    } else {
      if (url.isNotEmpty && Uri.parse(url).isAbsolute) {
        await _audioPlayer.play(UrlSource(url)); // Yeni ses çal
        setState(() {
          _isPlaying = true;
          _currentAudioUrl = url;
          _currentEpisodeTitle = episodeTitle;
          _currentEpisodeImage = episodeImage;
        });

        // BottomSheet'i aç
        if (!_isBottomSheetOpen) {
          setState(() {
            _isBottomSheetOpen = true;
          });
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                color: Colors.grey[900],
                height: 80,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          _currentEpisodeImage,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Shadow Kingdom',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _currentEpisodeTitle,
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        if (_isPlaying) {
                          await _audioPlayer.pause();
                        } else {
                          await _audioPlayer.play(UrlSource(_currentAudioUrl));
                        }
                        setState(() {
                          _isPlaying = !_isPlaying;
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          );
        }
      } else {
        print('Geçersiz URL: $url');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _podcastDetails?['title'] ?? 'Podcast Details',
          style: GoogleFonts.lobster(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.grey[800],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _podcastDetails == null
              ? Center(
                child: Text(
                  'Failed to load details.',
                  style: TextStyle(color: Colors.white),
                ),
              )
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          _podcastDetails!['image'] ??
                              'https://via.placeholder.com/150',
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        _podcastDetails!['title'] ?? 'No title',
                        style: GoogleFonts.lobster(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _podcastDetails!['description'] ??
                            'No description available',
                        style: TextStyle(color: Colors.white70),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Episodes:',
                        style: GoogleFonts.lobster(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      if (_podcastDetails!['episodes'] != null)
                        Column(
                          children:
                              _podcastDetails!['episodes'].map<Widget>((
                                episode,
                              ) {
                                return Card(
                                  color: Colors.grey[900],
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(12),
                                    leading: Image.network(
                                      episode['image'] ??
                                          'https://via.placeholder.com/150',
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                                    title: Text(
                                      episode['title'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    subtitle: Text(
                                      episode['description'] ?? '',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    onTap: () {
                                      final episodeTitle =
                                          episode['title'] ?? '';
                                      final audioUrl =
                                          manualAudioUrls.containsKey(
                                                episodeTitle,
                                              )
                                              ? manualAudioUrls[episodeTitle]
                                              : null;

                                      if (audioUrl != null &&
                                          audioUrl.isNotEmpty) {
                                        _playAudio(
                                          audioUrl,
                                          episodeTitle,
                                          episode['image'],
                                        );
                                      } else {
                                        print('Audio URL geçerli değil.');
                                      }
                                    },
                                  ),
                                );
                              }).toList(),
                        )
                      else
                        Text(
                          'No episodes available.',
                          style: TextStyle(color: Colors.white70),
                        ),
                    ],
                  ),
                ),
              ),
    );
  }
}
