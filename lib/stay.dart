import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:klangvalley4locals/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'generated/l10n.dart';

class Stay extends StatefulWidget {
  const Stay({super.key});

  @override
  _StayState createState() => _StayState();
}

class _StayState extends State<Stay> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<String> favoriteStays = [];
  bool showFavoritesOnly = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadFavorites();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? saved = prefs.getStringList('favorite_stays');
    if (saved != null) {
      setState(() {
        favoriteStays = saved;
      });
    }
  }

  Future<void> _toggleFavorite(String title) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (favoriteStays.contains(title)) {
        favoriteStays.remove(title);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Removed from favorites'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 1),
          ),
        );
      } else {
        favoriteStays.add(title);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Added to favorites! ❤️'),
            backgroundColor: const Color(0xFF25D366),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    });
    await prefs.setStringList('favorite_stays', favoriteStays);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          S.of(context).placesToStay,
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
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: const Color(0xFFFF8C42),
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
          tabs: [
            Tab(text: S.of(context).topPlacesToStay),
            Tab(text: S.of(context).hotels),
            Tab(text: S.of(context).budgetHotels),
            Tab(text: S.of(context).backpackersLodge),
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
            _buildStayList(
              category: 'Luxury',
              categoryColor: const Color(0xFFFFB800),
              items: [
                ItemData(
                  title: 'Bangi Resort Hotel',
                  imageUrl:
                      'https://www.klangvalley4locals.com.my/assets/img/accommodation/lux/bangi.jpg',
                  location:
                      'Off, Persiaran Bandar, Bangi Golf Club, 43650 Bandar Baru Bangi, Selangor',
                  contact: '+603-8210 2222',
                  rating: 4.5,
                  priceRange: '\$\$\$',
                ),
                ItemData(
                  title: 'Citadines DPulze Cyberjaya',
                  imageUrl:
                      'https://www.klangvalley4locals.com.my/assets/img/accommodation/lux/citadines.jpg',
                  location:
                      'Lingkaran Cyber Point Timur, Cyber 12, 63000 Cyberjaya, Selangor',
                  contact: '+603-8689 9888',
                  rating: 4.6,
                  priceRange: '\$\$\$',
                ),
                ItemData(
                  title: 'Dorsett Putrajaya',
                  imageUrl:
                      'https://www.klangvalley4locals.com.my/assets/img/accommodation/lux/dorsett.jpg',
                  location: 'Precinct 3, 62000 Putrajaya',
                  contact: '+603-8892 8388',
                  rating: 4.7,
                  priceRange: '\$\$\$',
                ),
              ],
            ),
            _buildStayList(
              category: 'Hotels',
              categoryColor: const Color(0xFF00D4FF),
              items: [
                ItemData(
                  title: 'Mesra Boutique Hotel',
                  imageUrl:
                      'https://www.klangvalley4locals.com.my/assets/img/accommodation/bud/mesra.jpg',
                  location:
                      'No 3 & 4, Teluk Kemang Square Bt 7 Jalan Pantai Teluk Kemang Port Dickson, 71050 Teluk Kemang, Negeri Sembilan',
                  contact: '+606-662 6229',
                  rating: 4.3,
                  priceRange: '\$\$',
                ),
                ItemData(
                  title: 'D\'Metro Hotel',
                  imageUrl:
                      'https://www.klangvalley4locals.com.my/assets/img/accommodation/bud/d_metro.jpg',
                  location:
                      'Jalan Nelayan 19/D, Seksyen 19, 40300 Shah Alam, Selangor',
                  contact: '+603-5545 2693',
                  rating: 4.2,
                  priceRange: '\$\$',
                ),
                ItemData(
                  title: 'GoodHope Hotel',
                  imageUrl:
                      'https://www.klangvalley4locals.com.my/assets/img/accommodation/bud/goodhope.jpg',
                  location:
                      'Persiaran Akuatik, Seksyen 13, 40100 Shah Alam, Selangor',
                  contact: '+603-5512 2828',
                  rating: 4.4,
                  priceRange: '\$\$',
                ),
              ],
            ),
            _buildStayList(
              category: 'Nature',
              categoryColor: const Color(0xFF00E676),
              items: [
                ItemData(
                  title: 'Tadom Hill Resort',
                  imageUrl:
                      'https://www.klangvalley4locals.com.my/assets/img/accommodation/nat/tadom.jpg',
                  location:
                      'No.2, Jalan Bukit Tadom, (Kampung Orang Asli) Kampung Labohan Dagang, 42700 Banting, Selangor',
                  contact: '+6012-522 5728',
                  rating: 4.8,
                  priceRange: '\$\$',
                ),
                ItemData(
                  title: 'Tanah Larwina',
                  imageUrl:
                      'https://www.klangvalley4locals.com.my/assets/img/accommodation/nat/tanah_larwina.jpg',
                  location:
                      'Batu 23, Jalan Sungai Lui, Kampung Paya Lebar, 43100 Hulu Langat, Selangor',
                  contact: '+60175997665',
                  rating: 4.7,
                  priceRange: '\$\$',
                ),
                ItemData(
                  title: 'Sekeping Serendah',
                  imageUrl:
                      'https://www.klangvalley4locals.com.my/assets/img/accommodation/nat/sekeping.jpg',
                  location: '48200 Serendah, Selangor',
                  contact: '+6016-367 0067',
                  rating: 4.6,
                  priceRange: '\$\$',
                ),
              ],
            ),
            _buildStayList(
              category: 'Homestay',
              categoryColor: const Color(0xFFFF6B9D),
              items: [
                ItemData(
                  title: 'The Garden Homestay',
                  imageUrl:
                      'https://www.klangvalley4locals.com.my/assets/img/accommodation/home/the_garden.jpg',
                  location: 'Jalan Angsana, Templer Villas, 48000, Selangor',
                  contact: '+6014-968 7306',
                  rating: 4.5,
                  priceRange: '\$',
                ),
                ItemData(
                  title: 'Homestay Sungai Sireh',
                  imageUrl:
                      'https://www.klangvalley4locals.com.my/assets/img/accommodation/home/sungai_sireh.jpg',
                  location:
                      'Jalan Parit Satu Sungai Sireh, 45500 Tanjong Karang, Selangor',
                  contact: '+603-3269 2400',
                  rating: 4.4,
                  priceRange: '\$',
                ),
                ItemData(
                  title: 'Homestay Pachitan',
                  imageUrl:
                      'https://www.klangvalley4locals.com.my/assets/img/accommodation/home/pachitan.jpg',
                  location: 'Kampung Pachitan, Chuah, 71960 Port Dickson',
                  contact: '+6019-385 9793',
                  rating: 4.3,
                  priceRange: '\$',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStayList({
    required String category,
    required Color categoryColor,
    required List<ItemData> items,
  }) {
    final filteredItems = showFavoritesOnly
        ? items.where((item) => favoriteStays.contains(item.title)).toList()
        : items;

    if (showFavoritesOnly && filteredItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80,
              color: Colors.white.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No favorites in this category',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        final isFavorite = favoriteStays.contains(item.title);

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
            borderRadius: BorderRadius.circular(20),
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
              // Image with Category Badge and Favorite Button
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
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
                  // Gradient overlay for better text visibility
                  Container(
                    height: 220,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
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
                        color: categoryColor.withOpacity(0.9),
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
                        category,
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
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          shape: BoxShape.circle,
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
                  // Price Range Badge
                  Positioned(
                    bottom: 12,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00E676).withOpacity(0.9),
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
                    _buildInfoRow(
                      Icons.location_on_rounded,
                      item.location,
                      const Color(0xFFFF6B9D),
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      Icons.phone_rounded,
                      item.contact,
                      const Color(0xFF00D4FF),
                    ),
                    const SizedBox(height: 16),
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
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
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
                              padding: const EdgeInsets.symmetric(vertical: 12),
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
      },
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
              fontSize: 14,
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
  final String contact;
  final double rating;
  final String priceRange;

  ItemData({
    required this.title,
    required this.imageUrl,
    required this.location,
    required this.contact,
    required this.rating,
    required this.priceRange,
  });
}
