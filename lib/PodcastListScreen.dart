import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:podcast/podcast_service.dart';
import 'package:podcast/podcast_detail_screen.dart'; // Detay ekranı ekleyelim

class PodcastListScreen extends StatefulWidget {
  final String category;

  const PodcastListScreen({Key? key, required this.category}) : super(key: key);

  @override
  _PodcastListScreenState createState() => _PodcastListScreenState();
}

class _PodcastListScreenState extends State<PodcastListScreen> {
  final PodcastService _podcastService = PodcastService();
  List<Map<String, dynamic>> _podcasts = [];
  List<Map<String, dynamic>> _filteredPodcasts = [];
  bool _isLoading = true;
  String _searchQuery = ''; // Arama sorgusu için değişken
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPodcasts();
  }

  // Podcastleri yükleme ve filtreleme
  Future<void> _loadPodcasts() async {
    try {
      final podcasts = await _podcastService.getPodcastList(widget.category);
      setState(() {
        _podcasts = podcasts;
        _filteredPodcasts =
            podcasts; // Başlangıçta tüm podcastler filtrelenmiş olarak gösterilsin
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading podcasts: $e');
    }
  }

  // Arama fonksiyonu
  void _filterPodcasts(String query) {
    final filtered =
        _podcasts.where((podcast) {
          final title = podcast['title'].toLowerCase();
          return title.contains(query.toLowerCase());
        }).toList();

    setState(() {
      _filteredPodcasts = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category,
          style: GoogleFonts.lobster(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.grey[800],
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _filterPodcasts,
                      decoration: InputDecoration(
                        hintText: 'Search by title',
                        labelStyle: TextStyle(color: Colors.white70),
                        hintStyle: TextStyle(color: Colors.white54),
                        prefixIcon: Icon(Icons.search, color: Colors.white70),
                        filled: true,
                        fillColor: Colors.grey[900],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child:
                        _filteredPodcasts.isEmpty
                            ? Center(child: Text('No podcasts found.'))
                            : ListView.builder(
                              itemCount: _filteredPodcasts.length,
                              itemBuilder: (context, index) {
                                final podcast = _filteredPodcasts[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  color: Colors.grey[900],
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(12),
                                    leading: Image.network(
                                      podcast['image'],
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                                    title: Text(
                                      podcast['title'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    subtitle: Text(
                                      podcast['description'],
                                      style: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                      maxLines:
                                          5, // En fazla 5 satır gösterecek
                                      overflow:
                                          TextOverflow
                                              .ellipsis, // 5 satırdan sonrası "..." olarak kısaltılacak
                                    ),
                                    onTap: () {
                                      // 📌 Podcast detay sayfasına yönlendirme
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => PodcastDetailScreen(
                                                podcastId: podcast['id'],
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              ),
    );
  }
}
