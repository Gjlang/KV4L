import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:klangvalley4locals/main.dart';
import 'package:url_launcher/url_launcher.dart';

import 'explorekl.dart';
import 'generated/l10n.dart';
//import 'package:http/http.dart' as http;
//import 'dart:convert';

class AboutKV extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: const Text("About Klang Valley",
            style: TextStyle(color: Colors.white)),
        // foregroundColor: const Color.fromARGB(255, 0, 71, 133),
        backgroundColor: const Color.fromARGB(255, 0, 71, 133),
        actions: const <Widget>[
          AppBarMore(),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl:
                  'https://www.klangvalley4locals.com.my/assets/img/highlights/about_kv2.jpg',
            ),
            SizedBox(height: 16),
            Text(
              S.of(context).klAtAGlance,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              S.of(context).klDescription1,
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              S.of(context).klDescription2,
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class GetAround extends StatefulWidget {
  const GetAround({super.key});

  @override
  State<GetAround> createState() => _GetAroundState();
}

class _GetAroundState extends State<GetAround> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text("Getting Around Klang Valley",
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 0, 71, 133),
        actions: const <Widget>[
          AppBarMore(),
        ],
      ),
      body: MyList(), // This is where the images and text will be displayed.
    );
  }
}
@override
Widget build(BuildContext context) {
  final List<ItemData> items = [
    ItemData(
      S.of(context).lrtTitle,
      'https://www.kltheguide.com.my/assets/img/highlights/getaround/1.-lrt.png',
      S.of(context).lrtDescription,
    ),
    ItemData(
      S.of(context).mrtTitle,
      'https://www.kltheguide.com.my/assets/img/highlights/getaround/2.-mrt.png',
      S.of(context).mrtDescription,
    ),
    ItemData(
      S.of(context).ktmKomuterTitle,
      'https://www.kltheguide.com.my/assets/img/highlights/getaround/3.-ktm-komuter.png',
      S.of(context).ktmKomuterDescription,
    ),
    ItemData(
      S.of(context).klMonorailTitle,
      'https://www.kltheguide.com.my/assets/img/highlights/getaround/4.-kl-monorail.png',
      S.of(context).klMonorailDescription,
    ),
    ItemData(
      S.of(context).rapidKLBusTitle,
      'https://www.kltheguide.com.my/assets/img/highlights/getaround/5.-rapid-kl-bus.png',
      S.of(context).rapidKLBusDescription,
    ),
  ];

  return ListView.builder(
    itemCount: items.length,
    itemBuilder: (context, index) {
      return Card(
        elevation: 3.0,
        margin: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                items[index].imageUrl,
                fit: BoxFit.cover,
                height: 200,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    items[index].text,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    items[index].content,
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
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


class ItemData {
  final String text;
  final String imageUrl;
  final String content;

  ItemData(this.text, this.imageUrl, this.content);
}

class ItemData2 {
  final String text;
  final String imageUrl;
  final String content;
  final String goto;

  ItemData2(this.text, this.imageUrl, this.content, this.goto);
}

class TravelTips extends StatefulWidget {
  const TravelTips({super.key});

  @override
  State<TravelTips> createState() => _TravelTipsState();
}

class _TravelTipsState extends State<TravelTips> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: const Text("Travel Tips", style: TextStyle(color: Colors.white)),
        // foregroundColor: const Color.fromARGB(255, 0, 71, 133),
        backgroundColor: const Color.fromARGB(255, 0, 71, 133),
        actions: const <Widget>[
          AppBarMore(),
        ],
      ),
      body: MyList2(),
    );
  }
}

class MyList2 extends StatelessWidget {
  const MyList2({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ItemData2> items = [
      ItemData2(
        S.of(context).weatherTitle,
        'https://www.kltheguide.com.my/assets/img/highlights/traveltips/weather.png',
        S.of(context).weatherDescription,
        'https://www.ventusky.com/',
      ),
      ItemData2(
        S.of(context).timeZoneTitle,
        'https://www.kltheguide.com.my/assets/img/highlights/traveltips/timezone.png',
        S.of(context).timeZoneDescription,
        'https://www.timeanddate.com/',
      ),
      ItemData2(
        S.of(context).currencyTitle,
        'https://www.kltheguide.com.my/assets/img/highlights/traveltips/currency-code.png',
        S.of(context).currencyDescription,
        'https://www.xe.com/',
      ),
      ItemData2(
        S.of(context).visaAndPassportTitle,
        'https://www.kltheguide.com.my/assets/img/highlights/traveltips/visa-and-passports.png',
        S.of(context).visaAndPassportDescription,
        'https://www.imi.gov.my/',
      ),
    ];


    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _launchURL(items[index].goto),
          child: Card(
            elevation: 3.0, // Adjust the elevation as needed
            margin: const EdgeInsets.all(16.0), // Adjust the margin as needed
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.network(
                    items[index].imageUrl,
                    fit: BoxFit.cover,
                    height: 200,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(
                      16.0), // Adjust the padding as needed
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        items[index].text,
                        style: const TextStyle(
                          fontSize: 20.0, // Adjust the font size as needed
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                          height: 8.0), // Add spacing between title and content
                      Text(
                        items[index].content,
                        style: const TextStyle(
                            fontSize: 16.0), // Adjust the font size as needed
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ApiData {
  final String title;
  final String content;
  final String image;
  final String location;

  ApiData({
    required this.location,
    required this.title,
    required this.content,
    required this.image,
  });

  factory ApiData.fromJson(Map<String, dynamic> json) {
    return ApiData(
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      image: json['image'] ?? '',
      location: json['location'] ?? '',
    );
  }
}

class CardListWidget extends StatelessWidget {
  final List<ApiData> data;

  const CardListWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];

        return GestureDetector(
          onTap: () {
            // print(item.location);
            if (item.location != '') {
              _launchURL(item.location);
            }
          },
          child: Card(
            elevation: 4.0,
            margin: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: item.image,
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (item.title),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(item.content.replaceAll('\\n', '\n')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CardItem extends StatelessWidget {
  final String name;
  final String image;
  final int index;

  const CardItem(
      {super.key,
      required this.name,
      required this.image,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.all(10),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(image),
                fit: BoxFit.cover, // Make the image cover the entire card
              ),
            ),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.black
                    .withOpacity(0.5), // Adjust the opacity as needed
                child: Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
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
