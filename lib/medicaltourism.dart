import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:klangvalley4locals/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'generated/l10n.dart';

class MedicalT extends StatefulWidget {
  const MedicalT({super.key});

  @override
  _MedicalTState createState() => _MedicalTState();
}

class _MedicalTState extends State<MedicalT>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<String> favoriteClinics = [];
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
    final List<String>? saved = prefs.getStringList('favorite_clinics');
    if (saved != null) {
      setState(() {
        favoriteClinics = saved;
      });
    }
  }

  Future<void> _toggleFavorite(String title) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (favoriteClinics.contains(title)) {
        favoriteClinics.remove(title);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Removed from favorites'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 1),
          ),
        );
      } else {
        favoriteClinics.add(title);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Added to healthcare list! 🏥'),
            backgroundColor: const Color(0xFF25D366),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    });
    await prefs.setStringList('favorite_clinics', favoriteClinics);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Medical Tourism",
          style: TextStyle(
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
          indicatorColor: const Color(0xFF00E676),
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
          tabs: [
            Tab(text: S.of(context).healthcare),
            Tab(text: S.of(context).dental),
            Tab(text: S.of(context).dermatologist),
            Tab(text: S.of(context).ophthalmologist),
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
            _buildMedicalList(
              category: 'Healthcare',
              categoryColor: const Color(0xFF00E676),
              icon: Icons.local_hospital,
              items: [
                ItemData(
                  title: 'Hospital Serdang',
                  imageUrl:
                      'https://www.klangvalley4locals.com.my/assets/img/medical_tourism/hc/hospital-serdang.jpg',
                  location: 'Jalan Puchong, 43000 Kajang, Selangor',
                  hours: 'Open 24 hours',
                  phone: '03-8947 5555',
                  rating: 4.6,
                  specialties: ['Emergency Care', 'Surgery', 'ICU'],
                  is24Hours: true,
                ),
                ItemData(
                  title: 'Colombia Asia Hospital',
                  imageUrl:
                      'https://www.klangvalley4locals.com.my/assets/img/medical_tourism/hc/columbia-hospital.jpg',
                  location:
                      'No 1, Jalan Danau Saujana, Off Jalan Genting Klang, 53300 Kuala, Malaysia',
                  hours: 'Open 24 hours',
                  phone: '03-7949 9999',
                  rating: 4.7,
                  specialties: ['Cardiology', 'Oncology', 'Orthopedics'],
                  is24Hours: true,
                ),
                ItemData(
                  title: 'Pantai Hospital Klang',
                  imageUrl:
                      'https://www.klangvalley4locals.com.my/assets/img/medical_tourism/hc/pantai-hospital-klang.jpg',
                  location:
                      'Lot 5921, Persiaran Raja Muda Musa, Taman Radzi, 41200 Klang, Selangor',
                  hours: 'Open 24 hours',
                  phone: '03-3258 5500',
                  rating: 4.5,
                  specialties: ['Maternity', 'Pediatrics', 'General Care'],
                  is24Hours: true,
                ),
              ],
            ),
            _buildMedicalList(
              category: 'Dental',
              categoryColor: const Color(0xFF00D4FF),
              icon: Icons.medical_services,
              items: [
                ItemData(
                  title: 'M Dental Clinic Damansara Uptown',
                  imageUrl:
                      'https://www.klangvalley4locals.com.my/assets/img/medical_tourism/dtl/m_dental.jpg',
                  location:
                      '11A-B, Jalan SS21/60, Damansara Utama, 47400 Petaling Jaya, Selangor',
                  hours:
                      '9.00 am - 8.30 pm (Monday - Friday), 9.00 am - 5.00 pm (Saturday & Sunday)',
                  phone: '6018-211 8328',
                  rating: 4.8,
                  specialties: ['Teeth Whitening', 'Braces', 'Implants'],
                  is24Hours: false,
                ),
                ItemData(
                  title: 'Klinik Pergigian Lee & Jay',
                  imageUrl:
                      'https://www.klangvalley4locals.com.my/assets/img/medical_tourism/dtl/lee_jay.jpg',
                  location:
                      '7-0-0, Lorong Batu Nilam 10A, Bandar Bukit Tinggi 1, 41200 Klang, Selangor',
                  hours:
                      '9.00 am - 9.00 pm (Monday - Friday), 9.00 am - 7.00 pm (Saturday), 9.00 am - 4.00 pm (Sunday)',
                  phone: '+6012-655 9077',
                  rating: 4.6,
                  specialties: ['Family Dentistry', 'Root Canal', 'Extraction'],
                  is24Hours: false,
                ),
                ItemData(
                  title: 'SmileGram Dental Clinic',
                  imageUrl:
                      'https://www.klangvalley4locals.com.my/assets/img/medical_tourism/dtl/smilegram.jpg',
                  location:
                      'First floor, No. 10A-2, Jalan 14/20, 46100 Petaling Jaya, Selangor',
                  hours: '9.30 am - 9.30 pm (Monday - Sunday)',
                  phone: '6013-252 9813',
                  rating: 4.7,
                  specialties: ['Cosmetic Dentistry', 'Veneers', 'Crowns'],
                  is24Hours: false,
                ),
              ],
            ),
            _buildMedicalList(
              category: 'Dermatology',
              categoryColor: const Color(0xFFFF6B9D),
              icon: Icons.face_retouching_natural,
              items: [
                ItemData(
                  title: 'Medii Skin Studio PJ',
                  imageUrl:
                      'https://www.klangvalley4locals.com.my/assets/img/medical_tourism/der/medii_skin.png',
                  location:
                      'D-65-1, Jaya One, 72a, Jln Profesor Diraja Ungku Aziz, Pjs 13, 46200 Petaling Jaya, Selangor',
                  hours:
                      '10.00 am - 7.00 pm (Monday - Saturday), Closed on Sunday',
                  phone: '+6010-343 1491',
                  rating: 4.8,
                  specialties: ['Laser Treatment', 'Anti-Aging', 'Acne Care'],
                  is24Hours: false,
                ),
                ItemData(
                  title: 'Dermlaze Skin Laser & Aesthetics Centre',
                  imageUrl:
                      'https://www.kltheguide.com.my/assets/img/medical_tourism/der/Dermlaze.jpeg',
                  location:
                      '75, Jalan SS 21/60, Damansara Utama, 47400 Petaling Jaya, Selangor',
                  hours: '10.00 AM - 06.00 PM (Mon - Sat)',
                  phone: '03-7733 6688',
                  rating: 4.7,
                  specialties: ['Laser Therapy', 'Skin Rejuvenation', 'Botox'],
                  is24Hours: false,
                ),
                ItemData(
                  title: 'Dr Kent Clinic',
                  imageUrl:
                      'https://www.klangvalley4locals.com.my/assets/img/medical_tourism/der/dr_kent.jpg',
                  location:
                      '51C, Jalan SS 21/37, Damansara Utama, 47410 Petaling Jaya, Selangor',
                  hours: '10.00 AM - 06.00 PM (Mon - Sat)',
                  phone: '+603-8052 3082',
                  rating: 4.6,
                  specialties: [
                    'Skin Treatment',
                    'Aesthetic Procedures',
                    'Consultation'
                  ],
                  is24Hours: false,
                ),
              ],
            ),
            _buildMedicalList(
              category: 'Eye Care',
              categoryColor: const Color(0xFFFFB800),
              icon: Icons.remove_red_eye,
              items: [
                ItemData(
                  title: 'Eye Trend Optical Specialist Centre',
                  imageUrl:
                      'https://www.klangvalley4locals.com.my/assets/img/medical_tourism/oph/eye_trend.png',
                  location:
                      '35, Jalan Plumbum Y 7/Y, Seksyen 7, 40000 Shah Alam, Selangor',
                  hours:
                      '11.00 am - 9.30 pm (Saturday - Thursday), Closed on Friday',
                  phone: '+6016-314 9216',
                  rating: 4.7,
                  specialties: ['Eye Exams', 'Contact Lenses', 'Eyewear'],
                  is24Hours: false,
                ),
                ItemData(
                  title: 'Vista Eye Specialist',
                  imageUrl:
                      'https://www.kltheguide.com.my/assets/img/medical_tourism/oph/vista.jpg',
                  location:
                      'Lot G217, Ground Floor, Mid Valley Megamall, 59200 KL',
                  hours: 'Mon-Sun: 10:00 AM - 10:00 PM',
                  phone: '+603-22423937',
                  rating: 4.8,
                  specialties: ['Cataract Surgery', 'LASIK', 'Glaucoma Care'],
                  is24Hours: false,
                ),
                ItemData(
                  title: 'TOPVISION Eye Specialist Centre',
                  imageUrl:
                      'https://www.klangvalley4locals.com.my/assets/img/medical_tourism/oph/top_vision.jpg',
                  location:
                      'Unit 11-2,3 & 5, No. 2 Block 2, Jalan Setia Prima (S) U13/S, Seksyen U13, Setia Alam, 40170 Shah Alam, Selangor',
                  hours: '9.00 am - 4.00 pm (Monday - Sunday)',
                  phone: '+603-3343 9911',
                  rating: 4.6,
                  specialties: [
                    'Eye Surgery',
                    'Pediatric Eye Care',
                    'Retina Care'
                  ],
                  is24Hours: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicalList({
    required String category,
    required Color categoryColor,
    required IconData icon,
    required List<ItemData> items,
  }) {
    final filteredItems = showFavoritesOnly
        ? items.where((item) => favoriteClinics.contains(item.title)).toList()
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
        final isFavorite = favoriteClinics.contains(item.title);

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
                      height: 200,
                      width: double.infinity,
                      placeholder: (context, url) => Container(
                        height: 200,
                        color: Colors.grey[900],
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(categoryColor),
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
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(icon, size: 14, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            category,
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
                  // 24/7 Badge
                  if (item.is24Hours)
                    Positioned(
                      top: 16,
                      right: 60,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF6B9D), Color(0xFFFF8C42)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF6B9D).withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.access_time,
                                size: 12, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              '24/7',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
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
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Specialties Tags
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: item.specialties.map((specialty) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: categoryColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: categoryColor.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            specialty,
                            style: TextStyle(
                              color: categoryColor.withAlpha(230),
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
                    if (item.phone.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      _buildInfoRow(
                        Icons.phone_rounded,
                        item.phone,
                        const Color(0xFF00E676),
                      ),
                    ],
                    const SizedBox(height: 20),
                    // Action Buttons
                    Row(
                      children: [
                        if (item.phone.isNotEmpty)
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _makePhoneCall(item.phone),
                              icon: const Icon(Icons.phone, size: 18),
                              label: const Text('Call'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: categoryColor,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                            ),
                          ),
                        if (item.phone.isNotEmpty) const SizedBox(width: 12),
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
  final List<String> specialties;
  final bool is24Hours;

  ItemData({
    required this.title,
    required this.imageUrl,
    required this.location,
    required this.hours,
    required this.phone,
    required this.rating,
    required this.specialties,
    required this.is24Hours,
  });
}
