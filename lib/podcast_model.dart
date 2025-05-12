class Podcast {
  final String title;
  final String description;
  final String imageUrl;
  final String category;
  final List<Episode> episodes;

  Podcast({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    this.episodes = const [], // Bu default ile sorunsuz olur
  });
}

class Episode {
  final String title;
  final String duration;
  final String audioUrl;

  Episode({
    required this.title,
    required this.duration,
    required this.audioUrl,
  });
}
