import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:klangvalley4locals/main.dart';


class Ebook extends StatelessWidget {
  final String imageUrl =
      'https://www.kltheguide.com.my/assets/img/ebook/kv4l/35.jpg';
  final String pdfUrl =
      'https://www.klangvalley4locals.com.my/ebook-details.php?id=106';

  Ebook({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Book'),
        backgroundColor: const Color.fromARGB(255, 0, 71, 133),
      ),
      body: GestureDetector(
        onTap: () async {
          if (await canLaunch(pdfUrl)) {
            await launch(pdfUrl);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Could not launch $pdfUrl'),
              ),
            );
          }
        },
        child: Card(
          elevation: 4.0,
          margin: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
                placeholder: (context, url) => const LinearProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Klang Valley 4 Locals 35',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
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
