import 'package:flutter/material.dart';
import 'widgets/star_rating.dart';
import 'services/rating_service.dart';

class RatingsPage extends StatefulWidget {
  const RatingsPage({super.key});

  @override
  State<RatingsPage> createState() => _RatingsPageState();
}

class _RatingsPageState extends State<RatingsPage> {
  final _svc = RatingService();

  // All places from kKLPlaces
  final _places = const [
    // ICONIC & INSTA-WORTHY
    {
      'id': 'petronas',
      'title': 'Petronas Twin Towers (KLCC)',
      'category': 'Iconic'
    },
    {'id': 'merdeka_square', 'title': 'Merdeka Square', 'category': 'Iconic'},
    {'id': 'kl_tower', 'title': 'KL Tower', 'category': 'Iconic'},
    {
      'id': 'thean_hou_temple',
      'title': 'Thean Hou Temple',
      'category': 'Iconic'
    },
    {
      'id': 'bukit_bintang',
      'title': 'Bukit Bintang Shopping District',
      'category': 'Iconic'
    },
    {
      'id': 'perdana_garden',
      'title': 'Perdana Botanical Garden',
      'category': 'Iconic'
    },

    // FOODIE SPOTS
    {
      'id': 'jalan_alor',
      'title': 'Jalan Alor Food Street',
      'category': 'Foodie'
    },
    {'id': 'central_market', 'title': 'Central Market', 'category': 'Foodie'},
    {
      'id': 'chinatown',
      'title': 'Petaling Street (Chinatown)',
      'category': 'Foodie'
    },
    {
      'id': 'little_india',
      'title': 'Little India (Brickfields)',
      'category': 'Foodie'
    },
    {
      'id': 'kampung_baru',
      'title': 'Kampung Baru Night Market',
      'category': 'Foodie'
    },
    {
      'id': 'pavilion_food',
      'title': 'Pavilion Food Court',
      'category': 'Foodie'
    },
    {'id': 'sri_hartamas', 'title': 'Desa Sri Hartamas', 'category': 'Foodie'},
    {
      'id': 'taman_connaught',
      'title': 'Taman Connaught Night Market',
      'category': 'Foodie'
    },

    // CULTURE & HERITAGE
    {'id': 'batu_caves', 'title': 'Batu Caves', 'category': 'Culture'},
    {
      'id': 'islamic_arts',
      'title': 'Islamic Arts Museum',
      'category': 'Culture'
    },
    {
      'id': 'national_museum',
      'title': 'National Museum',
      'category': 'Culture'
    },
    {
      'id': 'national_mosque',
      'title': 'National Mosque (Masjid Negara)',
      'category': 'Culture'
    },
    {'id': 'jamek_mosque', 'title': 'Masjid Jamek', 'category': 'Culture'},
    {
      'id': 'petrosains',
      'title': 'Petrosains Discovery Centre',
      'category': 'Culture'
    },
    {
      'id': 'national_gallery',
      'title': 'National Art Gallery',
      'category': 'Culture'
    },

    // FAMILY ATTRACTIONS
    {'id': 'aquaria', 'title': 'Aquaria KLCC', 'category': 'Family'},
    {'id': 'zoo_negara', 'title': 'Zoo Negara', 'category': 'Family'},
    {'id': 'kidzania', 'title': 'KidZania Kuala Lumpur', 'category': 'Family'},
    {'id': 'sunway_lagoon', 'title': 'Sunway Lagoon', 'category': 'Family'},
    {'id': 'farm_city', 'title': 'Farm In The City', 'category': 'Family'},
    {
      'id': 'wonderland_park',
      'title': '99 Wonderland Park',
      'category': 'Family'
    },
    {
      'id': 'splashmania',
      'title': 'SplashMania Gamuda Cove',
      'category': 'Family'
    },
    {
      'id': 'district21',
      'title': 'District 21 IOI City Mall',
      'category': 'Family'
    },
    {'id': 'jungle_gym', 'title': 'Jungle Gym Bangsar', 'category': 'Family'},
    {'id': 'superpark', 'title': 'SuperPark Malaysia', 'category': 'Family'},
    {'id': 'kl_bird_park', 'title': 'KL Bird Park', 'category': 'Family'},
    {
      'id': 'kl_butterfly_park',
      'title': 'KL Butterfly Park',
      'category': 'Family'
    },
  ];

  final Map<String, double> _ratings = {};
  bool _isLoading = true;
  String _searchQuery = '';
  String? _selectedCategory;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAll() async {
    for (final p in _places) {
      final v = await RatingService.getRating(p['id']!);
      _ratings[p['id']!] = v ?? 0.0;
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Iconic':
        return const Color(0xFF6366F1); // Indigo
      case 'Foodie':
        return const Color(0xFFEC4899); // Pink
      case 'Culture':
        return const Color(0xFF8B5CF6); // Purple
      case 'Family':
        return const Color(0xFF10B981); // Emerald
      default:
        return Colors.grey;
    }
  }

  void _onPlaceTap(String placeId, String placeName, String category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                placeName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getCategoryColor(category).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    color: _getCategoryColor(category),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Rate your experience',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: StarRating(
                  value: _ratings[placeId] ?? 0.0,
                  readOnly: false,
                  onChanged: (newRating) async {
                    await RatingService.setRating(placeId, newRating);
                    setState(() {
                      _ratings[placeId] = newRating;
                    });
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '✨ Rated ${newRating.toStringAsFixed(1)} stars',
                          ),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter places based on search and category
    final filteredPlaces = _places.where((place) {
      final matchesSearch =
          place['title']!.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == null || place['category'] == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Your Ratings',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey[200],
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Search bar
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search places...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 20),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: const Color(0xFFF8F9FA),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                // Category filters
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildCategoryChip('All', null),
                        const SizedBox(width: 8),
                        _buildCategoryChip('Iconic', 'Iconic'),
                        const SizedBox(width: 8),
                        _buildCategoryChip('Foodie', 'Foodie'),
                        const SizedBox(width: 8),
                        _buildCategoryChip('Culture', 'Culture'),
                        const SizedBox(width: 8),
                        _buildCategoryChip('Family', 'Family'),
                      ],
                    ),
                  ),
                ),
                // Results count
                if (filteredPlaces.isEmpty)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No places found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try adjusting your search or filters',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: Row(
                            children: [
                              Text(
                                '${filteredPlaces.length} ${filteredPlaces.length == 1 ? 'place' : 'places'}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            itemCount: filteredPlaces.length,
                            itemBuilder: (context, i) {
                              final p = filteredPlaces[i];
                              final value = _ratings[p['id']] ?? 0.0;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Material(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  child: InkWell(
                                    onTap: () => _onPlaceTap(
                                      p['id']!,
                                      p['title']!,
                                      p['category']!,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 48,
                                            height: 48,
                                            decoration: BoxDecoration(
                                              color: _getCategoryColor(
                                                      p['category']!)
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Icon(
                                              _getCategoryIcon(p['category']!),
                                              color: _getCategoryColor(
                                                  p['category']!),
                                              size: 24,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  p['title']!,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: -0.3,
                                                    color: Color(0xFF1F2937),
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Row(
                                                  children: [
                                                    StarRating(
                                                      value: value,
                                                      readOnly: true,
                                                      onChanged: (_) {},
                                                    ),
                                                    if (value > 0) ...[
                                                      const SizedBox(width: 8),
                                                      Text(
                                                        value
                                                            .toStringAsFixed(1),
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              Colors.grey[700],
                                                        ),
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            size: 16,
                                            color: Colors.grey[400],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
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

  Widget _buildCategoryChip(String label, String? category) {
    final isSelected = _selectedCategory == category;
    final color = category != null ? _getCategoryColor(category) : Colors.grey;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Iconic':
        return Icons.location_city;
      case 'Foodie':
        return Icons.restaurant;
      case 'Culture':
        return Icons.palette;
      case 'Family':
        return Icons.family_restroom;
      default:
        return Icons.place;
    }
  }
}
