// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:klangvalley4locals/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'generated/l10n.dart';

// Modern color palette inspired by KL cityscape
class KLColors {
  static const primary = Color(0xFF1A237E); // Deep blue like KL night sky
  static const secondary =
      Color(0xFF00BCD4); // Cyan like Petronas Towers lighting
  static const accent = Color(0xFFFFD700); // Gold accent
  static const dark = Color(0xFF212121);
  static const light = Color(0xFFF5F5F5);
  static const gradient1 = Color(0xFF1A237E);
  static const gradient2 = Color(0xFF283593);
}

class ExploreKL extends StatelessWidget {
  const ExploreKL({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> dataList = [
      {
        "name": S.of(context).whatToDo,
        "image":
            "https://www.klangvalley4locals.com.my/assets/img/wtd/beauty/face/organic.jpg",
        "icon": Icons.local_activity,
      },
      {
        "name": S.of(context).historicalSites,
        "image":
            "https://www.klangvalley4locals.com.my/assets/img/wtd/sports/tp/sunway.jpg",
        "icon": Icons.history_edu,
      },
      {
        "name": S.of(context).placesOfWorship,
        "image": "https://www.kltheguide.com.my/assets/img/explorekl/pwor.webp",
        "icon": Icons.temple_buddhist,
      },
      {
        "name": S.of(context).whatToEat,
        "image": "https://www.kltheguide.com.my/assets/img/explorekl/wte.webp",
        "icon": Icons.restaurant,
      },
      {
        "name": S.of(context).nightLife,
        "image": "https://www.kltheguide.com.my/assets/img/explorekl/nl.webp",
        "icon": Icons.nightlife,
      },
      {
        "name": S.of(context).kl4Kids,
        "image":
            "https://www.kltheguide.com.my/assets/img/explorekl/kl4kids.webp",
        "icon": Icons.child_care,
      },
      {
        "name": S.of(context).sightseeing,
        "image": "https://www.kltheguide.com.my/assets/img/explorekl/ss.webp",
        "icon": Icons.camera_alt,
      },
      {
        "name": S.of(context).parks,
        "image":
            "https://www.klangvalley4locals.com.my/assets/img/wtd/ig/2.jpg",
        "icon": Icons.park,
      },
    ];

    return Scaffold(
      backgroundColor: KLColors.light,
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          S.of(context).exploreKL,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [KLColors.gradient1, KLColors.gradient2],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: const [AppBarMore()],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          final item = dataList[index];
          return ModernCardItem(
            name: item["name"],
            image: item["image"],
            icon: item["icon"],
            index: index,
          );
        },
      ),
    );
  }
}

class ModernCardItem extends StatelessWidget {
  final String name;
  final String image;
  final IconData icon;
  final int index;

  const ModernCardItem({
    super.key,
    required this.name,
    required this.image,
    required this.icon,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/explorekl-$index',
            arguments: {'index': index});
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: KLColors.primary.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Background Image
              CachedNetworkImage(
                imageUrl: image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                placeholder: (context, url) => Container(
                  color: KLColors.dark.withOpacity(0.1),
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: KLColors.dark.withOpacity(0.1),
                  child: const Icon(Icons.error, color: Colors.red, size: 50),
                ),
              ),
              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
              // Content
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: KLColors.secondary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 20,
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
  }
}

class DetailPage extends StatelessWidget {
  final String title;
  final String content;
  final String content2;
  final String image;
  final String location;
  final String locationurl;
  final String hours;
  final String phone;
  final String website;

  const DetailPage({
    super.key,
    required this.location,
    required this.locationurl,
    required this.hours,
    required this.phone,
    required this.title,
    required this.content,
    required this.content2,
    required this.image,
    required this.website,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KLColors.light,
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Details",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [KLColors.gradient1, KLColors.gradient2],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: const <Widget>[AppBarMore()],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image
            CachedNetworkImage(
              imageUrl: image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 250,
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: KLColors.dark,
                    ),
                  ),
                  if (content.isNotEmpty) ...[
                    const SizedBox(height: 16.0),
                    Text(
                      content,
                      style: const TextStyle(
                        fontSize: 16.0,
                        height: 1.6,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                  if (content2.isNotEmpty) ...[
                    const SizedBox(height: 12.0),
                    Text(
                      content2,
                      style: const TextStyle(
                        fontSize: 16.0,
                        height: 1.6,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  if (location.isNotEmpty)
                    _buildInfoCard(
                      icon: Icons.location_on,
                      title: 'Location',
                      content: location,
                      onTap: () => _launchURL(locationurl),
                    ),
                  if (phone.isNotEmpty)
                    _buildInfoCard(
                      icon: Icons.phone,
                      title: 'Phone',
                      content: phone,
                      onTap: () => _launchURL('tel:$phone'),
                    ),
                  if (hours.isNotEmpty)
                    _buildInfoCard(
                      icon: Icons.access_time,
                      title: 'Hours',
                      content: hours,
                    ),
                  if (website.isNotEmpty)
                    _buildInfoCard(
                      icon: Icons.language,
                      title: 'Website',
                      content: website,
                      onTap: () => _launchURL(website),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: KLColors.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: KLColors.secondary, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        content,
                        style: const TextStyle(
                          fontSize: 16,
                          color: KLColors.dark,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onTap != null)
                  const Icon(Icons.arrow_forward_ios,
                      size: 16, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Modern List Item Widget
class ModernListItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String location;
  final String hours;
  final String? contact;
  final VoidCallback? onTap;

  const ModernListItem({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.location,
    required this.hours,
    this.contact,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                  placeholder: (context, url) => Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: const Icon(Icons.error, size: 50),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: KLColors.dark,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    _buildInfoRow(
                        Icons.location_on, location, KLColors.secondary),
                    const SizedBox(height: 8.0),
                    _buildInfoRow(Icons.access_time, hours, Colors.orange),
                    if (contact != null && contact!.isNotEmpty) ...[
                      const SizedBox(height: 8.0),
                      _buildInfoRow(Icons.phone, contact!, Colors.green),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color iconColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15.0,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class NightLifePlace {
  final String name;
  final String imageUrl;
  final String location;
  final String hours;
  final String website;

  NightLifePlace(
      this.name, this.imageUrl, this.location, this.hours, this.website);
}

class ExploreKL_SS2 extends StatefulWidget {
  const ExploreKL_SS2({super.key});

  @override
  _ExploreKL_SS2State createState() => _ExploreKL_SS2State();
}

class _ExploreKL_SS2State extends State<ExploreKL_SS2> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: KLColors.light,
        appBar: AppBar(
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: TabBar(
            indicatorColor: KLColors.accent,
            indicatorWeight: 3,
            tabs: [
              Tab(text: S.of(context).mustVisit),
              Tab(text: S.of(context).museums),
              Tab(text: S.of(context).klArtScene),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            unselectedLabelStyle:
                const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
          ),
          title: Text(
            S.of(context).sightseeing,
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [KLColors.gradient1, KLColors.gradient2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          actions: const <Widget>[AppBarMore()],
        ),
        body: TabBarView(
          children: [
            _buildSightseeingList([
              SightseeingPlace(
                  'Orang Asli Crafts Museum',
                  'https://www.klangvalley4locals.com.my/assets/img/explorekv/ss/hs/1.jpg',
                  'Jalan Ampang, Golden Triangle, Kuala Lumpur City Centre, 50088',
                  '10:00 am to 10:00 pm',
                  '+603 2382 2828'),
              SightseeingPlace(
                  'Istana Negara',
                  'https://www.kltheguide.com.my/assets/img/explorekl/ss/1024px-ISTANA_NEGARA_MALAYSIA.jpg',
                  'Jalan Tuanku Abdul Halim, Bukit Damansara, 50480 Kuala Lumpur',
                  '24 hours',
                  '03-6200 1000'),
              SightseeingPlace(
                  'Tunku Abdul Rahman Putra Memorial',
                  'https://www.kltheguide.com.my/assets/img/explorekl/ss/tarmemo.webp',
                  'Jalan Dato Onn, 50480 Kuala Lumpur',
                  '10.00am - 5.30pm (Tue-Sun), 12.00pm - 3.00pm (Temporary closed on Fri)',
                  '+603-2694 7277'),
              SightseeingPlace(
                  'Menara Kuala Lumpur / KL Tower',
                  'https://www.kltheguide.com.my/assets/img/explorekl/ss/kuala-lumpur-2720830_1280.jpg',
                  'No. 2 Jalan Punchak Off Jalan P.Ramlee 50250 Kuala Lumpur',
                  '11.00 am - 7.00 pm (Mon-Fri), 10.00 am - 10.00 pm (Sat-Sun)',
                  '+603 2693 7905'),
            ]),
            _buildSightseeingList([
              SightseeingPlace(
                  'Ethnology of the Malay World Museum',
                  'https://www.kltheguide.com.my/assets/img/explorekl/ss/1.jpg',
                  'Jalan Damansara, Tasik Perdana, 50480 Kuala Lumpur',
                  '9.00 am - 5.00 pm (Tue-Sun), Closed on Monday',
                  '+603-2267 1000'),
              SightseeingPlace(
                  'National Textiles Museum',
                  'https://www.kltheguide.com.my/assets/img/explorekl/ss/2.webp',
                  '26, Jalan Sultan Hishamuddin, City Centre, 50000 Kuala Lumpur',
                  '9.00 am - 6.00 pm (Daily)',
                  ''),
              SightseeingPlace(
                  'Museum of Asian Arts',
                  'https://www.kltheguide.com.my/assets/img/explorekl/ss/3.webp',
                  'Jalan Ilmu, 50603 Kuala Lumpur',
                  '8.30 am - 5.00 pm (Mon-Thu), 8.30am - 5.00pm (Fri)',
                  '+603-796 7380'),
            ]),
            _buildSightseeingList([
              SightseeingPlace(
                  'Urban Museum',
                  'https://www.kltheguide.com.my/assets/img/explorekl/ss/urmu.jpg',
                  '3, Jalan Bedara, Bukit Bintang, 50200 Kuala Lumpur',
                  '10.00 am - 8.30 pm (Tue-Sun), Closed on Monday',
                  '+603-2110 3004'),
              SightseeingPlace(
                  'National Art Gallery',
                  'https://www.kltheguide.com.my/assets/img/explorekl/ss/1art.jpg',
                  'No. 2, Jalan Temerloh, Titiwangsa, 53200 Kuala Lumpur',
                  '10.00 am - 4.00 pm (Tue-Sun), Closed on Monday',
                  '+603-4026 7000'),
              SightseeingPlace(
                  'OUR ArtProjects (The Zhongshan Building)',
                  'https://www.kltheguide.com.my/assets/img/explorekl/ss/2.jpg',
                  '80A, Jalan Rotan, Kampung Attap, 50460 Kuala Lumpur',
                  '11.00 am - 7.00 pm (Tue-Sat), Closed on Sun & Mon',
                  '+6016-660 2585'),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSightseeingList(List<SightseeingPlace> places) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: places.length,
      itemBuilder: (context, index) {
        final place = places[index];
        return ModernListItem(
          title: place.name,
          imageUrl: place.imageUrl,
          location: place.location,
          hours: place.hours,
          contact: place.contact.isNotEmpty ? place.contact : null,
        );
      },
    );
  }
}

class SightseeingPlace {
  final String name;
  final String imageUrl;
  final String location;
  final String hours;
  final String contact;

  SightseeingPlace(
      this.name, this.imageUrl, this.location, this.hours, this.contact);
}

// Helper function for launching URLs
void _launchURL(String url) async {
  var uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $url';
  }
}

// Legacy classes for backward compatibility
class ItemData8 {
  final String text;
  final String imageUrl;
  final String location;
  final String hours;
  final String contact;

  ItemData8(this.text, this.imageUrl, this.location, this.hours, this.contact);
}

class MyList8 extends StatelessWidget {
  final List<ItemData8> items;

  const MyList8({required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ModernListItem(
          title: items[index].text,
          imageUrl: items[index].imageUrl,
          location: items[index].location,
          hours: items[index].hours,
          contact:
              items[index].contact.isNotEmpty ? items[index].contact : null,
        );
      },
    );
  }
}

class ItemData {
  final String text;
  final String imageUrl;
  final String content;

  ItemData(this.text, this.imageUrl, this.content);
}

class MyList extends StatelessWidget {
  final List<ItemData> items = [
    ItemData(
      'I-City Theme Park',
      'https://www.klangvalley4locals.com.my/assets/img/wtd/sports/tp/icity.jpg',
      'If you are looking for a one-stop amusement centre that offers diverse experiences, head over to I-City Theme Park.',
    ),
    ItemData(
      'Wet World Water Park Shah Alam',
      'https://www.klangvalley4locals.com.my/assets/img/wtd/sports/tp/shah_alam.jpg',
      'Get ready to have some fun under the sun at Wet World Water Park Shah Alam.',
    ),
    ItemData(
      'Sunway Lagoon',
      'https://www.klangvalley4locals.com.my/assets/img/wtd/sports/tp/sunway.jpg',
      'Would you like to see what it\'s like to live in a palace? The Royal Museum is perhaps the best location.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                child: CachedNetworkImage(
                  imageUrl: items[index].imageUrl,
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      items[index].text,
                      style: const TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: KLColors.dark,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Text(
                      items[index].content,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.black87,
                        height: 1.5,
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
}

class ItemData7 {
  final String text;
  final String imageUrl;
  final String location;
  final String hours;
  final String contact;

  ItemData7(this.text, this.imageUrl, this.location, this.hours, this.contact);
}

class MyList7 extends StatelessWidget {
  final List<ItemData7> items;

  const MyList7({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ModernListItem(
          title: items[index].text,
          imageUrl: items[index].imageUrl,
          location: items[index].location,
          hours: items[index].hours,
          contact:
              items[index].contact.isNotEmpty ? items[index].contact : null,
        );
      },
    );
  }
}

class ItemData6 {
  final String text;
  final String imageUrl;
  final String location;
  final String hours;
  final String contact;

  ItemData6(this.text, this.imageUrl, this.location, this.hours, this.contact);
}

class MyList6 extends StatelessWidget {
  final List<ItemData6> items;

  MyList6({required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ModernListItem(
          title: items[index].text,
          imageUrl: items[index].imageUrl,
          location: items[index].location,
          hours: items[index].hours,
          contact: items[index].contact,
        );
      },
    );
  }
}

class ItemData2 {
  final String text;
  final String imageUrl;
  final String location;
  final String hours;
  final String website;
  final String contact;

  ItemData2(this.text, this.imageUrl, this.location, this.hours, this.website,
      this.contact);
}

class MyList2 extends StatelessWidget {
  final List<ItemData2> items;

  MyList2({required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                child: CachedNetworkImage(
                  imageUrl: items[index].imageUrl,
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      items[index].text,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: KLColors.dark,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    _buildInfoRow(Icons.location_on, items[index].location,
                        KLColors.secondary),
                    const SizedBox(height: 8.0),
                    _buildInfoRow(
                        Icons.access_time, items[index].hours, Colors.orange),
                    const SizedBox(height: 8.0),
                    _buildInfoRow(
                        Icons.phone, items[index].contact, Colors.green),
                    const SizedBox(height: 8.0),
                    GestureDetector(
                      onTap: () => _launchURL(items[index].website),
                      child: Row(
                        children: [
                          const Icon(Icons.language,
                              size: 20, color: Colors.blue),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              items[index].website,
                              style: const TextStyle(
                                fontSize: 15.0,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
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

  Widget _buildInfoRow(IconData icon, String text, Color iconColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15.0,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class ItemData5 {
  final String text;
  final String imageUrl;
  final String location;
  final String hours;

  ItemData5(this.text, this.imageUrl, this.location, this.hours);
}

class MyList5 extends StatelessWidget {
  final List<ItemData5> items;

  MyList5({required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ModernListItem(
          title: items[index].text,
          imageUrl: items[index].imageUrl,
          location: items[index].location,
          hours: items[index].hours,
        );
      },
    );
  }
}

class ItemData3 {
  final String text;
  final String imageUrl;
  final String location;
  final String hours;
  final String website;

  ItemData3(this.text, this.imageUrl, this.location, this.hours, this.website);
}

class MyList3 extends StatelessWidget {
  final List<ItemData3> items;

  MyList3({required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                child: CachedNetworkImage(
                  imageUrl: items[index].imageUrl,
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      items[index].text,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: KLColors.dark,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    _buildInfoRow(Icons.location_on, items[index].location,
                        KLColors.secondary),
                    const SizedBox(height: 8.0),
                    _buildInfoRow(
                        Icons.access_time, items[index].hours, Colors.orange),
                    if (items[index].website.isNotEmpty) ...[
                      const SizedBox(height: 8.0),
                      GestureDetector(
                        onTap: () => _launchURL(items[index].website),
                        child: Row(
                          children: [
                            const Icon(Icons.language,
                                size: 20, color: Colors.blue),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                items[index].website,
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color iconColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15.0,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class ItemData4 {
  final String text;
  final String imageUrl;
  final String location;
  final String hours;
  final String contact;

  ItemData4(this.text, this.imageUrl, this.location, this.hours, this.contact);
}

class MyList4 extends StatelessWidget {
  final List<ItemData4> items;

  MyList4({required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ModernListItem(
          title: items[index].text,
          imageUrl: items[index].imageUrl,
          location: items[index].location,
          hours: items[index].hours,
          contact:
              items[index].contact.isNotEmpty ? items[index].contact : null,
        );
      },
    );
  }
}

class ExploreKL_Beauty extends StatefulWidget {
  const ExploreKL_Beauty({super.key});

  @override
  _ExploreKL_BeautyState createState() => _ExploreKL_BeautyState();
}

class _ExploreKL_BeautyState extends State<ExploreKL_Beauty> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KLColors.light,
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          S.of(context).whatToDo,
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [KLColors.gradient1, KLColors.gradient2],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: const <Widget>[AppBarMore()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ModernListItem(
            title: 'Melissachens Skin Beauty Spa',
            imageUrl:
                'https://www.klangvalley4locals.com.my/assets/img/wtd/beauty/face/melissachens.jpg',
            location:
                'S117C, 1 Utama Shopping Centre, Bandar Utama, 47800 Petaling Jaya, Selangor',
            hours: '10.00 am - 9.00 pm (Monday - Sunday)',
            contact: '603-7727 1093',
          ),
          ModernListItem(
            title: 'Organic Face',
            imageUrl:
                'https://www.klangvalley4locals.com.my/assets/img/wtd/beauty/face/organic.jpg',
            location:
                'NRC-02-06, Sunway Nexis, 1, Jalan PJU 5/1, Kota Damansara, 47810 Petaling Jaya, Selangor',
            hours:
                '11.00 am - 8.00 pm (Tuesday - Friday), 10.00 am - 7.00 pm (Saturday & Sunday), Closed on Monday',
            contact: '6012-794 9924',
          ),
          ModernListItem(
            title: 'Herbaline (Ampang)',
            imageUrl:
                'https://www.klangvalley4locals.com.my/assets/img/wtd/beauty/face/herbaline.jpg',
            location: '2, Jalan 3, One Ampang Avenue, 68000 Ampang, Selangor',
            hours:
                '10.30 am - 8.30 pm (Monday - Friday), 10.00 am - 8.30 pm (Saturday & Sunday)',
            contact: '6012-910 9811',
          ),
        ],
      ),
    );
  }
}

class ExploreKL_HS2 extends StatefulWidget {
  const ExploreKL_HS2({super.key});

  @override
  State<ExploreKL_HS2> createState() => _ExploreKL_HS2();
}

class _ExploreKL_HS2 extends State<ExploreKL_HS2> {
  final List<Map<String, String>> items = [
    {
      'title': 'I-City Theme Park',
      'image':
          'https://www.klangvalley4locals.com.my/assets/img/wtd/sports/tp/icity.jpg',
      'content':
          'If you are looking for a one-stop amusement centre that offers diverse experiences, head over to I-City Theme Park. It is divided into three main areas which comprise the -8 degrees SnoWalk that was constructed with the help of renowned ice sculptors, City of Digital Lights that is decorated with 1 million multicoloured LED lights and Water World with the first tornado ride in South East Asia',
    },
    {
      'title': 'Wet World Water Park Shah Alam',
      'image':
          'https://www.klangvalley4locals.com.my/assets/img/wtd/sports/tp/shah_alam.jpg',
      'content':
          'Get ready to have some fun under the sun at Wet World Water Park Shah Alam. Following a tropical island theme, the exciting slides and rides at the water park include the Super Hurricane, Monsoon Buster, Thunder River, Caribbean Rider and Whirlwind Escape. There are also a few children\'s wet playgrounds for the younger children to enjoy.',
    },
    {
      'title': 'Sunway Lagoon',
      'image':
          'https://www.klangvalley4locals.com.my/assets/img/wtd/sports/tp/sunway.jpg',
      'content':
          'Would you like to see what it\'s like to live in a palace? The Royal Museum is perhaps the best location to see and experience the royal way of life. The Royal Museum opened its doors on 1 February 2013, is housing in the old National Palace, which served as the official residence of Malaysia\'s King and Queen.',
    },
    {
      'title': 'AirRider Indoor Skydiving',
      'image':
          'https://www.klangvalley4locals.com.my/assets/img/wtd/sports/ex/air_rider.jpg',
      'content':
          'Experience the thrill of skydiving without worrying about the frightening fear of jumping off a plane at 14, 000 feet above the ground at AirRider Indoor Skydiving. Housed within 1 Utama Shopping Centre, this simulated experience is equivalent to the real deal but it occurs within a wind tunnel boosting up to 220 km/h for 50 seconds!',
    },
    {
      'title': 'TREX Bike Park',
      'image':
          'https://www.klangvalley4locals.com.my/assets/img/wtd/sports/ex/TREX%20Bike%20Park.jpg',
      'content':
          'Boasting an elaborate bicycle circuit within a lush landscaped park is the recently developed TREX Bike Park. Apart from clear signs, the layout contains asphalt roads with direction (including merging lanes), back-to-back bumpy BMX tracks and varnished wooden MTB trails.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KLColors.light,
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          S.of(context).historicalSites,
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [KLColors.gradient1, KLColors.gradient2],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: const <Widget>[AppBarMore()],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  child: CachedNetworkImage(
                    imageUrl: items[index]['image']!,
                    fit: BoxFit.cover,
                    height: 200,
                    width: double.infinity,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        items[index]['title']!,
                        style: const TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: KLColors.dark,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        items[index]['content']!,
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ExploreKL_P2 extends StatefulWidget {
  const ExploreKL_P2({super.key});

  @override
  _ExploreKL_P2State createState() => _ExploreKL_P2State();
}

class _ExploreKL_P2State extends State<ExploreKL_P2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KLColors.light,
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          S.of(context).parks,
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [KLColors.gradient1, KLColors.gradient2],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: const <Widget>[AppBarMore()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ModernListItem(
            title: 'Botanica Co Cafe',
            imageUrl:
                'https://www.klangvalley4locals.com.my/assets/img/wtd/ig/1.jpg',
            location:
                'G5, 8, Jalan Kerinchi, Bangsar South, 59200 Kuala Lumpur',
            hours:
                '11.30 am - 10.00 pm (Mon-Wed), 11.30 am - 12.00 am (Fri), 9.30 am - 12.00 am (Sat), 9.30 am - 10.00 pm (Sun)',
            contact: '+6016-965 6422',
          ),
          ModernListItem(
            title: 'Wildflowers KL',
            imageUrl:
                'https://www.klangvalley4locals.com.my/assets/img/wtd/ig/2.jpg',
            location: '153, Jalan Petaling, City Centre, 50000 Kuala Lumpur',
            hours:
                '12.00 pm - 12.00 am (Fri-Sun), 12.00 pm - 10.30 pm (Mon-Thu), Closed on Tuesday',
            contact: '+603-2856 3369',
          ),
          ModernListItem(
            title: 'A Pie Thing',
            imageUrl:
                'https://www.klangvalley4locals.com.my/assets/img/wtd/ig/3.jpg',
            location:
                '128 G, Jalan SS 21/35, Damansara Utama, 47400 Petaling Jaya, Selangor',
            hours: '10.00 am - 9.00 pm (Tuesday - Sunday), Closed on Monday',
            contact: '+6012-951 5233',
          ),
        ],
      ),
    );
  }
}

class ExploreKL_KL4K2 extends StatefulWidget {
  const ExploreKL_KL4K2({super.key});

  @override
  _ExploreKL_KL4K2State createState() => _ExploreKL_KL4K2State();
}

class _ExploreKL_KL4K2State extends State<ExploreKL_KL4K2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KLColors.light,
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          S.of(context).kl4kids,
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [KLColors.gradient1, KLColors.gradient2],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: const <Widget>[AppBarMore()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ModernListItem(
            title: 'KidZania',
            imageUrl:
                'https://www.klangvalley4locals.com.my/assets/img/wtd/kv4kids/kidzania.jpg',
            location:
                'Curve NX, 18, Jalan PJU 7/5, Mutiara Damansara, 47810 Petaling Jaya, Selangor',
            hours: '10.00 am - 6.00 pm (Monday - Sunday), Closed on Tuesday',
            contact: '+603-3310 0229',
          ),
          ModernListItem(
            title: 'Jungle Gym',
            imageUrl:
                'https://www.klangvalley4locals.com.my/assets/img/wtd/kv4kids/gym.jpg',
            location:
                '2nd Floor, Atria Shopping Gallery, Jalan SS 22/23, Damansara Jaya, 47400 Petaling Jaya, Selangor',
            hours: '10.00 am - 7.00 pm (Monday - Sunday)',
            contact: '+603-7731 7193',
          ),
          ModernListItem(
            title: 'Farm In The City',
            imageUrl:
                'https://www.klangvalley4locals.com.my/assets/img/wtd/kv4kids/farm.jpg',
            location:
                'Lot 40187-40188, Jalan Prima Tropika Barat 1, Pusat Bandar Putra Permai, 43300 Seri Kembangan, Selangor',
            hours:
                '10.00 am - 6.00 pm (Mon-Fri), 9.30 am - 6.00 pm (Sat-Sun), Closed on Tuesday (Except public and school holiday)',
            contact: '+603-20223943',
          ),
          ModernListItem(
            title: 'Milky Way Play Space',
            imageUrl:
                'https://www.klangvalley4locals.com.my/assets/img/wtd/kv4kids/milky.jpg',
            location: '1, Jalan SS 7/26a, SS 7, 47301 Petaling Jaya, Selangor',
            hours: '10.00 am - 10.00 pm (Monday - Sunday)',
            contact: '+603-7801 11881',
          ),
        ],
      ),
    );
  }
}

class ExploreKL_PWOR2 extends StatefulWidget {
  const ExploreKL_PWOR2({super.key});

  @override
  _ExploreKL_PWOR2State createState() => _ExploreKL_PWOR2State();
}

class _ExploreKL_PWOR2State extends State<ExploreKL_PWOR2> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: KLColors.light,
        appBar: AppBar(
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: TabBar(
            isScrollable: false,
            indicatorColor: KLColors.accent,
            indicatorWeight: 3,
            tabs: [
              Tab(text: S.of(context).muslim),
              Tab(text: S.of(context).buddhistTao),
              Tab(text: S.of(context).hindu),
              Tab(text: S.of(context).others),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            unselectedLabelStyle:
                const TextStyle(fontWeight: FontWeight.normal, fontSize: 13),
          ),
          title: Text(
            S.of(context).placesOfWorship,
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [KLColors.gradient1, KLColors.gradient2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          actions: const <Widget>[AppBarMore()],
        ),
        body: TabBarView(
          children: [
            _buildWorshipList([
              WorshipPlace(
                  'Sultan Salahuddin Abdul Aziz Mosque',
                  'https://www.klangvalley4locals.com.my/assets/img/explorekv/pwor/muslim/salahuddin.jpg',
                  'Persiaran Masjid St., Sekysen 14, 40000 Shah Alam, Selangor',
                  'Open everyday from 9am to 12:30pm, 2:30 to 6:30pm',
                  'https://www.mssaas.gov.my/',
                  '03-5523 8006'),
              WorshipPlace(
                  'Sultan Suleiman Royal Mosque',
                  'https://www.klangvalley4locals.com.my/assets/img/explorekv/pwor/muslim/suleiman.jpg',
                  'Jalan Raya Timur, Kawasan 1, 41000 Klang, Selangor',
                  'Open 24 hours',
                  'https://selangor.travel/listing/sultan-suleiman-royal-mosque/',
                  '03-3374 3391'),
              WorshipPlace(
                  'Raja Haji Fisabilillah Mosque',
                  'https://www.klangvalley4locals.com.my/assets/img/explorekv/pwor/muslim/raja.jpg',
                  'Persiaran Semarak Api, 63000 Cyberjaya, Selangor',
                  'Open 24 hours',
                  'https://www.facebook.com/masjidrajahajifisabilillah/?locale=ms_MY',
                  '03-8322 0096'),
              WorshipPlace(
                  'Masjid Hussain Seremban 2',
                  'https://www.klangvalley4locals.com.my/assets/img/explorekv/pwor/muslim/hussain.jpg',
                  'Seremban 2, 70300 Seremban, Negeri Sembilan',
                  'Open everyday from 9am to 5pm',
                  'https://www.masjidhussain.com.my/',
                  '+606-601 7563'),
            ]),
            _buildWorshipList([
              WorshipPlace(
                  'Thai Buddhist Chetawan Temple',
                  'https://www.klangvalley4locals.com.my/assets/img/explorekv/pwor/tao/thai.jpg',
                  'No.24, Jalan Pantai 9/7, Seksyen 10, 46000 Petaling Jaya, Selangor',
                  'Open everyday from 8:30am to 5pm',
                  'https://www.facebook.com/ThaiBuddhistChetawanTemple/',
                  '+603-7955 2443'),
              WorshipPlace(
                  'Fo Guang Shan Dong Zen Temple',
                  'https://www.klangvalley4locals.com.my/assets/img/explorekv/pwor/tao/guang_shan.jpg',
                  'Pt 2297, Jalan Sungai Buaya, Kampung Jenjarom, 42600 Jenjarom, Selangor',
                  '10.00 am - 10.00 pm (Tue-Sun)/Closed on Monday',
                  'https://www.facebook.com/fgsdongzen/',
                  '+603-3191 1533'),
              WorshipPlace(
                  'Then Sze Koon Temple',
                  'https://www.klangvalley4locals.com.my/assets/img/explorekv/pwor/tao/then_sze.jpg',
                  'Jalan Bukit Termiang 1, 70200 Seremban, Negeri Sembilan',
                  '8.00 am - 6.30 pm (Monday - Sunday)',
                  'https://www.facebook.com/ThenSzeKhoonTempleSerembanN9/',
                  '+6012-690 5515'),
            ]),
            _buildWorshipList([
              WorshipPlace(
                  'Klang Perumal Temple',
                  'https://www.klangvalley4locals.com.my/assets/img/explorekv/pwor/hindu/klang.jpg',
                  '80, Jalan Mastika Off Psn Raja Muda Musa, Selangor, 41100 Klang',
                  'Open 24 hours (Monday - Sunday)',
                  'https://www.facebook.com/perumaltempleklg1/?locale=ms_MY',
                  '+603-3371 1763'),
              WorshipPlace(
                  'Batu Caves Temple',
                  'https://www.kltheguide.com.my/assets/img/explorekl/pwor/batucaves.jpg',
                  'Gombak, 68100 Batu Caves, Selangor',
                  'Open 24 hours (Monday - Sunday)',
                  'https://www.facebook.com/BatuCavesTemple/',
                  '+603-6189 6284'),
              WorshipPlace(
                  'Sri Shakti Devasthanam',
                  'https://www.klangvalley4locals.com.my/assets/img/explorekv/pwor/hindu/sri_shakti.jpg',
                  'Jalan Kuala Selangor, Bukit Rotan, 45700 Bukit Rotan, Selangor',
                  'Open everyday from 7am to 12pm, 5pm to 9pm',
                  'https://srishaktitemple.com.my/',
                  '+6012-303 0289'),
            ]),
            _buildWorshipList([
              WorshipPlace(
                  'Church of Lady Lourdes',
                  'https://www.klangvalley4locals.com.my/assets/img/explorekv/pwor/other/lady.jpg',
                  'No.114, Jalan Tengku Kelana, Kawasan 1, 41000 Klang, Selangor',
                  'Open everyday from 8:30am to 5:30pm, Closed on Monday',
                  'https://www.facebook.com/ollklang/',
                  '+603-3371 3053'),
              WorshipPlace(
                  'Church of the Holy Redeemer',
                  'https://www.klangvalley4locals.com.my/assets/img/explorekv/pwor/other/redeemer.jpg',
                  'Taman Berkeley, 41150 Klang, Selangor',
                  '9.00 am - 4.30 pm (Mon-Fri)/9.00 am - 12.30 (Sat-Sun)',
                  'https://www.facebook.com/hrckelang/',
                  '+603-3341 6812'),
              WorshipPlace(
                  'Church of The Holy Rosary',
                  'https://www.kltheguide.com.my/assets/img/explorekl/pwor/Church%20of%20The%20Holy%20Rosary%20(30).jpg',
                  'Holy Rosary Church, 10, Jalan Tun Sambanthan, 50470 Kuala Lumpur',
                  'Opens everyday from 9:30am to 4:30pm',
                  'http://www.hrckl.com/',
                  '+603-2274 2747'),
              WorshipPlace(
                  'Kuala Lumpur Baptist Church',
                  'https://www.kltheguide.com.my/assets/img/explorekl/pwor/4.jpg',
                  '70, Changkat Bukit Bintang, Bukit Bintang, 50200 Kuala Lumpur',
                  '9.30am - 12.30pm (Sun)/8.30am - 4.30pm (Mon-Fri)/Closed on Saturday',
                  'http://www.klbc.org.my/',
                  '+603-2141 9154'),
              WorshipPlace(
                  'Guru Nanak Darbar Tatt Khalsa Diwan Gurdwara',
                  'https://www.kltheguide.com.my/assets/img/explorekl/pwor/Guru%20Nanak%20Darbar%20Tatt%20Khalsa%20Diwan%20Gurdwara.jpg',
                  '24, Jalan Raja Alang, Chow Kit, 50300 Kuala Lumpur',
                  'Opens everyday from 9:00AM to 5:00PM',
                  'https://facebook.com/TattKhalsaDiwan/',
                  '+603-2692 2215'),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildWorshipList(List<WorshipPlace> places) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: places.length,
      itemBuilder: (context, index) {
        final place = places[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                child: CachedNetworkImage(
                  imageUrl: place.imageUrl,
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: KLColors.dark,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    _buildInfoRow(
                        Icons.location_on, place.location, KLColors.secondary),
                    const SizedBox(height: 8.0),
                    _buildInfoRow(
                        Icons.access_time, place.hours, Colors.orange),
                    const SizedBox(height: 8.0),
                    _buildInfoRow(Icons.phone, place.contact, Colors.green),
                    const SizedBox(height: 8.0),
                    GestureDetector(
                      onTap: () => _launchURL(place.website),
                      child: Row(
                        children: [
                          const Icon(Icons.language,
                              size: 20, color: Colors.blue),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              place.website,
                              style: const TextStyle(
                                fontSize: 15.0,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
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

  Widget _buildInfoRow(IconData icon, String text, Color iconColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15.0,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class WorshipPlace {
  final String name;
  final String imageUrl;
  final String location;
  final String hours;
  final String website;
  final String contact;

  WorshipPlace(this.name, this.imageUrl, this.location, this.hours,
      this.website, this.contact);
}

class ExploreKL_WTE2 extends StatefulWidget {
  const ExploreKL_WTE2({super.key});

  @override
  _ExploreKL_WTE2State createState() => _ExploreKL_WTE2State();
}

class _ExploreKL_WTE2State extends State<ExploreKL_WTE2> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: KLColors.light,
        appBar: AppBar(
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: TabBar(
            indicatorColor: KLColors.accent,
            indicatorWeight: 3,
            tabs: [
              Tab(text: S.of(context).streetFood),
              Tab(text: S.of(context).cafes),
              Tab(text: S.of(context).restaurants),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            unselectedLabelStyle:
                const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
          ),
          title: Text(
            S.of(context).whatToEat,
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [KLColors.gradient1, KLColors.gradient2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          actions: const <Widget>[AppBarMore()],
        ),
        body: TabBarView(
          children: [
            _buildFoodList([
              FoodPlace(
                  'Nasi Lemak Bumbung',
                  'https://www.klangvalley4locals.com.my/assets/img/explorekv/eo/malay/4.jpg',
                  '6, Jalan 21/11b, Sea Park, 46300 Petaling Jaya, Selangor',
                  'Open everyday from 4pm to 12am'),
              FoodPlace(
                  'Mee Udang Banjir Kuala Selangor',
                  'https://www.klangvalley4locals.com.my/assets/img/explorekv/eo/malay/5.jpg',
                  '587, Jalan Bandar Baru Batu 2, Pasir Penambang, 45000 Kuala Selangor, Selangor',
                  '11.00 am - 6.00 pm (Tue-Sun)/2.30 pm - 6.00 pm (Fri)/Closed on Monday'),
              FoodPlace(
                  'Warung Ibu Nasi Ambeng',
                  'https://www.klangvalley4locals.com.my/assets/img/explorekv/eo/malay/6.jpg',
                  'Lot 216, Batu 6, Jalan Bernam, Sungai Gulang-Gulang, 45500 Tanjung Karang, Selangor',
                  '11.30 am - 3.00 pm (Monday - Sunday)'),
            ]),
            _buildFoodList([
              FoodPlace(
                  'Yap Kee Banana Leaf',
                  'https://www.klangvalley4locals.com.my/assets/img/explorekv/eo/chinese/3.jpg',
                  '26, Jalan Besar, Kawasan 1, 41000 Klang, Selangor',
                  '11.00 am - 4.00 pm (Daily)'),
              FoodPlace(
                  'Chong - Kee Kampar Claypot Chicken Rice',
                  'https://www.klangvalley4locals.com.my/assets/img/explorekv/eo/chinese/2.jpg',
                  '80, Jalan SS 22/25, Damansara Jaya, 47400 Petaling Jaya, Selangor',
                  '11.00 am - 8.30 pm (Daily)/Closed on Wednesday'),
              FoodPlace(
                  'Samy & Ah Her Bak Kut Teh',
                  'https://www.klangvalley4locals.com.my/assets/img/explorekv/eo/chinese/8.jpg',
                  '1, Jalan Lang, Taman Berkeley, 41150 Klang, Selangor',
                  '8.00 am - 2.00 pm (Monday - Sunday)'),
            ]),
            _buildFoodList([
              FoodPlace(
                  'Thosai Cafè',
                  'https://www.klangvalley4locals.com.my/assets/img/explorekv/eo/indian/1.jpg',
                  'Ground floor, Curve mall, Mutiara Damansara, 47800 Petaling Jaya',
                  '11.00 am - 9.30 pm (Daily)'),
              FoodPlace(
                  'Curry Leaf Restaurant',
                  'https://www.klangvalley4locals.com.my/assets/img/explorekv/eo/indian/13.jpg',
                  '3 75, Jalan SS 21/37, Damansara Utama, 47400 Petaling Jaya, Selangor',
                  '8.00 am - 8.00 pm (Monday - Sunday)'),
              FoodPlace(
                  'Grand Neelas Restaurant',
                  'https://www.klangvalley4locals.com.my/assets/img/explorekv/eo/indian/19.jpg',
                  '31, Jalan Kenari 17, Bandar Puchong Jaya, 47100 Puchong, Selangor',
                  '8.00 am - 10.00 pm (Monday - Sunday)'),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodList(List<FoodPlace> places) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: places.length,
      itemBuilder: (context, index) {
        final place = places[index];
        return ModernListItem(
          title: place.name,
          imageUrl: place.imageUrl,
          location: place.location,
          hours: place.hours,
        );
      },
    );
  }
}

class FoodPlace {
  final String name;
  final String imageUrl;
  final String location;
  final String hours;

  FoodPlace(this.name, this.imageUrl, this.location, this.hours);
}

class ExploreKL_NL2 extends StatefulWidget {
  const ExploreKL_NL2({super.key});

  @override
  _ExploreKL_NL2State createState() => _ExploreKL_NL2State();
}

class _ExploreKL_NL2State extends State<ExploreKL_NL2> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: KLColors.light,
        appBar: AppBar(
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: TabBar(
            indicatorColor: KLColors.accent,
            indicatorWeight: 3,
            tabs: [
              Tab(text: S.of(context).nightLife),
              Tab(text: S.of(context).bars),
              Tab(text: S.of(context).nightMarket),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            unselectedLabelStyle:
                const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
          ),
          title: Text(
            S.of(context).nightLife,
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [KLColors.gradient1, KLColors.gradient2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          actions: const <Widget>[AppBarMore()],
        ),
        body: TabBarView(
          children: [
            _buildNightLifeList([
              NightLifePlace(
                  'Changkat, Bukit Bintang',
                  'https://www.kltheguide.com.my/assets/img/explorekl/nl/Changkat.jpg',
                  'Bukit Bintang, Kuala Lumpur',
                  '24 hours',
                  ''),
              NightLifePlace(
                  'Bangsar',
                  'https://www.kltheguide.com.my/assets/img/explorekl/nl/bangsar.png',
                  'Bangsar, 59000 Kuala Lumpur',
                  '24 hours',
                  ''),
              NightLifePlace(
                  'Ampang',
                  'https://www.kltheguide.com.my/assets/img/explorekl/nl/1024px-JalanAmpangNight.jpg',
                  'Ampang, Federal Territory of Kuala Lumpur',
                  '24 hours',
                  ''),
              NightLifePlace(
                  'Petaling Street',
                  'https://www.kltheguide.com.my/assets/img/explorekl/nl/1024px-Petaling_Street,_Kuala_Lumpur.jpg',
                  'Jalan Petaling, City Centre, 50000 Kuala Lumpur',
                  '24 hours',
                  ''),
            ]),
            _buildNightLifeList([
              NightLifePlace(
                  'Marini\'s On 57',
                  'https://lh3.googleusercontent.com/p/AF1QipOw-nEwlxUnjIX50EgmfBVdO24HGkvKGgW0XsCv=s680-w680-h510',
                  '57 Menara 3 Petronas Persiaran, Kuala Lumpur City Centre, 50088 Kuala Lumpur',
                  '5.00 pm - 3.00 am (Daily)',
                  'https://reservations.marinisgroup.com/'),
              NightLifePlace(
                  'Heli Lounge Bar',
                  'https://www.kltheguide.com.my/assets/img/explorekl/nl/Heli%20Lounge%20Bar%20(30).png',
                  '4 Menara KH, Jalan Sultan Ismail, Bukit Bintang, 50450 Kuala Lumpur',
                  '5.00 pm - 12.00 am (Sun-Wed)',
                  'https://theroof.com.my/'),
              NightLifePlace(
                  'Zeta Bar',
                  'https://www.kltheguide.com.my/assets/img/explorekl/nl/zeta%20bar%20(30).png',
                  'Level 5, 3, Jalan Stesen Sentral, Kuala Lumpur Sentral, 50470 Kuala Lumpur',
                  '10 am - 10 pm (Daily)',
                  'https://www.facebook.com/ZetaBarHKL/'),
            ]),
            _buildNightLifeList([
              NightLifePlace(
                  'Connaught Night market',
                  'https://www.kltheguide.com.my/assets/img/explorekl/nl/11.jpg',
                  '130, 108, Jalan Cerdas, Taman Connaught, 56000 Kuala Lumpur',
                  '6.00 pm - 1.00 am (Wednesday)',
                  ''),
              NightLifePlace(
                  'Petaling Street',
                  'https://www.kltheguide.com.my/assets/img/explorekl/nl/12.jpg',
                  'Jalan Petaling, City Centre, 50000 Kuala Lumpur',
                  '8.00 am - 8.00 pm (Monday - Sunday)',
                  ''),
              NightLifePlace(
                  'Kasturi Walk',
                  'https://www.kltheguide.com.my/assets/img/explorekl/nl/13.jpg',
                  'Jalan Hang Kasturi, City Centre, 50050 Kuala Lumpur',
                  'Open 24 Hours',
                  ''),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildNightLifeList(List<NightLifePlace> places) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: places.length,
      itemBuilder: (context, index) {
        final place = places[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                child: CachedNetworkImage(
                  imageUrl: place.imageUrl,
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: KLColors.dark,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    _buildInfoRow(
                        Icons.location_on, place.location, KLColors.secondary),
                    const SizedBox(height: 8.0),
                    _buildInfoRow(
                        Icons.access_time, place.hours, Colors.orange),
                    if (place.website.isNotEmpty) ...[
                      const SizedBox(height: 8.0),
                      GestureDetector(
                        onTap: () => _launchURL(place.website),
                        child: Row(
                          children: [
                            const Icon(Icons.language,
                                size: 20, color: Colors.blue),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                place.website,
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color iconColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15.0,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
