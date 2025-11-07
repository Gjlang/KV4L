// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:klangvalley4locals/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'generated/l10n.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          // Hero Section with City Skyline
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: const Color.fromARGB(255, 0, 71, 133),
            actions: const <Widget>[
              AppBarMore(),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Klang Valley Highlights',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 2),
                      blurRadius: 8.0,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/KV4L-Splash-Screen.png',
                    fit: BoxFit.cover,
                  ),
                  // Gradient overlay for warm evening tones
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          const Color(0xFF001F3F).withOpacity(0.3),
                          const Color(0xFFFF8C42).withOpacity(0.6),
                          const Color(0xFF0A1128).withOpacity(0.9),
                        ],
                        stops: const [0.0, 0.3, 0.7, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Main Content
          SliverToBoxAdapter(
            child: Container(
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
                  const SizedBox(height: 24),

                  // Welcome Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        Text(
                          'Discover Urban Malaysia',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Experience the vibrant energy of Kuala Lumpur and beyond',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.8),
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Travel Highlights Carousel
                  _buildHighlightsSection(),

                  const SizedBox(height: 32),

                  // About Section with Modern Cards
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).ourCompany,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF1A2947),
                                const Color(0xFF0D1B2A),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF8C42).withOpacity(0.2),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            S.of(context).ourCompanyDescription,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.9),
                              height: 1.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Social Links Section
                  _buildSocialLinksSection(context),

                  const SizedBox(height: 32),

                  // App Version & Copyright
                  _buildFooterSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightsSection() {
    final highlights = [
      {
        'title': 'Petronas Twin Towers',
        'subtitle': 'Iconic skyline landmark',
        'icon': Icons.apartment,
        'color': const Color(0xFF00D4FF),
      },
      {
        'title': 'Batu Caves',
        'subtitle': 'Cultural heritage site',
        'icon': Icons.temple_hindu,
        'color': const Color(0xFFFFB800),
      },
      {
        'title': 'Bukit Bintang',
        'subtitle': 'Shopping & nightlife',
        'icon': Icons.shopping_bag,
        'color': const Color(0xFFFF6B9D),
      },
      {
        'title': 'Night Markets',
        'subtitle': 'Street food paradise',
        'icon': Icons.restaurant,
        'color': const Color(0xFF00E676),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Must-Visit Destinations',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: highlights.length,
            itemBuilder: (context, index) {
              final highlight = highlights[index];
              return Container(
                width: 280,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      (highlight['color'] as Color).withOpacity(0.3),
                      const Color(0xFF0D1B2A),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: (highlight['color'] as Color).withOpacity(0.5),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (highlight['color'] as Color).withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: (highlight['color'] as Color).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          highlight['icon'] as IconData,
                          size: 32,
                          color: highlight['color'] as Color,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        highlight['title'] as String,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        highlight['subtitle'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLinksSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1A2947),
            const Color(0xFF0D1B2A),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            S.of(context).findUs,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSocialIcon(
                Icons.facebook_sharp,
                Colors.blue,
                'https://www.facebook.com/klangvalley4locals/',
              ),
              _buildSocialIcon(
                MyFlutterApp.instagram_1,
                const Color(0xFFE4405F),
                'https://www.instagram.com/klangvalley4locals/',
              ),
              _buildSocialIcon(
                Icons.tiktok,
                Colors.white,
                'https://www.tiktok.com/@klangvalley4locals',
              ),
              _buildSocialIcon(
                Icons.public,
                const Color(0xFF00D4FF),
                'https://www.klangvalley4locals.com.my/',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, Color color, String url) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: color,
          size: 32,
        ),
      ),
    );
  }

  Widget _buildFooterSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF8C42)),
                );
              } else if (snapshot.hasError) {
                return Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(color: Colors.white.withOpacity(0.5)),
                );
              } else {
                String appVersion = snapshot.data!.version;
                String buildNumber = snapshot.data!.buildNumber;
                return Text(
                  'App Version: $appVersion+$buildNumber',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 14,
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 12),
          Text(
            'Copyrighted by: Bluedale Publishing Sdn. Bhd.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

void _launchURL(url) async {
  var url2 = Uri.parse(url);
  if (await canLaunchUrl(url2)) {
    await launchUrl(url2, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $url';
  }
}
