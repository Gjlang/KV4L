import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:klangvalley4locals/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'generated/l10n.dart';

class Spa extends StatefulWidget {
  const Spa({super.key});

  @override
  _SpaState createState() => _SpaState();
}

class _SpaState extends State<Spa> {
  List<String> favoriteSpa = [];
  bool showFavoritesOnly = false;
  String selectedFilter = 'All';

  final List<ItemData> spaItems = [
    ItemData(
      title: 'Khareyana Spa',
      imageUrl:
          'https://www.klangvalley4locals.com.my/assets/img/spakv/khareyana.jpg',
      location: '36, Jalan Selangor, Pjs 7, 40650 Petaling Jaya, Selangor',
      hours: '10.00 am - 8.00 pm (Monday - Sunday)',
      phone: '03-7958 6219',
      rating: 4.5,
      priceRange: '\$\$',
      amenities: ['Massage', 'Facial', 'Body Scrub'],
      isOpen24Hours: false,
    ),
    ItemData(
      title: 'Lavish Spa',
      imageUrl: 'https://www.klangvalley4locals.com.my/assets/img/spakv/2.jpg',
      location:
          'Lot 5-02-06, 179, Jalan Gading, Bukit Bintang, 55100 Kuala Lumpur',
      hours: 'Open for 24 hours',
      phone: '+603-2148 5888',
      rating: 4.8,
      priceRange: '\$\$\$',
      amenities: ['24/7 Service', 'Couple Spa', 'Hot Stone'],
      isOpen24Hours: true,
    ),
    ItemData(
      title: 'Swasana Spa',
      imageUrl: 'https://www.klangvalley4locals.com.my/assets/img/spakv/4.jpg',
      location:
          'Impiana @ Klcc Hotel, No. 13, Jalan Pinang, Kuala Lumpur, 50450 Kuala Lumpur, Wilayah Persekutuan',
      hours: '10.00 am - 10.00 pm (Monday - Sunday)',
      phone: '+603-2147 1111',
      rating: 4.7,
      priceRange: '\$\$\$',
      amenities: ['Luxury Suite', 'Aromatherapy', 'Sauna'],
      isOpen24Hours: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? saved = prefs.getStringList('favorite_spa');
    if (saved != null) {
      setState(() {
        favoriteSpa = saved;
      });
    }
  }

  Future<void> _toggleFavorite(String title) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (favoriteSpa.contains(title)) {
        favoriteSpa.remove(title);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Removed from favorites'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 1),
          ),
        );
      } else {
        favoriteSpa.add(title);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Added to favorites! 💆‍♀️'),
            backgroundColor: const Color(0xFF25D366),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    });
    await prefs.setStringList('favorite_spa', favoriteSpa);
  }

  List<ItemData> get filteredItems {
    var items = spaItems;

    // Apply favorites filter
    if (showFavoritesOnly) {
      items = items.where((item) => favoriteSpa.contains(item.title)).toList();
    }

    // Apply 24/7 filter
    if (selectedFilter == '24/7') {
      items = items.where((item) => item.isOpen24Hours).toList();
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          S.of(context).spaTime,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 71, 133),
        actions: [
          IconButton(
            icon: Icon(
              showFavoritesOnly ? Icons.favorite : Icons.favorite_border,
              color: showFavoritesOnly ? Colors.red : Colors.white,
            ),
            onPressed: () {
              setState(() {
                showFavoritesOnly = !showFavoritesOnly;
              });
            },
            tooltip: 'Show Favorites Only',
          ),
          const AppBarMore(),
        ],
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
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Relax & Rejuvenate',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Discover premium spa experiences in Klang Valley',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('All', Icons.spa),
                        const SizedBox(width: 8),
                        _buildFilterChip('24/7', Icons.access_time),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Spa List
            Expanded(
              child: filteredItems.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        return _buildSpaCard(filteredItems[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon) {
    final isSelected = selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFFFF8C42), Color(0xFFFF6B9D)],
                )
              : null,
          color: isSelected ? null : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                isSelected ? Colors.transparent : Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: Colors.white,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.spa_outlined,
            size: 80,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            showFavoritesOnly
                ? 'No favorite spas yet'
                : 'No spas match your filters',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            showFavoritesOnly
                ? 'Start adding your favorite spas!'
                : 'Try adjusting your filters',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpaCard(ItemData item) {
    final isFavorite = favoriteSpa.contains(item.title);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A2947),
            const Color(0xFF0D1B2A),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFFF6B9D).withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B9D).withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with badges
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                child: CachedNetworkImage(
                  imageUrl: item.imageUrl,
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                  placeholder: (context, url) => Container(
                    height: 200,
                    color: Colors.grey[900],
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFFFF6B9D)),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 200,
                    color: Colors.grey[900],
                    child: const Icon(Icons.error, color: Colors.red),
                  ),
                ),
              ),
              // Gradient overlay
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
              // 24/7 Badge
              if (item.isOpen24Hours)
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00E676), Color(0xFF00D4FF)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00E676).withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.access_time, size: 14, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          '24/7',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              // Favorite Button
              Positioned(
                top: 16,
                right: 16,
                child: GestureDetector(
                  onTap: () => _toggleFavorite(item.title),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
              // Rating Badge
              Positioned(
                bottom: 12,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Color(0xFFFFB800),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.rating.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Price Badge
              Positioned(
                bottom: 12,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B9D).withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item.priceRange,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Details Section
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                // Amenities Tags
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: item.amenities.map((amenity) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF9C27B0).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF9C27B0).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        amenity,
                        style: const TextStyle(
                          color: Color(0xFFCE93D8),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                _buildInfoRow(
                  Icons.location_on_rounded,
                  item.location,
                  const Color(0xFFFF6B9D),
                ),
                const SizedBox(height: 10),
                _buildInfoRow(
                  Icons.access_time_rounded,
                  item.hours,
                  const Color(0xFF00D4FF),
                ),
                const SizedBox(height: 10),
                _buildInfoRow(
                  Icons.phone_rounded,
                  item.phone,
                  const Color(0xFF00E676),
                ),
                const SizedBox(height: 20),
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _makePhoneCall(item.phone),
                        icon: const Icon(Icons.phone, size: 18),
                        label: const Text('Call Now'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF8C42),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _openMaps(item.location),
                        icon: const Icon(Icons.directions, size: 18),
                        label: const Text('Directions'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFFF6B9D),
                          side: const BorderSide(
                            color: Color(0xFFFF6B9D),
                            width: 2,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
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
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: color,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withOpacity(0.8),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  void _makePhoneCall(String phoneNumber) async {
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('tel:$cleanNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not make phone call')),
      );
    }
  }

  void _openMaps(String location) async {
    final query = Uri.encodeComponent(location);
    final uri =
        Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open maps')),
      );
    }
  }
}

class ItemData {
  final String title;
  final String imageUrl;
  final String location;
  final String hours;
  final String phone;
  final double rating;
  final String priceRange;
  final List<String> amenities;
  final bool isOpen24Hours;

  ItemData({
    required this.title,
    required this.imageUrl,
    required this.location,
    required this.hours,
    required this.phone,
    required this.rating,
    required this.priceRange,
    required this.amenities,
    required this.isOpen24Hours,
  });
}
