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
    // Add more image URLs as needed
  ];

  final List<String> titlesHighlights = [
    'About Klang Valley',
    'Getting Around KV',
    'Travel Tips',
    // Add more titles corresponding to image URLs
  ];

  final List<String> imagesRmd = [
    'https://www.kltheguide.com.my/assets/img/recommendation/where-to-shop-in-kl.png',
    'https://www.kltheguide.com.my/assets/img/recommendation/9.nightout.png',
    'https://www.kltheguide.com.my/assets/img/recommendation/places-to-stay-in-kl.jpg',
    'https://www.kltheguide.com.my/assets/img/recommendation/Spa.jpg',
    'https://www.kltheguide.com.my/assets/img/recommendation/11.medical-tourism.png',

    // Add more image URLs as needed
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly, // Ensures even spacing
                children: [
                  GestureDetector(
                    child: const Icon(
                      Icons.facebook_sharp,
                      color: Colors.blue,
                      size: 48,
                    ),
                    onTap: () => _launchURL(
                        'https://www.facebook.com/klangvalley4locals/'),
                  ),
                  GestureDetector(
                    child: const Icon(
                      MyFlutterApp.instagram_1,
                      color: Colors.pink,
                      size: 48,
                    ),
                    onTap: () => _launchURL(
                        'https://www.instagram.com/klangvalley4locals/'),
                  ),
                  GestureDetector(
                    child: const Icon(
                      MyFlutterApp.whatsapp,
                      color: Colors.green,
                      size: 48,
                    ),
                    onTap: () => _launchURL(
                        'https://api.whatsapp.com/send?phone=60122200622'),
                  ),
                  GestureDetector(
                    child: const Icon(
                      Icons.tiktok,
                      size: 48,
                    ),
                    onTap: () => _launchURL(
                        'https://www.tiktok.com/@klangvalley4locals'),
                  ),
                  GestureDetector(
                    child: const Icon(
                      Icons.public,
                      color: Colors.grey,
                      size: 48,
                    ),
                    onTap: () =>
                        _launchURL('https://www.klangvalley4locals.com.my/'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                S.of(context).klHighlights,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ImageCarousel(images: imagesHighlights, titles: titlesHighlights),
             Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                S.of(context).recommendations,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ImageCarousel2(images: imagesRmd, titles: titlesRmd),
            // Continue adding more widgets for scrollable content
          ],
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
  // ignore: unused_field
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CarouselSlider.builder(
          itemCount: widget.images.length,
          itemBuilder: (BuildContext context, int index, int realIndex) {
            return Stack(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/highlights-$index',
                        arguments: {'index': index, 'titles': widget.titles});
                  },
                  child: CachedNetworkImage(
                    imageUrl: widget.images[index],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 300,
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                Positioned(
                  bottom: 30.0,
                  left: 10.0,
                  right: 10.0,
                  child: Container(
                    color:
                        Colors.black.withOpacity(0.5), // Faded black background
                    child: Center(
                      // Center the text within the container
                      child: Text(
                        widget.titles[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          options: CarouselOptions(
            height: 300,
            // aspectRatio: 16/9,
            viewportFraction: 0.8,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            enlargeFactor: 0.3,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.images.map((image) {
            int index = widget.images.indexOf(image);
            return Container(
              width: 8.0,
              height: 8.0,
              margin:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index ? Colors.blue : Colors.grey,
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
  // ignore: unused_field
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CarouselSlider.builder(
          itemCount: widget.images.length,
          itemBuilder: (BuildContext context, int index, int realIndex) {
            return Stack(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/rmd-$index',
                        arguments: {'index': index, 'titles': widget.titles});
                  },
                  child: CachedNetworkImage(
                    imageUrl: widget.images[index],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      child: Center(child: CircularProgressIndicator()),
                      height: 180,
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                Positioned(
                  bottom: 30.0,
                  left: 10.0,
                  right: 10.0,
                  child: Container(
                    color:
                        Colors.black.withOpacity(0.5), // Faded black background
                    child: Center(
                      // Center the text within the container
                      child: Text(
                        widget.titles[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          options: CarouselOptions(
            height: 180,
            aspectRatio: 16 / 9,
            viewportFraction: 0.8,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            enlargeFactor: 0.3,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.images.map((image) {
            int index = widget.images.indexOf(image);
            return Container(
              width: 8.0,
              height: 8.0,
              margin:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index ? Colors.blue : Colors.grey,
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
