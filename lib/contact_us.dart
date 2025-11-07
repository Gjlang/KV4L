import 'package:flutter/material.dart';
import 'package:klangvalley4locals/main.dart';
import 'package:url_launcher/url_launcher.dart';

import 'generated/l10n.dart';

class ContactUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(S.of(context).contact, style: TextStyle(color: Colors.white)),
        // foregroundColor: const Color.fromARGB(255, 0, 71, 133),
        backgroundColor: const Color.fromARGB(255, 0, 71, 133),
        actions: const <Widget>[
          AppBarMore(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/KV4L-Splash-Screen.png',
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
             Text(
              S.of(context).contact,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const SizedBox(height: 16.0),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email: enquiry@bluedale.com.my'),
              // onTap: () {
              //   // Add functionality to open the email app with the recipient's email address pre-filled
              //   _launchURL('mailto:enquiry@bluedale.com.my');
              // },
            ),
            ListTile(
              leading: const Icon(MyFlutterApp.whatsapp),
              title: const Text('Whatsapp: +6012-220 0622'),
              onTap: () {
                // Add functionality to initiate a phone call
                _launchURL('https://api.whatsapp.com/send?phone=60122200622');
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Phone: +603-78869219'),
              onTap: () {
                // Add functionality to initiate a phone call
                _launchURL('tel:+60378869219');
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text(
                  'No.31-2, Block F2, Level, 2, Jalan PJU 1/42a, Dataran Prima, 47301 Petaling Jaya, Selangor'),
              onTap: () {
                // Add functionality to open maps with the address

                _launchURL('https://goo.gl/maps/p2Ew3gSvjttiQdGY9');
              },
            ),
            const ListTile(
              leading: Icon(Icons.watch_later),
              title: Text('Monday-Friday : 9:00AM - 6:00PM'),
            ),
          ],
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
