import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:klangvalley4locals/main.dart';
import 'package:url_launcher/url_launcher.dart';

import 'generated/l10n.dart';

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(S.of(context).placesToShop,
            style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 0, 71, 133),
        actions: const <Widget>[
          AppBarMore(),
        ],
      ),
      body: MyList2(
        items: [
          ItemData(
            title: 'Pavilion Kuala Lumpur',
            imageUrl:
                'https://www.klangvalley4locals.com.my/assets/img/shopkv/pavilion.jpg',
            location:
                'Bukit Bintang, 55100 Kuala Lumpur, Federal Territory of Kuala Lumpur',
            hours: '10.00 am - 10.00 pm (Daily)',
            contact: '03-2118 8833',
          ),
          ItemData(
            title: 'Sunway Pyramid',
            imageUrl:
                'https://www.klangvalley4locals.com.my/assets/img/shopkv/sunway.jpg',
            location:
                'No. 3, Jalan PJS 11/15, Sunway City, 47500 Petaling Jaya, Selangor',
            hours: '10.00 am - 10.00 pm (Daily)',
            contact: '03-7494 3100',
          ),
          ItemData(
            title: 'Paradigm Mall',
            imageUrl:
                'https://www.klangvalley4locals.com.my/assets/img/shopkv/paradigm.jpg',
            location: '1, Jalan SS 7/26a, Ss 7, 47301 Petaling Jaya, Selangor',
            hours: '10.00 am - 10.00 pm (Daily)',
            contact: '03-7801 1188',
          ),
          // Add more shops here as needed
        ],
      ),
    );
  }
}

class MyList2 extends StatelessWidget {
  final List<ItemData> items;

  MyList2({required this.items});

  @override
  Widget build(BuildContext context) {
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
                child: CachedNetworkImage(
                  imageUrl: items[index].imageUrl,
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      items[index].title,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Location: ${items[index].location}',
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Operating Hours: ${items[index].hours}',
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Contact: ${items[index].contact}',
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        decoration: TextDecoration.underline,
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

  void _launchURL(String url) async {
    var uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class ItemData {
  final String title;
  final String imageUrl;
  final String location;
  final String hours;
  final String contact;

  ItemData({
    required this.title,
    required this.imageUrl,
    required this.location,
    required this.hours,
    required this.contact,
  });
}
