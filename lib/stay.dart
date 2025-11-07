import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:klangvalley4locals/main.dart';
import 'package:url_launcher/url_launcher.dart';

import 'generated/l10n.dart';

class Stay extends StatefulWidget {
  const Stay({super.key});

  @override
  _StayState createState() => _StayState();
}

class _StayState extends State<Stay> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          title: Text(S.of(context).placesToStay,
              style: const TextStyle(color: Colors.white)),
          bottom: TabBar(
            tabs: [
              Tab(text: S.of(context).topPlacesToStay),
              Tab(text: S.of(context).hotels),
              Tab(text: S.of(context).budgetHotels),
              Tab(text: S.of(context).backpackersLodge),
            ],
            unselectedLabelColor: Colors.white,
            labelColor: Colors.white,
            labelStyle: const TextStyle(fontWeight: FontWeight.w800),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
          ),
          backgroundColor: const Color.fromARGB(255, 0, 71, 133),
          actions: const <Widget>[
            AppBarMore(),
          ],
        ),
        body: TabBarView(
          children: [
            MyList2(
              items: [
                ItemData(
                  title: 'Bangi Resort Hotel',
                  imageUrl:
                      'https://www.klangvalley4locals.com.my/assets/img/accommodation/lux/bangi.jpg',
                  location:
                      'Off, Persiaran Bandar, Bangi Golf Club, 43650 Bandar Baru Bangi, Selangor',
                  contact: '+603-8210 2222',
                ),
                ItemData(
                  title: 'Citadines DPulze Cyberjaya',
                  imageUrl:
                      'https://www.klangvalley4locals.com.my/assets/img/accommodation/lux/citadines.jpg',
                  location:
                      'Lingkaran Cyber Point Timur, Cyber 12, 63000 Cyberjaya, Selangor',
                  contact: '+603-8689 9888',
                ),
                ItemData(
                  title: 'Dorsett Putrajaya',
                  imageUrl:
                      'https://www.klangvalley4locals.com.my/assets/img/accommodation/lux/dorsett.jpg',
                  location: 'Precinct 3, 62000 Putrajaya',
                  contact: '+603-8892 8388',
                ),
                // Add more top places to stay
              ],
            ),
            MyList2(
              items: [
                ItemData(
                  title: 'Mesra Boutique Hotel',
                  imageUrl:
                      'https://www.klangvalley4locals.com.my/assets/img/accommodation/bud/mesra.jpg',
                  location:
                      'No 3 & 4, Teluk Kemang Square Bt 7 Jalan Pantai Teluk Kemang Port Dickson, 71050 Teluk Kemang, Negeri Sembilan',
                  contact: '+606-662 6229',
                ),
                ItemData(
                  title: 'D\'Metro Hotel',
                  imageUrl:
                      'https://www.klangvalley4locals.com.my/assets/img/accommodation/bud/d_metro.jpg',
                  location:
                      'Jalan Nelayan 19/D, Seksyen 19, 40300 Shah Alam, Selangor',
                  contact: '+603-5545 2693',
                ),
                ItemData(
                  title: 'GoodHope Hotel',
                  imageUrl:
                      'https://www.klangvalley4locals.com.my/assets/img/accommodation/bud/goodhope.jpg',
                  location:
                      'Persiaran Akuatik, Seksyen 13, 40100 Shah Alam, Selangor',
                  contact: '+603-5512 2828',
                ),
                // Add more hotels
              ],
            ),
            MyList2(
              items: [
                ItemData(
                  title: 'Tadom Hill Resort',
                  imageUrl:
                      'https://www.klangvalley4locals.com.my/assets/img/accommodation/nat/tadom.jpg',
                  location:
                      'No.2, Jalan Bukit Tadom, (Kampung Orang Asli) Kampung Labohan Dagang, 42700 Banting, Selangor',
                  contact: '+6012-522 5728',
                ),
                ItemData(
                  title: 'Tanah Larwina',
                  imageUrl:
                      'https://www.klangvalley4locals.com.my/assets/img/accommodation/nat/tanah_larwina.jpg',
                  location:
                      'Batu 23, Jalan Sungai Lui, Kampung Paya Lebar, 43100 Hulu Langat, Selangor',
                  contact: '+60175997665',
                ),
                ItemData(
                  title: 'Sekeping Serendah',
                  imageUrl:
                      'https://www.klangvalley4locals.com.my/assets/img/accommodation/nat/sekeping.jpg',
                  location: '48200 Serendah, Selangor',
                  contact: '+6016-367 0067',
                ),
                // Add more budget hotels
              ],
            ),
            MyList2(
              items: [
                ItemData(
                  title: 'The Garden Homestay',
                  imageUrl:
                      'https://www.klangvalley4locals.com.my/assets/img/accommodation/home/the_garden.jpg',
                  location: 'Jalan Angsana, Templer Villas, 48000, Selangor',
                  contact: '+6014-968 7306',
                ),
                ItemData(
                  title: 'Homestay Sungai Sireh',
                  imageUrl:
                      'https://www.klangvalley4locals.com.my/assets/img/accommodation/home/sungai_sireh.jpg',
                  location:
                      'Jalan Parit Satu Sungai Sireh, 45500 Tanjong Karang, Selangor',
                  contact: '+603-3269 2400',
                ),
                ItemData(
                  title: 'Homestay Pachitan',
                  imageUrl:
                      'https://www.klangvalley4locals.com.my/assets/img/accommodation/home/pachitan.jpg',
                  location: 'Kampung Pachitan, Chuah, 71960 Port Dickson',
                  contact: '+6019-385 9793',
                ),
                // Add more backpackers lodges
              ],
            ),
          ],
        ),
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
                    const SizedBox(height: 8.0),
                    Text(
                      'location: ${items[index].location}',
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'contact: ${items[index].contact}',
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     _launchURL(items[index].website);
                    //   },
                    //   child: Text(
                    //     '',
                    //     style: const TextStyle(
                    //       fontSize: 16.0,
                    //       color: Colors.blue,
                    //       decoration: TextDecoration.underline,
                    //     ),
                    //   ),
                    // ),
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
  final String contact;

  ItemData({
    required this.title,
    required this.imageUrl,
    required this.location,
    required this.contact,
  });
}
