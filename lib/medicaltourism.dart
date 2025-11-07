import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:klangvalley4locals/main.dart';
import 'package:url_launcher/url_launcher.dart';

import 'generated/l10n.dart';

class MedicalT extends StatefulWidget {
  const MedicalT({super.key});

  @override
  _MedicalTState createState() => _MedicalTState();
}

class _MedicalTState extends State<MedicalT> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, // Change your color here
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: S.of(context).healthcare),
              Tab(text: S.of(context).dental),
              Tab(text: S.of(context).dermatologist),
              Tab(text: S.of(context).ophthalmologist),
              Tab(text: S.of(context).plasticSurgery),
            ],
            unselectedLabelColor: Colors.white,
            labelColor: Colors.white,
            labelStyle: TextStyle(fontWeight: FontWeight.w800),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
          ),
          title: const Text("Medical Tourism",
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
                ItemData(
                  title: 'Hospital Serdang',
                  imageUrl:
                      'https://www.klangvalley4locals.com.my/assets/img/medical_tourism/hc/hospital-serdang.jpg',
                  location: 'Jalan Puchong, 43000 Kajang, Selangor',
                  hours: 'Open 24 hours',
                  phone: '03-8947 5555',
                ),
                ItemData(
                  title: 'Colombia Asia Hospital',
                  imageUrl:
                      'https://www.klangvalley4locals.com.my/assets/img/medical_tourism/hc/columbia-hospital.jpg',
                  location:
                      'No 1, Jalan Danau Saujana, Off Jalan Genting Klang, 53300 Kuala, Malaysia',
                  hours: 'Open 24 hours',
                  phone: '03-7949 9999',
                ),
                ItemData(
                  title: 'Pantai Hospital Klang',
                  imageUrl:
                      'https://www.klangvalley4locals.com.my/assets/img/medical_tourism/hc/pantai-hospital-klang.jpg',
                  location:
                      'Lot 5921, Persiaran Raja Muda Musa, Taman Radzi, 41200 Klang, Selangor',
                  hours: 'Open 24 hours',
                  phone: '03-3258 5500',
                ),
                // Add more healthcare locations here
              ],
            ),
            MyList2(
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
                ),
                ItemData(
                  title: 'SmileGram Dental Clinic',
                  imageUrl:
                      'https://www.klangvalley4locals.com.my/assets/img/medical_tourism/dtl/smilegram.jpg',
                  location:
                      'First floor, No. 10A-2, Jalan 14/20, 46100 Petaling Jaya, Selangor',
                  hours: '9.30 am - 9.30 pm (Monday - Sunday)',
                  phone: '6013-252 9813',
                ),
                // Add more dental locations here
              ],
            ),
            MyList2(
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
                ),
                ItemData(
                  title: 'Dermlaze Skin Laser & Aesthetics Centre',
                  imageUrl:
                      'https://www.kltheguide.com.my/assets/img/medical_tourism/der/Dermlaze.jpeg',
                  location:
                      '75, Jalan SS 21/60, Damansara Utama, 47400 Petaling Jaya, Selangor',
                  hours: '10.00 AM - 06.00 PM (Mon - Sat)',
                  phone: '',
                ),
                ItemData(
                  title: 'Dr Kent Clinic',
                  imageUrl:
                      'https://www.klangvalley4locals.com.my/assets/img/medical_tourism/der/dr_kent.jpg',
                  location:
                      '51C, Jalan SS 21/37, Damansara Utama, 47410 Petaling Jaya, Selangor',
                  hours: '10.00 AM - 06.00 PM (Mon - Sat)',
                  phone: '+603-8052 3082',
                ),
                // Add more dermatologist locations here
              ],
            ),
            MyList2(
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
                ),
                ItemData(
                  title: 'Vista Eye Specialist',
                  imageUrl:
                      'https://www.kltheguide.com.my/assets/img/medical_tourism/oph/vista.jpg',
                  location:
                      'Lot G217, Ground Floor, Mid Valley Megamall, 59200 KL',
                  hours: 'Mon-Sun: 10:00 AM - 10:00 PM',
                  phone: '+603-22423937',
                ),
                ItemData(
                  title: 'TOPVISION Eye Specialist Centre',
                  imageUrl:
                      'https://www.klangvalley4locals.com.my/assets/img/medical_tourism/oph/top_vision.jpg',
                  location:
                      'Unit 11-2,3 & 5, No. 2 Block 2, Jalan Setia Prima (S) U13/S, Seksyen U13, Setia Alam, 40170 Shah Alam, Selangor',
                  hours: '9.00 am - 4.00 pm (Monday - Sunday)',
                  phone: '+603-3343 9911',
                ),
                // Add more ophthalmologist locations here
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
                      'phone: ${items[index].phone}',
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
  final String phone;

  ItemData({
    required this.title,
    required this.imageUrl,
    required this.location,
    required this.hours,
    required this.phone,
  });
}

void _launchURL(String url) async {
  var uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $url';
  }
}
















// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:kltheguide/main.dart';
// import 'package:url_launcher/url_launcher.dart';

// Future<List<ApiData>> fetchData(bodyparse) async {
//   final response = await http.post(
//     Uri.parse('https://www.kltheguide.com.my/admin/functions.php'),
//     body: {bodyparse: bodyparse},
//   );

//   if (response.statusCode == 200) {
//     final List<dynamic> jsonData = jsonDecode(response.body);
//     return jsonData.map((json) => ApiData.fromJson(json)).toList();
//   } else {
//     throw Exception('Failed to load data');
//   }
// }

// Future<List<ApiData>> fetchData2(bodyparse, category) async {
//   final response = await http.post(
//     Uri.parse('https://www.kltheguide.com.my/admin/functions.php'),
//     body: {bodyparse: bodyparse, 'category': category},
//   );

//   if (response.statusCode == 200) {
//     final List<dynamic> jsonData = jsonDecode(response.body);
//     return jsonData.map((json) => ApiData.fromJson(json)).toList();
//   } else {
//     throw Exception('Failed to load data');
//   }
// }

// class MedicalT extends StatefulWidget {
//   const MedicalT({super.key});

//   @override
//   _MedicalTState createState() => _MedicalTState();
// }

// class _MedicalTState extends State<MedicalT> {
//   late Future<List<ApiData>> _data;
//   late Future<List<ApiData>> _data2;

//   late Future<List<ApiData>> _data3;

//   late Future<List<ApiData>> _data4;

//   @override
//   void initState() {
//     super.initState();
//     _data = fetchData('appMedicalT_hc');
//     _data2 = fetchData(
//       'appMedicalT_dtl',
//     );
//     _data3 = fetchData(
//       'appMedicalT_der',
//     );
//     _data4 = fetchData(
//       'appMedicalT_oph',
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 4,
//       child: Scaffold(
//         appBar: AppBar(
//           iconTheme: const IconThemeData(
//             color: Colors.white, //change your color here
//           ),
//           bottom: const TabBar(
//             tabs: [
//               Tab(text: 'Healthcare'),
//               Tab(text: 'Dental'),
//               Tab(text: 'Dermatologist'),
//               Tab(text: 'Opthalmologist'),
//             ],
//             unselectedLabelColor: Colors.white,
//             labelColor: Colors.white,
//             labelStyle: TextStyle(fontWeight: FontWeight.w800),
//             unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
//           ),
//           title: const Text("Medical Tourism",
//               style: TextStyle(color: Colors.white)),
//           // foregroundColor: const Color.fromARGB(255, 0, 71, 133),
//           backgroundColor: const Color.fromARGB(255, 0, 71, 133),
//           actions: const <Widget>[
//             AppBarMore(),
//           ],
//         ),
//         body: TabBarView(children: [
//           FutureBuilder<List<ApiData>>(
//             future: _data,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (snapshot.hasError) {
//                 return Center(child: Text('Error: ${snapshot.error}'));
//               } else {
//                 return CardListWidget(data: snapshot.data ?? []);
//               }
//             },
//           ),
//           FutureBuilder<List<ApiData>>(
//             future: _data2,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (snapshot.hasError) {
//                 return Center(child: Text('Error: ${snapshot.error}'));
//               } else {
//                 return CardListWidget(data: snapshot.data ?? []);
//               }
//             },
//           ),

//           // Content for Tab 2
//           FutureBuilder<List<ApiData>>(
//             future: _data3,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (snapshot.hasError) {
//                 return Center(child: Text('Error: ${snapshot.error}'));
//               } else {
//                 return CardListWidget(data: snapshot.data ?? []);
//               }
//             },
//           ),

//           // Content for Tab 3
//           FutureBuilder<List<ApiData>>(
//             future: _data4,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (snapshot.hasError) {
//                 return Center(child: Text('Error: ${snapshot.error}'));
//               } else {
//                 return CardListWidget(data: snapshot.data ?? []);
//               }
//             },
//           ),
//         ]),
//       ),
//     );
//   }
// }

// class ApiData {
//   final String title;
//   final String content;
//   final String content2;
//   final String image;
//   final String location;
//   final String locationurl;
//   final String hours;
//   final String phone;
//   final String website;

//   ApiData({
//     required this.location,
//     required this.locationurl,
//     required this.hours,
//     required this.phone,
//     required this.title,
//     required this.content,
//     required this.content2,
//     required this.image,
//     required this.website,
//   });

//   factory ApiData.fromJson(Map<String, dynamic> json) {
//     return ApiData(
//       title: json['title'] ?? '',
//       content: json['content'] ?? '',
//       content2: json['content2'] ?? '',
//       image: json['image'] ?? '',
//       location: json['location'] ?? '',
//       locationurl: json['locationurl'] ?? '',
//       hours: json['hours'] ?? '',
//       phone: json['phone'] ?? '',
//       website: json['website'] ?? '',
//     );
//   }
// }

// class CardListWidget extends StatelessWidget {
//   final List<ApiData> data;

//   const CardListWidget({super.key, required this.data});

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       shrinkWrap: true,
//       itemCount: data.length,
//       itemBuilder: (context, index) {
//         final item = data[index];
//         if (item.location != '') {
//           return GestureDetector(
//             onTap: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => DetailPage(
//                             title: item.title,
//                             image: item.image,
//                             content: item.content,
//                             content2: item.content2,
//                             location: item.location,
//                             locationurl: item.locationurl,
//                             hours: item.hours.replaceAll('/', '\n'),
//                             phone: item.phone.replaceAll('/', '\n'),
//                             website: item.website,
//                             index: index,
//                           )));
//             },
//             child: Card(
//               elevation: 4.0,
//               margin: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   CachedNetworkImage(
//                     imageUrl: item.image,
//                     fit: BoxFit.cover,
//                     height: 200,
//                     width: double.infinity,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           (item.title),
//                           style: const TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         if (item.content != '') const SizedBox(height: 8.0),
//                         if (item.content != '')
//                           Text(item.content.replaceAll('\\n', '\n')),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         } else {
//           return Card(
//             elevation: 4.0,
//             margin: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CachedNetworkImage(
//                   imageUrl: item.image,
//                   fit: BoxFit.cover,
//                   height: 200,
//                   width: double.infinity,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         (item.title),
//                         style: const TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 8.0),
//                       Text(item.content.replaceAll('\\n', '\n')),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//       },
//     );
//   }
// }

// class CardItem extends StatelessWidget {
//   final String name;
//   final String image;
//   final int index;

//   const CardItem(
//       {super.key,
//       required this.name,
//       required this.image,
//       required this.index});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         // Navigate to a detail page or perform an action when the card is tapped
//         // You can use Navigator to navigate to a detail page with specific data
//         // For example: Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(name: name, image: image)));

//         Navigator.pushNamed(context, '/explorekl-$index',
//             arguments: {'index': index});
//       },
//       child: Card(
//         elevation: 3,
//         margin: const EdgeInsets.all(10),
//         child: AspectRatio(
//           aspectRatio: 16 / 9,
//           child: Container(
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: NetworkImage(image),
//                 fit: BoxFit.cover, // Make the image cover the entire card
//               ),
//             ),
//             child: Center(
//               child: Container(
//                 padding: const EdgeInsets.all(8),
//                 color: Colors.black
//                     .withOpacity(0.5), // Adjust the opacity as needed
//                 child: Text(
//                   name,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class DetailPage extends StatelessWidget {
//   final String title;
//   final String content;
//   final String content2;
//   final String image;
//   final String location;
//   final String locationurl;
//   final String hours;
//   final String phone;
//   final String website;
//   final int index;

//   const DetailPage({
//     super.key,
//     required this.location,
//     required this.locationurl,
//     required this.hours,
//     required this.phone,
//     required this.title,
//     required this.content,
//     required this.content2,
//     required this.image,
//     required this.website,
//     required this.index,
//   });

//   @override
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(
//           color: Colors.white, //change your color here
//         ),
//         title: const Text("Details", style: TextStyle(color: Colors.white)),
//         // foregroundColor: const Color.fromARGB(255, 0, 71, 133),
//         backgroundColor: const Color.fromARGB(255, 0, 71, 133),
//         actions: const <Widget>[
//           AppBarMore(),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Display article title
//             CachedNetworkImage(
//               imageUrl: image,
//               fit: BoxFit.cover,
//               width: double.infinity,
//             ),
//             const SizedBox(height: 16),

//             Text(
//               title, // Replace with the actual title key
//               style: const TextStyle(
//                 fontSize: 24.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             if (content != '') const SizedBox(height: 16.0),

//             // Display article content
//             if (content != '')
//               Text(
//                 content != ''
//                     ? content
//                     : '', // Replace with the actual content key
//                 style: const TextStyle(
//                   fontSize: 16.0,
//                 ),
//               ),

//             if (content2 != '')
//               Text(
//                 content2, // Replace with the actual content key
//                 style: const TextStyle(
//                   fontSize: 16.0,
//                 ),
//               ),
//             if (location != '')
//               ListTile(
//                 leading: const Icon(Icons.location_pin),
//                 title: Text('Location: $location'),
//                 onTap: () {
//                   // Add functionality to open the email app with the recipient's email address pre-filled
//                   _launchURL(locationurl);
//                 },
//               ),
//             if (phone != '')
//               ListTile(
//                 leading: const Icon(Icons.phone),
//                 title: Text('Phone: $phone'),
//                 onTap: () {
//                   // Add functionality to open the email app with the recipient's email address pre-filled
//                   _launchURL('tel:$phone');
//                 },
//               ),
//             if (hours != '')
//               ListTile(
//                 leading: const Icon(Icons.watch_later),
//                 title: Text('Hours:\n $hours'),
//               ),
//             if (website != '')
//               ListTile(
//                 leading: const Icon(Icons.public),
//                 title: Text('Website: $website'),
//                 onTap: () {
//                   // Add functionality to open the email app with the recipient's email address pre-filled
//                   _launchURL(website);
//                 },
//               ),
//             // Add other widgets to display additional details as needed
//           ],
//         ),
//       ),
//     );
//   }
// }

// void _launchURL(url) async {
//   var url2 = Uri.parse(url);
//   if (await canLaunchUrl(url2)) {
//     await launchUrl(url2, mode: LaunchMode.externalApplication);
//   } else {
//     throw 'Could not launch $url';
//   }
// }
