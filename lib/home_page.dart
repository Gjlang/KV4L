import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:klangvalley4locals/main.dart';

import 'generated/l10n.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  final List<String> imagesHighlights = [
    'https://www.klangvalley4locals.com.my/assets/img/highlights/about_kv2.jpg',
    'https://www.klangvalley4locals.com.my/assets/img/highlights/getting_around.jpg',
    'https://www.klangvalley4locals.com.my/assets/img/highlights/bukitbintang.jpg',
  ];

  final List<String> titlesHighlights = [
    'About Klang Valley',
    'Getting Around KV',
    'Travel Tips',
  ];

  final List<String> imagesRmd = [
    'https://www.kltheguide.com.my/assets/img/recommendation/where-to-shop-in-kl.png',
    'https://www.kltheguide.com.my/assets/img/recommendation/9.nightout.png',
    'https://www.kltheguide.com.my/assets/img/recommendation/places-to-stay-in-kl.jpg',
    'https://www.kltheguide.com.my/assets/img/recommendation/Spa.jpg',
    'https://www.kltheguide.com.my/assets/img/recommendation/11.medical-tourism.png',
  ];

  @override
  Widget build(BuildContext context) {
    final List<String> titlesHighlights = [
      S.of(context).klAtAGlance,
      S.of(context).gettingAroundKL,
      S.of(context).travelTips,
    ];

    final List<String> titlesRmd = [
      S.of(context).exploreKL,
      S.of(context).shopLikeLocals,
      S.of(context).placesToStay,
      S.of(context).spaTime,
      S.of(context).medicalTourism,
      S.of(context).beyondKL,
    ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1a237e),
              Color(0xFF0d47a1),
              Color(0xFF01579b),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Hero Section with Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF0d47a1),
                      Color(0xFFf57c00),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    // Social Media Icons - Modern Circular Design
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildSocialIcon(
                            Icons.facebook_sharp,
                            Color(0xFF1877F2),
                            'https://www.facebook.com/klangvalley4locals/',
                          ),
                          _buildSocialIcon(
                            MyFlutterApp.instagram_1,
                            Color(0xFFE4405F),
                            'https://www.instagram.com/klangvalley4locals/',
                          ),
                          _buildSocialIcon(
                            MyFlutterApp.whatsapp,
                            Color(0xFF25D366),
                            'https://api.whatsapp.com/send?phone=60122200622',
                          ),
                          _buildSocialIcon(
                            Icons.tiktok,
                            Colors.black,
                            'https://www.tiktok.com/@klangvalley4locals',
                          ),
                          _buildSocialIcon(
                            Icons.public,
                            Color(0xFFFF9800),
                            'https://www.klangvalley4locals.com.my/',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Main Content Area
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 24),

                    // Highlights Section Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: [
                          Container(
                            width: 4,
                            height: 28,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Color(0xFFf57c00), Color(0xFFff6f00)],
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            S.of(context).klHighlights,
                            style: TextStyle(
                              color: Color(0xFF1a237e),
                              fontSize: 26.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),
                    ImageCarousel(
                        images: imagesHighlights, titles: titlesHighlights),

                    SizedBox(height: 32),

                    // Recommendations Section Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: [
                          Container(
                            width: 4,
                            height: 28,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Color(0xFFf57c00), Color(0xFFff6f00)],
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            S.of(context).recommendations,
                            style: TextStyle(
                              color: Color(0xFF1a237e),
                              fontSize: 26.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),
                    ImageCarousel2(images: imagesRmd, titles: titlesRmd),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, Color color, String url) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: color,
          size: 28,
        ),
      ),
    );
  }
}

class ImageCarousel extends StatefulWidget {
  final List<String> images;
  final List<String> titles;

  const ImageCarousel({
    super.key,
    required this.images,
    required this.titles,
  });

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CarouselSlider.builder(
          itemCount: widget.images.length,
          itemBuilder: (BuildContext context, int index, int realIndex) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/highlights-$index',
                        arguments: {'index': index, 'titles': widget.titles});
                  },
                  child: Stack(
                    children: <Widget>[
                      CachedNetworkImage(
                        imageUrl: widget.images[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        placeholder: (context, url) => Container(
                          height: 320,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF0d47a1),
                                Color(0xFFf57c00),
                              ],
                            ),
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Color(0xFF0d47a1),
                          child:
                              Icon(Icons.error, color: Colors.white, size: 40),
                        ),
                      ),
                      // Gradient Overlay
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
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
                      ),
                      // Title with modern styling
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Color(0xFFf57c00),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'EXPLORE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                widget.titles[index],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.5),
                                      offset: Offset(0, 2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: 320,
            viewportFraction: 0.85,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            enlargeFactor: 0.15,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.images.asMap().entries.map((entry) {
            return Container(
              width: _currentIndex == entry.key ? 24.0 : 8.0,
              height: 8.0,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: _currentIndex == entry.key
                    ? Color(0xFFf57c00)
                    : Colors.grey.withOpacity(0.4),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class ImageCarousel2 extends StatefulWidget {
  final List<String> images;
  final List<String> titles;

  const ImageCarousel2({
    super.key,
    required this.images,
    required this.titles,
  });

  @override
  State<ImageCarousel2> createState() => _ImageCarouselState2();
}

class _ImageCarouselState2 extends State<ImageCarousel2> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CarouselSlider.builder(
          itemCount: widget.images.length,
          itemBuilder: (BuildContext context, int index, int realIndex) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/rmd-$index',
                        arguments: {'index': index, 'titles': widget.titles});
                  },
                  child: Stack(
                    children: <Widget>[
                      CachedNetworkImage(
                        imageUrl: widget.images[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        placeholder: (context, url) => Container(
                          height: 200,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF0d47a1),
                                Color(0xFFf57c00),
                              ],
                            ),
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Color(0xFF0d47a1),
                          child:
                              Icon(Icons.error, color: Colors.white, size: 32),
                        ),
                      ),
                      // Gradient Overlay
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.6),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Title Card
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            widget.titles[index],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.5),
                                  offset: Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: 200,
            viewportFraction: 0.85,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            enlargeFactor: 0.15,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.images.asMap().entries.map((entry) {
            return Container(
              width: _currentIndex == entry.key ? 24.0 : 8.0,
              height: 8.0,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: _currentIndex == entry.key
                    ? Color(0xFFf57c00)
                    : Colors.grey.withOpacity(0.4),
              ),
            );
          }).toList(),
        ),
      ],
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
