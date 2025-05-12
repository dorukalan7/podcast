import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'PodcastListScreen.dart';
import 'AddPodcastScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[800],
        primaryColor: Colors.blue,
        hintColor: Colors.orange,
      ),
      home: PodcastHomePage(),
    );
  }
}

class PodcastHomePage extends StatelessWidget {
  final List<PodcastCategory> categories = [
    PodcastCategory(name: 'All Podcasts List & Search', icon: Icons.search, color: Colors.green),
    PodcastCategory(name: 'Language Arts Podcasts', icon: Icons.book, color: Colors.orange.shade300),
    PodcastCategory(name: 'Science Podcasts', icon: Icons.science, color: Color(0xFFf00000)),
    PodcastCategory(name: 'Social Studies Podcasts', icon: Icons.public, color: Colors.blue),
    PodcastCategory(name: 'Biography Podcasts', icon: Icons.person, color: Colors.pink.shade300),
    PodcastCategory(name: 'Add Podcast', icon: Icons.add, color: Colors.green), // 📌 Yeni podcast ekleme butonu
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        elevation: 0,
        title: Text(
          'The Walking Classroom',
          style: GoogleFonts.lobster(
            textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Image.asset('assets/images/logo.png', height: 280),
          Text(
            'Fun, educational podcasts kids listen to while walking!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: category.color.withOpacity(0.8),
                  child: ListTile(
                    leading: Icon(category.icon, color: Colors.white, size: 36),
                    title: Text(
                      category.name,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      if (category.name == 'Add Podcast') {
                        // 📌 Eğer "Add Podcast" butonuna basıldıysa, özel ekleme sayfasına yönlendir
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddPodcastScreen(),
                          ),
                        );
                      } else {
                        // 📌 Diğer kategorilere basıldıysa, Podcast Listesi ekranına yönlendir
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PodcastListScreen(category: category.name),
                          ),
                        );
                      }
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

class PodcastCategory {
  final String name;
  final IconData icon;
  final Color color;

  PodcastCategory({
    required this.name,
    required this.icon,
    required this.color,
  });
}
