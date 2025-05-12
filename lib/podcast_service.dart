import 'dart:convert';
import 'package:http/http.dart' as http;

class PodcastService {
  final String apiKey = 'da1ba0bca23f4b03985f7f87244fb604'; // API Key'inizi buraya yazın.
  final String baseUrl = 'https://listen-api.listennotes.com/api/v2';

  // 📌 Belirli bir kategoriye ait podcastleri getir
  Future<List<Map<String, dynamic>>> getPodcastList(String category) async {
    final response = await http.get(
      Uri.parse('$baseUrl/search?q=$category&type=podcast'),
      headers: {
        'X-ListenAPI-Key': apiKey,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['results'].map((podcast) => {
        'id': podcast['id'],
        'title': podcast['title_original'],
        'description': podcast['description_original'] ?? 'No description',
        'image': podcast['image'] ?? 'https://via.placeholder.com/150',
      }));
    } else {
      throw Exception('Failed to load podcasts');
    }
  }

  // 📌 Podcast detayları ve bölüm bilgilerini getir
  Future<Map<String, dynamic>> getPodcastDetails(String podcastId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/podcasts/$podcastId'),
      headers: {
        'X-ListenAPI-Key': apiKey,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load podcast details');
    }
  }
}
