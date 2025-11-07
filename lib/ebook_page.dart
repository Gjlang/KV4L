import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class EbookModel {
  final String id;
  final String title;
  final String imageUrl;
  final String pdfUrl;
  final DateTime savedDate;

  EbookModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.pdfUrl,
    required this.savedDate,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'imageUrl': imageUrl,
        'pdfUrl': pdfUrl,
        'savedDate': savedDate.toIso8601String(),
      };

  factory EbookModel.fromJson(Map<String, dynamic> json) => EbookModel(
        id: json['id'],
        title: json['title'],
        imageUrl: json['imageUrl'],
        pdfUrl: json['pdfUrl'],
        savedDate: DateTime.parse(json['savedDate']),
      );
}

class Ebook extends StatefulWidget {
  const Ebook({super.key});

  @override
  State<Ebook> createState() => _EbookState();
}

class _EbookState extends State<Ebook> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<EbookModel> savedEbooks = [];
  bool isLoading = true;

  // Sample ebooks (you can expand this list)
  final List<EbookModel> availableEbooks = [
    EbookModel(
      id: '106',
      title: 'Klang Valley 4 Locals 35',
      imageUrl: 'https://www.kltheguide.com.my/assets/img/ebook/kv4l/35.jpg',
      pdfUrl: 'https://www.klangvalley4locals.com.my/ebook-details.php?id=106',
      savedDate: DateTime.now(),
    ),
    // Add more ebooks here as needed
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadSavedEbooks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedEbooks() async {
    setState(() => isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString('saved_ebooks');

    if (savedData != null) {
      final List<dynamic> decoded = jsonDecode(savedData);
      setState(() {
        savedEbooks = decoded.map((json) => EbookModel.fromJson(json)).toList();
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> _saveEbook(EbookModel ebook) async {
    final prefs = await SharedPreferences.getInstance();

    // Check if already saved
    if (savedEbooks.any((e) => e.id == ebook.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('E-book already saved!'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    savedEbooks.add(ebook);
    final String encoded =
        jsonEncode(savedEbooks.map((e) => e.toJson()).toList());
    await prefs.setString('saved_ebooks', encoded);

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('E-book saved successfully!'),
        backgroundColor: const Color(0xFF25D366),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'View',
          textColor: Colors.white,
          onPressed: () {
            _tabController.animateTo(1);
          },
        ),
      ),
    );
  }

  Future<void> _removeEbook(String id) async {
    final prefs = await SharedPreferences.getInstance();
    savedEbooks.removeWhere((e) => e.id == id);
    final String encoded =
        jsonEncode(savedEbooks.map((e) => e.toJson()).toList());
    await prefs.setString('saved_ebooks', encoded);

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('E-book removed from saved'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _openEbook(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch $url'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'E-Book Library',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 71, 133),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFFF8C42),
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'Explore'),
            Tab(text: 'Saved'),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              const Color(0xFF0A1128),
              Colors.black,
            ],
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildExploreTab(),
            _buildSavedTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildExploreTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text(
            'Discover E-Books',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Explore guides about Klang Valley',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          ...availableEbooks.map((ebook) => _buildEbookCard(
                ebook: ebook,
                isSaved: savedEbooks.any((e) => e.id == ebook.id),
                onSave: () => _saveEbook(ebook),
                onOpen: () => _openEbook(ebook.pdfUrl),
              )),
        ],
      ),
    );
  }

  Widget _buildSavedTab() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF8C42)),
        ),
      );
    }

    if (savedEbooks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_border_rounded,
              size: 80,
              color: Colors.white.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No saved e-books yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start exploring and save your favorites!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'My Library',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${savedEbooks.length} ${savedEbooks.length == 1 ? 'e-book' : 'e-books'} saved',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...savedEbooks.map((ebook) => _buildEbookCard(
                ebook: ebook,
                isSaved: true,
                onRemove: () => _removeEbook(ebook.id),
                onOpen: () => _openEbook(ebook.pdfUrl),
              )),
        ],
      ),
    );
  }

  Widget _buildEbookCard({
    required EbookModel ebook,
    required bool isSaved,
    VoidCallback? onSave,
    VoidCallback? onRemove,
    required VoidCallback onOpen,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A2947),
            const Color(0xFF0D1B2A),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFFF8C42).withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF8C42).withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onOpen,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // E-book Cover Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: ebook.imageUrl,
                    fit: BoxFit.cover,
                    height: 140,
                    width: 100,
                    placeholder: (context, url) => Container(
                      height: 140,
                      width: 100,
                      color: Colors.grey[800],
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFFFF8C42)),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 140,
                      width: 100,
                      color: Colors.grey[800],
                      child: const Icon(Icons.error, color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // E-book Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ebook.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00D4FF).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: const Color(0xFF00D4FF).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: const Text(
                          'Travel Guide',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF00D4FF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          // Read Button
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: onOpen,
                              icon:
                                  const Icon(Icons.menu_book_rounded, size: 16),
                              label: const Text('Read'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF8C42),
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Save/Remove Button
                          IconButton(
                            onPressed: isSaved ? onRemove : onSave,
                            icon: Icon(
                              isSaved ? Icons.bookmark : Icons.bookmark_border,
                              color: isSaved
                                  ? const Color(0xFFFFB800)
                                  : Colors.white60,
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor: isSaved
                                  ? const Color(0xFFFFB800).withOpacity(0.15)
                                  : Colors.white.withOpacity(0.1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
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
        ),
      ),
    );
  }
}
