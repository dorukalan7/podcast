import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddPodcastScreen extends StatefulWidget {
  @override
  _AddPodcastScreenState createState() => _AddPodcastScreenState();
}

class _AddPodcastScreenState extends State<AddPodcastScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _audioUrlController = TextEditingController();

  final List<String> _categories = [
    'All Podcasts List & Search',
    'Language Arts Podcasts',
    'Science Podcasts',
    'Social Studies Podcasts',
    'Biography Podcasts',
  ];

  String? _selectedCategory;
  String? _descriptionError;

  void _savePodcast() {
    if (_selectedCategory == null ||
        _titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _imageUrlController.text.isEmpty ||
        _audioUrlController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields and select a category')),
      );
      return;
    }

    if (_descriptionController.text.length < 50) {
      setState(() {
        _descriptionError = 'Description must be at least 50 characters.';
      });
      return;
    }

    setState(() {
      _descriptionError = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Podcast added successfully!')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        title: Text(
          "Add Podcast",
          style: GoogleFonts.lobster(
            textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView( // Sayfanın kaydırılmasını sağlıyor
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Select Category",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                dropdownColor: Colors.grey[800], // Arka plan koyu olsun
                hint: Text("Choose a category", style: TextStyle(color: Colors.white)),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category, style: TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
              ),
              SizedBox(height: 20),

              _buildTextField(_titleController, "Podcast Title"),
              SizedBox(height: 20),
              _buildTextField(_descriptionController, "Description", errorText: _descriptionError),
              SizedBox(height: 20),
              _buildTextField(_imageUrlController, "Image URL"),SizedBox(height: 20),
              _buildTextField(_audioUrlController, "Audio URL"),SizedBox(height: 20),
              

              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: _savePodcast,
                child: Text("Save Podcast", style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 20), // Butonun altında boşluk bırakmak için
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {String? errorText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Enter $label",
                  hintStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  errorText: errorText,
                ),
              ),
            ),
            SizedBox(width: 8),
            if (label == 'Image URL') // Image URL için ikon
              IconButton(
                onPressed: () {
                  // Burada ikon ile yapılacak işlem eklenebilir
                  // Örneğin, resim URL'si için bir dosya seçici açmak
                },
                icon: Icon(Icons.image, color: Colors.white),
              ),
            if (label == 'Audio URL') // Audio URL için mikrofon ikonu
              IconButton(
                onPressed: () {
                  // Burada ses kaydı için bir işlem başlatılabilir
                },
                icon: Icon(Icons.mic, color: Colors.white),
              ),
          ],
        ),
      ],
    );
  }
}
