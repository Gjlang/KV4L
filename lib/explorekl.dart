// ignore_for_file: camel_case_types

//import 'dart:convert';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:klangvalley4locals/main.dart';
import 'package:url_launcher/url_launcher.dart';

import 'generated/l10n.dart';

class ExploreKL extends StatelessWidget {
  const ExploreKL({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> dataList = [
      {
        "name": S.of(context).whatToDo,
        "image" : "https://www.klangvalley4locals.com.my/assets/img/wtd/beauty/face/organic.jpg"
      },
      {
        "name": S.of(context).historicalSites,
        "image": "https://www.klangvalley4locals.com.my/assets/img/wtd/sports/tp/sunway.jpg"
      },
      {
        "name": S.of(context).placesOfWorship,
        "image": "https://www.kltheguide.com.my/assets/img/explorekl/pwor.webp"
      },
      {
        "name": S.of(context).whatToEat,
        "image": "https://www.kltheguide.com.my/assets/img/explorekl/wte.webp"
      },
      {
        "name": S.of(context).nightLife,
        "image": "https://www.kltheguide.com.my/assets/img/explorekl/nl.webp"
      },
      {
        "name": S.of(context).kl4Kids,
        "image": "https://www.kltheguide.com.my/assets/img/explorekl/kl4kids.webp"
      },
      {
        "name": S.of(context).sightseeing,
        "image": "https://www.kltheguide.com.my/assets/img/explorekl/ss.webp"
      },
      {
        "name": S.of(context).parks,
        "image": "https://www.klangvalley4locals.com.my/assets/img/wtd/ig/2.jpg"
      },
    ];

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(S.of(context).exploreKL, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 0, 71, 133),
        actions: const [AppBarMore()],
      ),
      body: ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          final item = dataList[index];
          return CardItem(
            name: item["name"],
            image: item["image"],
            index: index,
          );
        },
      ),
    );
  }
}

class CardItem extends StatelessWidget {
  final String name;
  final String image;
  final int index;

  const CardItem({
    Key? key,
    required this.name,
    required this.image,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/explorekl-$index',
            arguments: {'index': index});
      },
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.all(10),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: CachedNetworkImage(
            imageUrl: image,
            fit: BoxFit.cover, // Make the image cover the entire card
            placeholder: (context, url) => Center(
              child: CircularProgressIndicator(), // Placeholder while loading
            ),
            errorWidget: (context, url, error) => Center(
              child: Icon(
                Icons.error,
                color: Colors.red,
              ), // Error placeholder
            ),
            // You can adjust the cache width and height as needed
            memCacheWidth: 200,
            memCacheHeight: 200,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover, // Make the image cover the entire card
                ),
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.black.withOpacity(0.5),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: const Text("Details", style: TextStyle(color: Colors.white)),
        // foregroundColor: const Color.fromARGB(255, 0, 71, 133),
        backgroundColor: const Color.fromARGB(255, 0, 71, 133),
        actions: const <Widget>[
          AppBarMore(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display article title
            CachedNetworkImage(
              imageUrl: image,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            const SizedBox(height: 16),

            Text(
              title, // Replace with the actual title key
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (content != '') const SizedBox(height: 16.0),

            // Display article content
            if (content != '')
              Text(
                content != ''
                    ? content
                    : '', // Replace with the actual content key
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),

            if (content2 != '')
              Text(
                content2, // Replace with the actual content key
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
            if (location != '')
              ListTile(
                leading: const Icon(Icons.location_pin),
                title: Text('Location: $location'),
                onTap: () {
                  // Add functionality to open the email app with the recipient's email address pre-filled
                  _launchURL(locationurl);
                },
              ),
            if (phone != '')
              ListTile(
                leading: const Icon(Icons.phone),
                title: Text('Phone: $phone'),
                onTap: () {
                  // Add functionality to open the email app with the recipient's email address pre-filled
                  _launchURL('tel:$phone');
                },
              ),
            if (hours != '')
              ListTile(
                leading: const Icon(Icons.watch_later),
                title: Text('Hours:\n $hours'),
              ),
            if (website != '')
              ListTile(
                leading: const Icon(Icons.public),
                title: Text('Website: $website'),
                onTap: () {
                  // Add functionality to open the email app with the recipient's email address pre-filled
                  _launchURL(website);
                },
              ),
            // Add other widgets to display additional details as needed
          ],
        ),
      ),
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
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // change your color here
        ),
        title: Text(
          S.of(context).whatToDo,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 71, 133),
        actions: const <Widget>[
          AppBarMore(),
        ],
      ),
      body: MyList8(
        items: [
          ItemData8(
            'Melissachens Skin Beauty Spa',
            'https://www.klangvalley4locals.com.my/assets/img/wtd/beauty/face/melissachens.jpg',
            'S117C, 1 Utama Shopping Centre, Bandar Utama, 47800 Petaling Jaya, Selangor',
            '10.00 am - 9.00 pm (Monday - Sunday)',
            '603-7727 1093',
          ),
          ItemData8(
            'Organic Face',
            'https://www.klangvalley4locals.com.my/assets/img/wtd/beauty/face/organic.jpg',
            'NRC-02-06, Sunway Nexis, 1, Jalan PJU 5/1, Kota Damansara, 47810 Petaling Jaya, Selangor',
            '11.00 am - 8.00 pm (Tuesday - Friday), 10.00 am - 7.00 pm (Saturday & Sunday), Closed on Monday',
            '6012-794 9924',
          ),
          ItemData8(
            'Herbaline (Ampang)',
            'https://www.klangvalley4locals.com.my/assets/img/wtd/beauty/face/herbaline.jpg',
            '2, Jalan 3, One Ampang Avenue, 68000 Ampang, Selangor',
            '10.30 am - 8.30 pm (Monday - Friday), 10.00 am - 8.30 pm (Saturday & Sunday)',
            '6012-910 9811',
          ),
          // Add more parks here
        ],
      ),
    );
  }
}

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

  MyList8({required this.items});

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
                    if (items[index].contact.isNotEmpty) ...[
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

class ExploreKL_HS2 extends StatefulWidget {
  const ExploreKL_HS2({super.key});

  @override
  State<ExploreKL_HS2> createState() => _ExploreKL_HS2();
}

class _ExploreKL_HS2 extends State<ExploreKL_HS2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // change your color here
        ),
        title: Text(
          S.of(context).historicalSites,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 71, 133),
        actions: const <Widget>[
          AppBarMore(),
        ],
      ),
      body: MyList(), // This is where the images and text will be displayed.
    );
  }
}

class MyList extends StatelessWidget {
  final List<ItemData> items = [
    ItemData(
      'I-City Theme Park',
      'https://www.klangvalley4locals.com.my/assets/img/wtd/sports/tp/icity.jpg',
      'If you are looking for a one-stop amusement centre that offers diverse experiences, head over to I-City Theme Park. It is divided into three main areas which comprise the -8 degrees SnoWalk that was constructed with the help of renowned ice sculptors, City of Digital Lights that is decorated with 1 million multicoloured LED lights and Water World with the first tornado ride in South East Asia',
    ),
    ItemData(
      'Wet World Water Park Shah Alam',
      'https://www.klangvalley4locals.com.my/assets/img/wtd/sports/tp/shah_alam.jpg',
      'Get ready to have some fun under the sun at Wet World Water Park Shah Alam. Following a tropical island theme, the exciting slides and rides at the water park include the Super Hurricane, Monsoon Buster, Thunder River, Caribbean Rider and Whirlwind Escape. There are also a few children’s wet playgrounds for the younger children to enjoy.',
    ),
    ItemData(
      'Sunway Lagoon',
      'https://www.klangvalley4locals.com.my/assets/img/wtd/sports/tp/sunway.jpg',
      'Would you like to see what it\'s like to live in a palace? The Royal Museum is perhaps the best location to see and experience the royal way of life. The Royal Museum opened its doors on 1 February 2013, is housing in the old National Palace, which served as the official residence of Malaysia\'s King and Queen. The former National Palace has been turned into a museum and is now open to the public. Within this two-story structure, you will see the Balairung Seri (a room where the King addresses his subjects), the sleeping chamber, the royal office, the dining hall, and the nation\'s King\'s resting lounge.',
    ),
    ItemData(
      'AirRider Indoor Skydiving',
      'https://www.klangvalley4locals.com.my/assets/img/wtd/sports/ex/air_rider.jpg',
      'Experience the thrill of skydiving without worrying about the frightening fear of jumping off a plane at 14, 000 feet above the ground at AirRider Indoor Skydiving. Housed within 1 Utama Shopping Centre, this simulated experience is equivalent to the real deal but it occurs within a wind tunnel boosting up to 220 km/h for 50 seconds!',
    ),
    ItemData(
      'TREX Bike Park',
      'https://www.klangvalley4locals.com.my/assets/img/wtd/sports/ex/TREX%20Bike%20Park.jpg',
      'Boasting an elaborate bicycle circuit within a lush landscaped park is the recently developed TREX Bike Park. Apart from clear signs, the layout contains asphalt roads with direction (including merging lanes), back-to-back bumpy BMX tracks and varnished wooden MTB trails. There is also a spacious bike parking area that’s modelled into quirky shapes. Additionally, there is a bicycle shop inside to acquire rentals; mainly mountain bikes and city bikes for a very affordable rate. However, guests are definitely allowed to bring their own. Essentially, the park is designed towards families, cycling novices as well as MTB and BMX practitioners.',
    ),
  ];

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
}

class ItemData {
  final String text;
  final String imageUrl;
  final String content;

  ItemData(
    this.text,
    this.imageUrl,
    this.content,
  );
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
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // change your color here
        ),
        title: Text(
          S.of(context).parks,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 71, 133),
        actions: const <Widget>[
          AppBarMore(),
        ],
      ),

      body: MyList7(
        items: [
          ItemData7(
            'Botanica Co Cafe',
            'https://www.klangvalley4locals.com.my/assets/img/wtd/ig/1.jpg',
            'G5, 8, Jalan Kerinchi, Bangsar South, 59200 Kuala Lumpur, Wilayah Persekutuan Kuala Lumpur',
            '11.30 am - 10.00 pm (Monday - Wednesday), 11.30 am - 12.00 am (Friday), 9.30 am - 12.00 am (Saturday), 9.30 am - 10.00 pm (Sunday)',
            '+6016-965 6422',
          ),
          ItemData7(
            'Wildflowers KL',
            'https://www.klangvalley4locals.com.my/assets/img/wtd/ig/2.jpg',
            '153, Jalan Petaling, City Centre, 50000 Kuala Lumpur, Wilayah Persekutuan Kuala Lumpur',
            '12.00 pm - 12.00 am (Friday - Sunday), 12.00 pm - 10.30 pm (Monday - Thursday), Closed on Tuesday',
            '+603-2856 3369',
          ),
          ItemData7(
            'A Pie Thing',
            'https://www.klangvalley4locals.com.my/assets/img/wtd/ig/3.jpg',
            '128 G, Jalan SS 21/35, Damansara Utama, 47400 Petaling Jaya, Selangor',
            '10.00 am - 9.00 pm (Tuesday - Sunday), Closed on Monday',
            '+6012-951 5233',
          ),
          // Add more parks here
        ],
      ),
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

  MyList7({required this.items});

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
                    if (items[index].contact.isNotEmpty) ...[
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

class ExploreKL_KL4K2 extends StatefulWidget {
  const ExploreKL_KL4K2({super.key});

  @override
  _ExploreKL_KL4K2State createState() => _ExploreKL_KL4K2State();
}

class _ExploreKL_KL4K2State extends State<ExploreKL_KL4K2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // change your color here
        ),
        title: Text(S.of(context).kl4kids, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 0, 71, 133),
        actions: const <Widget>[
          AppBarMore(),
        ],
      ),
      body: MyList6(
        items: [
          ItemData6(
            'KidZania',
            'https://www.klangvalley4locals.com.my/assets/img/wtd/kv4kids/kidzania.jpg',
            'Curve NX, 18, Jalan PJU 7/5, Mutiara Damansara, 47810 Petaling Jaya, Selangor',
            '10.00 am - 6.00 pm (Monday - Sunday), Closed on Tuesday',
            '+603-3310 0229',
          ),
          ItemData6(
            'Jungle Gym',
            'https://www.klangvalley4locals.com.my/assets/img/wtd/kv4kids/gym.jpg',
            '2nd Floor, Atria Shopping Gallery, Jalan SS 22/23, Damansara Jaya, 47400 Petaling Jaya, Selangor',
            '10.00 am - 7.00 pm (Monday - Sunday)',
            '+603-7731 7193',
          ),
          ItemData6(
            'Farm In The City',
            'https://www.klangvalley4locals.com.my/assets/img/wtd/kv4kids/farm.jpg',
            'Lot 40187-40188, Jalan Prima Tropika Barat 1, Pusat Bandar Putra Permai, 43300 Seri Kembangan, Selangor',
            '10.00 am - 6.00 pm (Monday - Friday), 9.30 am - 6.00 pm (Saturday - Sunday), Closed on Tuesday (Except public and school holiday)',
            '+603-20223943',
          ),
          ItemData6(
            'Milky Way Play Space',
            'https://www.klangvalley4locals.com.my/assets/img/wtd/kv4kids/milky.jpg',
            '1, Jalan SS 7/26a, SS 7, 47301 Petaling Jaya, Selangor',
            '10.00 am - 10.00 pm (Monday - Sunday)',
            '+603-7801 11881',
          ),
          // Add more kids-friendly places here
        ],
      ),
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
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: S.of(context).muslim),
              Tab(text: S.of(context).buddhistTao),
              Tab(text: S.of(context).hindu),
              Tab(text: S.of(context).others),
            ],
            unselectedLabelColor: Colors.white,
            labelColor: Colors.white,
            labelStyle: TextStyle(fontWeight: FontWeight.w800),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
          ),
          title: Text(S.of(context).placesOfWorship,
              style: TextStyle(color: Colors.white)),
          backgroundColor: const Color.fromARGB(255, 0, 71, 133),
          actions: const <Widget>[
            AppBarMore(),
          ],
        ),
        body: TabBarView(
          children: [
            MyList2(
              items: [
                ItemData2(
                  'Sultan Salahuddin Abdul Aziz Mosque',
                  'https://www.klangvalley4locals.com.my/assets/img/explorekv/pwor/muslim/salahuddin.jpg',
                  'Persiaran Masjid St., Sekysen 14, 40000 Shah Alam, Selangor',
                  'Open everyday from 9am to 12:30pm, 2:30 to 6:30pm',
                  'https://www.mssaas.gov.my/',
                  '03-5523 8006',
                ),
                ItemData2(
                  'Sultan Suleiman Royal Mosque',
                  'https://www.klangvalley4locals.com.my/assets/img/explorekv/pwor/muslim/suleiman.jpg',
                  'Jalan Raya Timur, Kawasan 1, 41000 Klang, Selangor',
                  'Open 24 hours',
                  'https://selangor.travel/listing/sultan-suleiman-royal-mosque/',
                  '03-3374 3391',
                ),
                ItemData2(
                  'Raja Haji Fisabilillah Mosque',
                  'https://www.klangvalley4locals.com.my/assets/img/explorekv/pwor/muslim/raja.jpg',
                  'Persiaran Semarak Api, 63000 Cyberjaya, Selangor',
                  'Open 24 hours',
                  'https://www.facebook.com/masjidrajahajifisabilillah/?locale=ms_MY',
                  '03-8322 0096',
                ),
                ItemData2(
                  'Masjid Hussain Seremban 2',
                  'https://www.klangvalley4locals.com.my/assets/img/explorekv/pwor/muslim/hussain.jpg',
                  'Seremban 2, 70300 Seremban, Negeri Sembilan',
                  'Open everyday from 9am to 5pm',
                  'https://www.masjidhussain.com.my/',
                  '+606-601 7563',
                ),
                // Add more Muslim places of worship here
              ],
            ),
            MyList2(
              items: [
                ItemData2(
                  'Thai Buddhist Chetawan Temple',
                  'https://www.klangvalley4locals.com.my/assets/img/explorekv/pwor/tao/thai.jpg',
                  'No.24, Jalan Pantai 9/7, Seksyen 10, 46000 Petaling Jaya, Selangor',
                  'Open everyday from 8:30am to 5pm',
                  'https://www.facebook.com/ThaiBuddhistChetawanTemple/',
                  '+603-7955 2443',
                ),
                ItemData2(
                  'Fo Guang Shan Dong Zen Temple',
                  'https://www.klangvalley4locals.com.my/assets/img/explorekv/pwor/tao/guang_shan.jpg',
                  'Pt 2297, Jalan Sungai Buaya, Kampung Jenjarom, 42600 Jenjarom, Selangor',
                  '10.00 am - 10.00 pm (Tuesday - Sunday)/Closed on Monday',
                  'https://www.facebook.com/fgsdongzen/',
                  '+603-3191 1533',
                ),
                ItemData2(
                  'Then Sze Koon Temple',
                  'https://www.klangvalley4locals.com.my/assets/img/explorekv/pwor/tao/then_sze.jpg',
                  'Jalan Bukit Termiang 1, 70200 Seremban, Negeri Sembilan',
                  '8.00 am - 6.30 pm (Monday - Sunday)',
                  'https://www.facebook.com/ThenSzeKhoonTempleSerembanN9/',
                  '+6012-690 5515',
                ),

                // Add more Buddhist/Tao places of worship here
              ],
            ),
            MyList2(
              items: [
                ItemData2(
                  'Klang Perumal Temple',
                  'https://www.klangvalley4locals.com.my/assets/img/explorekv/pwor/hindu/klang.jpg',
                  '80, Jalan Mastika Off Psn Raja Muda Musa, Selangor, 41100 Klang',
                  'Open 24 hours (Monday - Sunday)',
                  'https://www.facebook.com/perumaltempleklg1/?locale=ms_MY',
                  '+603-3371 1763',
                ),
                ItemData2(
                  'Batu Caves Temple',
                  'https://www.kltheguide.com.my/assets/img/explorekl/pwor/batucaves.jpg',
                  'Gombak, 68100 Batu Caves, Selangor',
                  'Open 24 hours (Monday - Sunday)',
                  'https://www.facebook.com/BatuCavesTemple/',
                  '+603-6189 6284',
                ),
                ItemData2(
                  'Sri Shakti Devasthanam',
                  'https://www.klangvalley4locals.com.my/assets/img/explorekv/pwor/hindu/sri_shakti.jpg',
                  'Jalan Kuala Selangor, Bukit Rotan, 45700 Bukit Rotan, Selangor',
                  'Open everyday from 7am to 12pm, 5pm to 9pm',
                  'https://srishaktitemple.com.my/',
                  '+6012-303 0289',
                ),
                // Add more Hindu places of worship here
              ],
            ),
            MyList2(
              items: [
                ItemData2(
                  'Church of Lady Lourdes',
                  'https://www.klangvalley4locals.com.my/assets/img/explorekv/pwor/other/lady.jpg',
                  'No.114, Jalan Tengku Kelana, Kawasan 1, 41000 Klang, Selangor',
                  'Open everyday from 8:30am to 5:30pm, Closed on Monday',
                  'https://www.facebook.com/ollklang/',
                  '+603-3371 3053',
                ),
                ItemData2(
                  'Church of the Holy Redeemer',
                  'https://www.klangvalley4locals.com.my/assets/img/explorekv/pwor/other/redeemer.jpg',
                  'Taman Berkeley, 41150 Klang, Selangor',
                  '9.00 am - 4.30 pm (Monday - Friday)/9.00 am - 12.30 (Saturday - Sunday)',
                  'https://www.facebook.com/hrckelang/',
                  '+603-3341 6812',
                ),
                ItemData2(
                  'Church of The Holy Rosary',
                  'https://www.kltheguide.com.my/assets/img/explorekl/pwor/Church%20of%20The%20Holy%20Rosary%20(30).jpg',
                  'Holy Rosary Church, 10, Jalan Tun Sambanthan, 50470 Kuala Lumpur',
                  'Opens everyday from 9:30am to 4:30pm',
                  'http://www.hrckl.com/',
                  '+603-2274 2747',
                ),
                ItemData2(
                  'Kuala Lumpur Baptist Church',
                  'https://www.kltheguide.com.my/assets/img/explorekl/pwor/4.jpg',
                  '70, Changkat Bukit Bintang, Bukit Bintang, 50200 Kuala Lumpur',
                  '9.30am - 12.30pm (Sun) /8.30am - 4.30pm (Mon-Fri) /Closed on Saturday',
                  'http://www.klbc.org.my/',
                  '+603-2141 9154',
                ),
                ItemData2(
                  'Praise City Church, KL',
                  'https://www.kltheguide.com.my/assets/img/explorekl/pwor/5.jpg',
                  'No. 5 Jalan 1/118C, Desa Tun Razak Industrial Park, Bandar Tun Razak, 56000, Federal Territory of Kuala Lumpur',
                  '9.00am - 5.00pm (Tue-Fri) /9.00am - 1.00pm (Weekend) /Closed on Monday',
                  'http://www.praisecitykl.com/',
                  '+603-9171 3616',
                ),
                ItemData2(
                  'Guru Nanak Darbar Tatt Khalsa Diwan Gurdwara',
                  'https://www.kltheguide.com.my/assets/img/explorekl/pwor/Guru%20Nanak%20Darbar%20Tatt%20Khalsa%20Diwan%20Gurdwara.jpg',
                  '24, Jalan Raja Alang, Chow Kit, 50300 Kuala Lumpur',
                  'Opens everyday from 9:00AM to 5:00PM',
                  'https://facebook.com/TattKhalsaDiwan/',
                  '+603-2692 2215',
                ),
                ItemData2(
                  'Gurudwara Sahib Titiwangsa',
                  'https://www.kltheguide.com.my/assets/img/explorekl/pwor/7%20(30).jpg',
                  '41, Jalan Pahang, Titiwangsa, 53000 Kuala Lumpur',
                  'Opens everyday from 6am to 10pm',
                  'https://www.facebook.com/GSTitiwangsa/',
                  '03-4031 5531',
                ),
                ItemData2(
                  'Gurdwara Sahib Kuyow',
                  'https://www.kltheguide.com.my/assets/img/explorekl/pwor/10.jpg',
                  'Sungai Besi, 57000 Kuala Lumpur',
                  'Opens everyday from 6am to 9pm',
                  'https://www.facebook.com/GurdwaraSahibKuyow/',
                  '+6018-967 7083',
                ),
                // Add more other places of worship here
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MyList2 extends StatelessWidget {
  final List<ItemData2> items;

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
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _launchURL(items[index].website);
                      },
                      child: Text(
                        'Website: ${items[index].website}',
                        style: const TextStyle(
                          fontSize: 16.0,
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
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: S.of(context).streetFood), //malay
              Tab(text: S.of(context).cafes), //cina
              Tab(text: S.of(context).restaurants), //indian
            ],
            unselectedLabelColor: Colors.white,
            labelColor: Colors.white,
            labelStyle: TextStyle(fontWeight: FontWeight.w800),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
          ),
          title: Text(S.of(context).whatToEat,
              style: TextStyle(color: Colors.white)),
          backgroundColor: const Color.fromARGB(255, 0, 71, 133),
          actions: const <Widget>[
            AppBarMore(),
          ],
        ),
        body: TabBarView(
          children: [
            // Street Food Tab
            MyList5(
              items: [
                ItemData5(
                  'Nasi Lemak Bumbung',
                  'https://www.klangvalley4locals.com.my/assets/img/explorekv/eo/malay/4.jpg',
                  '6, Jalan 21/11b, Sea Park, 46300 Petaling Jaya, Selangor',
                  'Open everyday from 4pm to 12am',
                ),
                ItemData5(
                  'Mee Udang Banjir Kuala Selangor',
                  'https://www.klangvalley4locals.com.my/assets/img/explorekv/eo/malay/5.jpg',
                  '587, Jalan Bandar Baru Batu 2, Pasir Penambang, 45000 Kuala Selangor, Selangor',
                  '11.00 am - 6.00 pm (Tuesday - Sunday)/2.30 pm - 6.00 pm (Friday)/Closed on Monday',
                ),
                ItemData5(
                  'Warung Ibu Nasi Ambeng',
                  'https://www.klangvalley4locals.com.my/assets/img/explorekv/eo/malay/6.jpg',
                  'Lot 216, Batu 6, Jalan Bernam, Sungai Gulang-Gulang, 45500 Tanjung Karang, Selangor',
                  '11.30 am - 3.00 pm (Monday - Sunday)',
                ),
                // Add more malay Food places here
              ],
            ),
            // Cafes Tab
            MyList5(
              items: [
                ItemData5(
                  'Yap Kee Banana Leaf',
                  'https://www.klangvalley4locals.com.my/assets/img/explorekv/eo/chinese/3.jpg',
                  '26, Jalan Besar, Kawasan 1, 41000 Klang, Selangor',
                  '11.00 am - 4.00 pm (Daily)',
                ),
                ItemData5(
                  'Chong - Kee Kampar Claypot Chicken Rice',
                  'https://www.klangvalley4locals.com.my/assets/img/explorekv/eo/chinese/2.jpg',
                  '80, Jalan SS 22/25, Damansara Jaya, 47400 Petaling Jaya, Selangor',
                  '11.00 am - 8.30 pm (Daily)/Closed on Wednesday',
                ),
                ItemData5(
                  'Samy & Ah Her Bak Kut Teh',
                  'https://www.klangvalley4locals.com.my/assets/img/explorekv/eo/chinese/8.jpg',
                  '1, Jalan Lang, Taman Berkeley, 41150 Klang, Selangor',
                  '8.00 am - 2.00 pm (Monday - Sunday',
                ),
                // Add more chinese restaurants here
              ],
            ),
            // Restaurants Tab
            MyList5(
              items: [
                ItemData5(
                  'Thosai Cafè',
                  'https://www.klangvalley4locals.com.my/assets/img/explorekv/eo/indian/1.jpg',
                  'Ground floor, Curve mall, Mutiara Damansara, 47800 Petaling Jaya',
                  '11.00 am - 9.30 pm (Daily)',
                ),
                ItemData5(
                  'Curry Leaf Restaurant',
                  'https://www.klangvalley4locals.com.my/assets/img/explorekv/eo/indian/13.jpg',
                  '3 75, Jalan SS 21/37, Damansara Utama, 47400 Petaling Jaya, Selangor',
                  '8.00 am - 8.00 pm (Monday - Sunday)',
                ),
                ItemData5(
                  'Grand Neelas Restaurant',
                  'https://www.klangvalley4locals.com.my/assets/img/explorekv/eo/indian/19.jpg',
                  '31, Jalan Kenari 17, Bandar Puchong Jaya, 47100 Puchong, Selangor',
                  '8.00 am - 10.00 pm (Monday - Sunday)',
                ),
                // Add more indian Restaurants here
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MyList5 extends StatelessWidget {
  final List<ItemData5> items;

  MyList5({required this.items});

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

class ItemData5 {
  final String text;
  final String imageUrl;
  final String location;
  final String hours;

  ItemData5(
    this.text,
    this.imageUrl,
    this.location,
    this.hours,
  );
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
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: S.of(context).nightLife),
              Tab(text: S.of(context).bars),
              Tab(text: S.of(context).nightMarket),
            ],
            unselectedLabelColor: Colors.white,
            labelColor: Colors.white,
            labelStyle: TextStyle(fontWeight: FontWeight.w800),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
          ),
          title: Text(S.of(context).nightLife,
              style: TextStyle(color: Colors.white)),
          backgroundColor: const Color.fromARGB(255, 0, 71, 133),
          actions: const <Widget>[
            AppBarMore(),
          ],
        ),
        body: TabBarView(
          children: [
            MyList3(
              items: [
                ItemData3(
                  'Changkat, Bukit Bintang',
                  'https://www.kltheguide.com.my/assets/img/explorekl/nl/Changkat.jpg',
                  'Bukit Bintang, Kuala Lumpur, Federal Territory of Kuala Lumpur',
                  '24 hours',
                  '',
                ),
                ItemData3(
                  'Bangsar',
                  'https://www.kltheguide.com.my/assets/img/explorekl/nl/bangsar.png',
                  'Bangsar, 59000 Kuala Lumpur, Federal Territory of Kuala Lumpur',
                  '24 hours',
                  '',
                ),
                ItemData3(
                  'Ampang',
                  'https://www.kltheguide.com.my/assets/img/explorekl/nl/1024px-JalanAmpangNight.jpg',
                  'Ampang, Federal Territory of Kuala Lumpur',
                  '24 hours',
                  '',
                ),
                ItemData3(
                  'Petaling Street',
                  'https://www.kltheguide.com.my/assets/img/explorekl/nl/1024px-Petaling_Street,_Kuala_Lumpur.jpg',
                  'Jalan Petaling, City Centre, 50000 Kuala Lumpur, Wilayah Persekutuan Kuala Lumpur',
                  '24 hours',
                  '',
                ),
                // Add more Night-Life places here
              ],
            ),
            MyList3(
              items: [
                ItemData3(
                  'Marini \'s On 57',
                  'https://lh3.googleusercontent.com/p/AF1QipOw-nEwlxUnjIX50EgmfBVdO24HGkvKGgW0XsCv=s680-w680-h510',
                  '57 Menara 3 Petronas Persiaran, Kuala Lumpur City Centre, 50088 Kuala Lumpur',
                  '5.00 pm - 3.00 am (Daily)',
                  'https://reservations.marinisgroup.com/',
                ),
                ItemData3(
                  'Heli Lounge Bar',
                  'https://www.kltheguide.com.my/assets/img/explorekl/nl/Heli%20Lounge%20Bar%20(30).png',
                  '4 Menara KH, Jalan Sultan Ismail, Bukit Bintang, 50450, Wilayah Persekutuan Kuala Lumpur',
                  '5.00 pm - 12.00 am (Sun-Wed)',
                  'https://theroof.com.my/',
                ),
                ItemData3(
                  'Zeta Bar',
                  'https://www.kltheguide.com.my/assets/img/explorekl/nl/zeta%20bar%20(30).png',
                  'Level 5, 3, Jalan Stesen Sentral, Kuala Lumpur Sentral, 50470 Kuala Lumpur',
                  '10 am - 10 pm (Daily)',
                  'https://www.facebook.com/ZetaBarHKL/',
                ),
                // Add more Bars here
              ],
            ),
            MyList3(
              items: [
                ItemData3(
                  'Connaught Night market',
                  'https://www.kltheguide.com.my/assets/img/explorekl/nl/11.jpg',
                  '130, 108, Jalan Cerdas, Taman Connaught, 56000 Kuala Lumpur',
                  '6.00 pm - 1.00 am (Wednesday)',
                  '',
                ),
                ItemData3(
                  'Petaling Street',
                  'https://www.kltheguide.com.my/assets/img/explorekl/nl/12.jpg',
                  'Jalan Petaling, City Centre, 50000 Kuala Lumpur',
                  '8.00 am - 8.00 pm (Monday - Sunday)',
                  '',
                ),
                ItemData3(
                  'Kasturi Walk',
                  'https://www.kltheguide.com.my/assets/img/explorekl/nl/13.jpg',
                  'Jalan Hang Kasturi, City Centre, 50050 Kuala Lumpur',
                  'Open 24 Hours',
                  '',
                ),

                // Add more Night Markets here
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MyList3 extends StatelessWidget {
  final List<ItemData3> items;

  MyList3({required this.items});

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
                    if (items[index].website.isNotEmpty)
                      const SizedBox(height: 8.0),
                    if (items[index].website.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _launchURL(items[index].website);
                        },
                        child: Text(
                          'Website: ${items[index].website}',
                          style: const TextStyle(
                            fontSize: 16.0,
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

class ItemData3 {
  final String text;
  final String imageUrl;
  final String location;
  final String hours;
  final String website;

  ItemData3(this.text, this.imageUrl, this.location, this.hours, this.website);
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
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: S.of(context).mustVisit),
              Tab(text: S.of(context).museums),
              Tab(text: S.of(context).klArtScene),
            ],
            unselectedLabelColor: Colors.white,
            labelColor: Colors.white,
            labelStyle: TextStyle(fontWeight: FontWeight.w800),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
          ),
          title: Text(S.of(context).sightseeing,
              style: const TextStyle(color: Colors.white)),
          backgroundColor: const Color.fromARGB(255, 0, 71, 133),
          actions: const <Widget>[
            AppBarMore(),
          ],
        ),
        body: TabBarView(children: [
          // Must Visit Tab
          MyList4(
            items: [
              ItemData4(
                'Orang Asli Crafts Museum',
                'https://www.klangvalley4locals.com.my/assets/img/explorekv/ss/hs/1.jpg',
                'Jalan Ampang, Golden Triangle, Kuala Lumpur City Centre, 50088',
                '10:00 am to 10:00 pm',
                '+603 2382 2828',
              ),
              ItemData4(
                'Istana Negara',
                'https://www.kltheguide.com.my/assets/img/explorekl/ss/1024px-ISTANA_NEGARA_MALAYSIA.jpg',
                'Jalan Tuanku Abdul Halim, Bukit Damansara, 50480 Kuala Lumpur',
                '24 hours',
                '03-6200 1000',
              ),
              ItemData4(
                'Tunku Abdul Rahman Putra Memorial',
                'https://www.kltheguide.com.my/assets/img/explorekl/ss/tarmemo.webp',
                'Jalan Dato Onn, 50480 Kuala Lumpur',
                '10.00am - 5.30pm (Tuesday to Sunday) , 12.00pm - 3.00pm (Temporary closed on Friday)',
                '+603-2694 7277',
              ),
              ItemData4(
                'Menara Kuala Lumpur/ KL Tower',
                'https://www.kltheguide.com.my/assets/img/explorekl/ss/kuala-lumpur-2720830_1280.jpg',
                'No. 2 Jalan Punchak Off Jalan P.Ramlee 50250 Kuala Lumpur',
                '11.00 am - 7.00 pm (Monday - Friday), 10.00 am - 10.00 pm (Saturday - Sunday)',
                '+603 2693 7905',
              ),
              // Add more Must Visit places here
            ],
          ),
          // Museums Tab
          MyList4(
            items: [
              ItemData4(
                'Ethnology of the Malay World Museum',
                'https://www.kltheguide.com.my/assets/img/explorekl/ss/1.jpg',
                'Jalan Damansara, Tasik Perdana, 50480 Kuala Lumpur',
                '9.00 am - 5.00 pm (Tuesday - Sunday), Closed on Monday',
                '+603-2267 1000',
              ),
              ItemData4(
                'National Textiles Museum',
                'https://www.kltheguide.com.my/assets/img/explorekl/ss/2.webp',
                '26, Jalan Sultan Hishamuddin, City Centre, 50000 Kuala Lumpur',
                '9.00 am - 6.00 pm (Daily)',
                '',
              ),
              ItemData4(
                'Museum of Asian Arts',
                'https://www.kltheguide.com.my/assets/img/explorekl/ss/3.webp',
                'Jalan Ilmu, 50603 Kuala Lumpur, Wilayah Persekutuan Kuala Lumpur',
                '8.30 am - 5.00 pm (Monday - Thursday), 8.30am - 5.00pm (Friday)',
                '+603-796 7380',
              ),
              // Add more Museums here
            ],
          ),
          // KL Art Scene Tab
          MyList4(
            items: [
              ItemData4(
                'Urban Museum',
                'https://www.kltheguide.com.my/assets/img/explorekl/ss/urmu.jpg',
                '3, Jalan Bedara, Bukit Bintang, 50200 Kuala Lumpur, Wilayah Persekutuan Kuala Lumpur',
                '10.00 am - 8.30 pm (Tuesday - Sunday), Closed on Monday',
                '+603-2110 3004',
              ),
              ItemData4(
                'National Art Gallery',
                'https://www.kltheguide.com.my/assets/img/explorekl/ss/1art.jpg',
                'No. 2, Jalan Temerloh, Titiwangsa, 53200 Kuala Lumpur',
                'Operation Hours :10.00 am - 4.00 pm (Tuesday - Sunday), Closed on Monday',
                '+603-4026 7000',
              ),
              ItemData4(
                'OUR ArtProjects (The Zhongshan Building)',
                'https://www.kltheguide.com.my/assets/img/explorekl/ss/2.jpg',
                '80A, Jalan Rotan, Kampung Attap, 50460 Kuala Lumpur',
                '11.00 am - 7.00 pm (Tuesday - Saturday), Closed on Sunday & Monday',
                '+6016-660 2585',
              ),

              // Add more KL Art Scene places here
            ],
          ),
        ]),
      ),
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
}

void _launchURL(url) async {
  var url2 = Uri.parse(url);
  if (await canLaunchUrl(url2)) {
    await launchUrl(url2, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $url';
  }
}
