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

  final List<EbookModel> availableEbooks = [
    EbookModel(
      id: '106',
      title: 'Klang Valley 4 Locals 35',
      imageUrl: 'https://www.kltheguide.com.my/assets/img/ebook/kv4l/35.jpg',
      pdfUrl: 'https://www.klangvalley4locals.com.my/ebook-details.php?id=106',
      savedDate: DateTime.now(),
    ),
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

    if (savedEbooks.any((e) => e.id == ebook.id)) {
      _showSnackBar(
        'Already in your library',
        Icons.info_outline,
        const Color(0xFF0F3460),
      );
      return;
    }

    savedEbooks.add(ebook);
    final String encoded =
        jsonEncode(savedEbooks.map((e) => e.toJson()).toList());
    await prefs.setString('saved_ebooks', encoded);

    setState(() {});

    _showSnackBar(
      'Added to library',
      Icons.check_circle_outline,
      const Color(0xFF1A1A2E),
      action: SnackBarAction(
        label: 'View',
        textColor: Colors.white,
        onPressed: () => _tabController.animateTo(1),
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

    _showSnackBar(
      'Removed from library',
      Icons.delete_outline,
      const Color(0xFF0F3460),
    );
  }

  void _showSnackBar(String message, IconData icon, Color color,
      {SnackBarAction? action}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Text(message, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: action,
      ),
    );
  }

  Future<void> _openEbook(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showSnackBar(
        'Could not open e-book',
        Icons.error_outline,
        Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: AppBar(
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1A1A2E),
                  Color(0xFF0F3460),
                  Color(0xFF1A1A2E),
                ],
              ),
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'E-Book Library',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Your digital city guide',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              letterSpacing: 0.5,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            tabs: const [
              Tab(
                icon: Icon(Icons.explore_outlined, size: 20),
                text: 'Explore',
              ),
              Tab(
                icon: Icon(Icons.bookmarks_outlined, size: 20),
                text: 'My Library',
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildExploreTab(),
          _buildSavedTab(),
        ],
      ),
    );
  }

  Widget _buildExploreTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text(
            'Discover Guides',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Explore Klang Valley with our curated e-books',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w400,
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
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1A1A2E)),
        ),
      );
    }

    if (savedEbooks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E).withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.bookmarks_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Your Library is Empty',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start exploring to build your collection',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () => _tabController.animateTo(0),
              icon: const Icon(Icons.explore_outlined),
              label: const Text('Explore E-books'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF1A1A2E),
                side: const BorderSide(color: Color(0xFF1A1A2E), width: 2),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'My Collection',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${savedEbooks.length} ${savedEbooks.length == 1 ? 'e-book' : 'e-books'}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A1A2E).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onOpen,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // E-book Cover
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: ebook.imageUrl,
                      fit: BoxFit.cover,
                      height: 140,
                      width: 100,
                      placeholder: (context, url) => Container(
                        height: 140,
                        width: 100,
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF1A1A2E)),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 140,
                        width: 100,
                        color: Colors.grey[200],
                        child:
                            Icon(Icons.error_outline, color: Colors.grey[400]),
                      ),
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
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A2E),
                          letterSpacing: 0.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A2E).withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.location_city_outlined,
                              size: 12,
                              color: Color(0xFF1A1A2E),
                            ),
                            SizedBox(width: 4),
                            Text(
                              'City Guide',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF1A1A2E),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          // Read Button
                          Expanded(
                            child: ElevatedButton(
                              onPressed: onOpen,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1A1A2E),
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Read Now',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Save/Remove Button
                          Container(
                            decoration: BoxDecoration(
                              color: isSaved
                                  ? const Color(0xFF1A1A2E).withOpacity(0.1)
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IconButton(
                              onPressed: isSaved ? onRemove : onSave,
                              icon: Icon(
                                isSaved
                                    ? Icons.bookmark
                                    : Icons.bookmark_border_rounded,
                                color: isSaved
                                    ? const Color(0xFF1A1A2E)
                                    : Colors.grey[600],
                                size: 22,
                              ),
                              tooltip: isSaved ? 'Remove' : 'Save',
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
