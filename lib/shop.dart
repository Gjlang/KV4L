import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:klangvalley4locals/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'generated/l10n.dart';

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  List<String> favoriteShops = [];
  bool showFavoritesOnly = false;
  String selectedCategory = 'All';

  final List<ItemData> shopItems = [
    ItemData(
      title: 'Pavilion Kuala Lumpur',
      imageUrl:
          'https://www.klangvalley4locals.com.my/assets/img/shopkv/pavilion.jpg',
      location:
          'Bukit Bintang, 55100 Kuala Lumpur, Federal Territory of Kuala Lumpur',
      hours: '10.00 am - 10.00 pm (Daily)',
      contact: '03-2118 8833',
      rating: 4.7,
      category: 'Premium',
      features: ['Luxury Brands', 'Fine Dining', 'Entertainment'],
      popularFor: 'High-end shopping',
    ),
    ItemData(
      title: 'Sunway Pyramid',
      imageUrl:
          'https://www.klangvalley4locals.com.my/assets/img/shopkv/sunway.jpg',
      location:
          'No. 3, Jalan PJS 11/15, Sunway City, 47500 Petaling Jaya, Selangor',
      hours: '10.00 am - 10.00 pm (Daily)',
      contact: '03-7494 3100',
      rating: 4.6,
      category: 'Family',
      features: ['Ice Skating', 'Theme Park', 'Arcade'],
      popularFor: 'Family entertainment',
    ),
    ItemData(
      title: 'Paradigm Mall',
      imageUrl:
          'https://www.klangvalley4locals.com.my/assets/img/shopkv/paradigm.jpg',
      location: '1, Jalan SS 7/26a, Ss 7, 47301 Petaling Jaya, Selangor',
      hours: '10.00 am - 10.00 pm (Daily)',
      contact: '03-7801 1188',
      rating: 4.5,
      category: 'Modern',
      features: ['Cinema', 'Food Court', 'Retail'],
      popularFor: 'Urban shopping',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? saved = prefs.getStringList('favorite_shops');
    if (saved != null) {
      setState(() {
        favoriteShops = saved;
      });
    }
  }

  Future<void> _toggleFavorite(String title) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (favoriteShops.contains(title)) {
        favoriteShops.remove(title);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Removed from favorites'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 1),
          ),
        );
      } else {
        favoriteShops.add(title);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Added to shopping list! 🛍️'),
            backgroundColor: const Color(0xFF25D366),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    });
    await prefs.setStringList('favorite_shops', favoriteShops);
  }

  List<ItemData> get filteredItems {
    var items = shopItems;

    // Apply favorites filter
    if (showFavoritesOnly) {
      items =
          items.where((item) => favoriteShops.contains(item.title)).toList();
    }

    // Apply category filter
    if (selectedCategory != 'All') {
      items = items.where((item) => item.category == selectedCategory).toList();
    }

    return items;
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Premium':
        return const Color(0xFFFFB800);
      case 'Family':
        return const Color(0xFF00E676);
      case 'Modern':
        return const Color(0xFF00D4FF);
      default:
        return const Color(0xFFFF8C42);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          S.of(context).placesToShop,
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
                    'Shop Till You Drop',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Discover the best shopping destinations in Klang Valley',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Category Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildCategoryChip('All', Icons.shopping_bag),
                        const SizedBox(width: 8),
                        _buildCategoryChip('Premium', Icons.diamond),
                        const SizedBox(width: 8),
                        _buildCategoryChip('Family', Icons.family_restroom),
                        const SizedBox(width: 8),
                        _buildCategoryChip('Modern', Icons.store),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Shop List
            Expanded(
              child: filteredItems.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        return _buildShopCard(filteredItems[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, IconData icon) {
    final isSelected = selectedCategory == label;
    final color =
        label == 'All' ? const Color(0xFFFF8C42) : _getCategoryColor(label);

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [color, color.withOpacity(0.7)],
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
            Icons.shopping_bag_outlined,
            size: 80,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            showFavoritesOnly
                ? 'No favorite shops yet'
                : 'No shops match your filters',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            showFavoritesOnly
                ? 'Start adding your favorite malls!'
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

  Widget _buildShopCard(ItemData item) {
    final isFavorite = favoriteShops.contains(item.title);
    final categoryColor = _getCategoryColor(item.category);

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
          color: categoryColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: categoryColor.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with overlays
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
                  height: 220,
                  width: double.infinity,
                  placeholder: (context, url) => Container(
                    height: 220,
                    color: Colors.grey[900],
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(categoryColor),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 220,
                    color: Colors.grey[900],
                    child: const Icon(Icons.error, color: Colors.red),
                  ),
                ),
              ),
              // Gradient overlay
              Container(
                height: 220,
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
              // Category Badge
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: categoryColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: categoryColor.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    item.category,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
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
              // Popular Badge
              Positioned(
                bottom: 12,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFFF6B9D),
                        const Color(0xFFFF8C42),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.local_fire_department,
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Popular',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
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
                const SizedBox(height: 8),
                // Popular For Tag
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: categoryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.popularFor,
                    style: TextStyle(
                      color: categoryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Features Tags
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: item.features.map((feature) {
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
                        feature,
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
                  item.contact,
                  const Color(0xFF00E676),
                ),
                const SizedBox(height: 20),
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _makePhoneCall(item.contact),
                        icon: const Icon(Icons.phone, size: 18),
                        label: const Text('Call'),
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
                          foregroundColor: categoryColor,
                          side: BorderSide(color: categoryColor, width: 2),
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
  final String contact;
  final double rating;
  final String category;
  final List<String> features;
  final String popularFor;

  ItemData({
    required this.title,
    required this.imageUrl,
    required this.location,
    required this.hours,
    required this.contact,
    required this.rating,
    required this.category,
    required this.features,
    required this.popularFor,
  });
}
