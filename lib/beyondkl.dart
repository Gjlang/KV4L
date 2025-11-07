// // ignore_for_file: camel_case_types

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:klangvalley4locals/main.dart';
// import 'package:url_launcher/url_launcher.dart';

// class ApiData {
//   final String title;
//   final String content;
//   final String image;
//   final String location;

//   ApiData({
//     required this.location,
//     required this.title,
//     required this.content,
//     required this.image,
//   });

//   factory ApiData.fromJson(Map<String, dynamic> json) {
//     return ApiData(
//       title: json['title'] ?? '',
//       content: json['content'] ?? '',
//       image: json['image'] ?? '',
//       location: json['location'] ?? '',
//     );
//   }
// }

// Future<List<ApiData>> fetchData(bodyparse) async {
//   final response = await http.post(
//     Uri.parse('https://www.klangvalley4locals.com.my/admin/functions.php'),
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
//     Uri.parse('https://www.klangvalley4locals.com.my/admin/functions.php'),
//     body: {bodyparse: bodyparse, 'category': category},
//   );

//   if (response.statusCode == 200) {
//     final List<dynamic> jsonData = jsonDecode(response.body);
//     return jsonData.map((json) => ApiData.fromJson(json)).toList();
//   } else {
//     throw Exception('Failed to load data');
//   }
// }

// class CardListWidget extends StatelessWidget {
//   final List<ApiData> data;

//   const CardListWidget({super.key, required this.data});

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: data.length,
//       itemBuilder: (context, index) {
//         final item = data[index];

//         return GestureDetector(
//           onTap: () {
//             // print(item.location);
//             if (item.location != '') {
//               _launchURL(item.location);
//             }
//           },
//           child: Card(
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
//           ),
//         );
//       },
//     );
//   }
// }

// class BeyondKL extends StatelessWidget {
//   final List<Map<String, dynamic>> dataList = [
//     {
//       "name": "Islands",
//       "image": "https://www.kltheguide.com.my/assets/img/beyondkl/ISLAND-01.jpg"
//     },
//     {
//       "name": "Hill Station",
//       "image":
//           "https://www.kltheguide.com.my/assets/img/beyondkl/HILL-STATION-01.jpg"
//     },
//     {
//       "name": "Waterfall",
//       "image":
//           "https://www.kltheguide.com.my/assets/img/beyondkl/WATERFALL-01.jpg"
//     },
//     {
//       "name": "Hiking",
//       "image": "https://www.kltheguide.com.my/assets/img/beyondkl/HIKING.jpg"
//     },
//     {
//       "name": "Extreme Sports",
//       "image":
//           "https://www.kltheguide.com.my/assets/img/beyondkl/EXTREME-SPORT-2.webp"
//     },

//     // Add more items as needed
//   ];

//   BeyondKL({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(
//           color: Colors.white, //change your color here
//         ),
//         title: const Text("Beyond KL", style: TextStyle(color: Colors.white)),
//         // foregroundColor: const Color.fromARGB(255, 0, 71, 133),
//         backgroundColor: const Color.fromARGB(255, 0, 71, 133),
//         actions: const <Widget>[
//           AppBarMore(),
//         ],
//       ),
//       body: ListView.builder(
//         itemCount: dataList.length,
//         itemBuilder: (context, index) {
//           final item = dataList[index];
//           return CardItem(
//               name: item["name"], image: item["image"], index: index);
//         },
//       ),
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
//         Navigator.pushNamed(context, '/beyondkl-$index',
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
//   final String name;
//   final String image;
//   final String location;

//   const DetailPage({
//     super.key,
//     required this.name,
//     required this.image,
//     required this.location,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(name),
//       ),
//       body: Center(
//         child: Text(location),
//       ),
//     );
//   }
// }

// class BeyondKL_I extends StatefulWidget {
//   const BeyondKL_I({super.key});

//   @override
//   _BeyondKL_IState createState() => _BeyondKL_IState();
// }

// class _BeyondKL_IState extends State<BeyondKL_I> {
//   late Future<List<ApiData>> _data;

//   @override
//   void initState() {
//     super.initState();
//     _data = fetchData('appBeyondKL_i');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(
//           color: Colors.white, //change your color here
//         ),
//         title: const Text("Islands", style: TextStyle(color: Colors.white)),
//         // foregroundColor: const Color.fromARGB(255, 0, 71, 133),
//         backgroundColor: const Color.fromARGB(255, 0, 71, 133),
//         actions: const <Widget>[
//           AppBarMore(),
//         ],
//       ),
//       body: FutureBuilder<List<ApiData>>(
//         future: _data,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             return CardListWidget(data: snapshot.data ?? []);
//           }
//         },
//       ),
//     );
//   }
// }

// class BeyondKL_HS extends StatefulWidget {
//   const BeyondKL_HS({super.key});

//   @override
//   _BeyondKL_HSState createState() => _BeyondKL_HSState();
// }

// class _BeyondKL_HSState extends State<BeyondKL_HS> {
//   late Future<List<ApiData>> _data;

//   @override
//   void initState() {
//     super.initState();
//     _data = fetchData('appBeyondKL_hs');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(
//           color: Colors.white, //change your color here
//         ),
//         title:
//             const Text("Hill Station", style: TextStyle(color: Colors.white)),
//         // foregroundColor: const Color.fromARGB(255, 0, 71, 133),
//         backgroundColor: const Color.fromARGB(255, 0, 71, 133),
//         actions: const <Widget>[
//           AppBarMore(),
//         ],
//       ),
//       body: FutureBuilder<List<ApiData>>(
//         future: _data,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             return CardListWidget(data: snapshot.data ?? []);
//           }
//         },
//       ),
//     );
//   }
// }

// class BeyondKL_W extends StatefulWidget {
//   const BeyondKL_W({super.key});

//   @override
//   _BeyondKL_WState createState() => _BeyondKL_WState();
// }

// class _BeyondKL_WState extends State<BeyondKL_W> {
//   late Future<List<ApiData>> _data;

//   @override
//   void initState() {
//     super.initState();
//     _data = fetchData('appBeyondKL_w');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(
//           color: Colors.white, //change your color here
//         ),
//         title: const Text("Waterfall", style: TextStyle(color: Colors.white)),
//         // foregroundColor: const Color.fromARGB(255, 0, 71, 133),
//         backgroundColor: const Color.fromARGB(255, 0, 71, 133),
//         actions: const <Widget>[
//           AppBarMore(),
//         ],
//       ),
//       body: FutureBuilder<List<ApiData>>(
//         future: _data,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             return CardListWidget(data: snapshot.data ?? []);
//           }
//         },
//       ),
//     );
//   }
// }

// class BeyondKL_H extends StatefulWidget {
//   const BeyondKL_H({super.key});

//   @override
//   _BeyondKL_HState createState() => _BeyondKL_HState();
// }

// class _BeyondKL_HState extends State<BeyondKL_H> {
//   late Future<List<ApiData>> _data;

//   @override
//   void initState() {
//     super.initState();
//     _data = fetchData('appBeyondKL_h');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(
//           color: Colors.white, //change your color here
//         ),
//         title: const Text("Hiking", style: TextStyle(color: Colors.white)),
//         // foregroundColor: const Color.fromARGB(255, 0, 71, 133),
//         backgroundColor: const Color.fromARGB(255, 0, 71, 133),
//         actions: const <Widget>[
//           AppBarMore(),
//         ],
//       ),
//       body: FutureBuilder<List<ApiData>>(
//         future: _data,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             return CardListWidget(data: snapshot.data ?? []);
//           }
//         },
//       ),
//     );
//   }
// }

// class BeyondKL_ES extends StatefulWidget {
//   const BeyondKL_ES({super.key});

//   @override
//   _BeyondKL_ESState createState() => _BeyondKL_ESState();
// }

// class _BeyondKL_ESState extends State<BeyondKL_ES> {
//   late Future<List<ApiData>> _data;

//   @override
//   void initState() {
//     super.initState();
//     _data = fetchData('appBeyondKL_es');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(
//           color: Colors.white, //change your color here
//         ),
//         title:
//             const Text("Extreme Sports", style: TextStyle(color: Colors.white)),
//         // foregroundColor: const Color.fromARGB(255, 0, 71, 133),
//         backgroundColor: const Color.fromARGB(255, 0, 71, 133),
//         actions: const <Widget>[
//           AppBarMore(),
//         ],
//       ),
//       body: FutureBuilder<List<ApiData>>(
//         future: _data,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             return CardListWidget(data: snapshot.data ?? []);
//           }
//         },
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
