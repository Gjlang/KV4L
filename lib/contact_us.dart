import 'package:flutter/material.dart';
import 'package:klangvalley4locals/main.dart';
import 'package:url_launcher/url_launcher.dart';

import 'generated/l10n.dart';

class ContactUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          // Hero Section with Gradient App Bar
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: const Color.fromARGB(255, 0, 71, 133),
            actions: const <Widget>[
              AppBarMore(),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Get In Touch',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 2),
                      blurRadius: 8.0,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/KV4L-Splash-Screen.png',
                    fit: BoxFit.cover,
                  ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          const Color(0xFF001F3F).withOpacity(0.4),
                          const Color(0xFFFF8C42).withOpacity(0.5),
                          const Color(0xFF0A1128).withOpacity(0.95),
                        ],
                        stops: const [0.0, 0.4, 0.75, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Main Content
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black,
                    const Color(0xFF0A1128),
                    Colors.black,
                  ],
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 24),

                  // Title Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        Text(
                          S.of(context).contact,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'We\'re here to help you explore Klang Valley',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.7),
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Contact Cards
                  _buildContactCard(
                    icon: Icons.email_rounded,
                    iconColor: const Color(0xFF00D4FF),
                    title: 'Email Us',
                    subtitle: 'enquiry@bluedale.com.my',
                    onTap: () => _launchURL('mailto:enquiry@bluedale.com.my'),
                  ),

                  _buildContactCard(
                    icon: MyFlutterApp.whatsapp,
                    iconColor: const Color(0xFF25D366),
                    title: 'WhatsApp',
                    subtitle: '+6012-220 0622',
                    onTap: () => _launchURL(
                        'https://api.whatsapp.com/send?phone=60122200622'),
                  ),

                  _buildContactCard(
                    icon: Icons.phone_rounded,
                    iconColor: const Color(0xFFFF6B9D),
                    title: 'Call Us',
                    subtitle: '+603-7886 9219',
                    onTap: () => _launchURL('tel:+60378869219'),
                  ),

                  _buildContactCard(
                    icon: Icons.location_on_rounded,
                    iconColor: const Color(0xFFFFB800),
                    title: 'Visit Our Office',
                    subtitle:
                        'No.31-2, Block F2, Level 2, Jalan PJU 1/42a\nDataran Prima, 47301 Petaling Jaya, Selangor',
                    onTap: () =>
                        _launchURL('https://goo.gl/maps/p2Ew3gSvjttiQdGY9'),
                    isMultiline: true,
                  ),

                  _buildContactCard(
                    icon: Icons.schedule_rounded,
                    iconColor: const Color(0xFF9C27B0),
                    title: 'Business Hours',
                    subtitle: 'Monday - Friday\n9:00 AM - 6:00 PM',
                    isMultiline: true,
                  ),

                  const SizedBox(height: 32),

                  // Quick Actions Section
                  _buildQuickActionsSection(),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    bool isMultiline = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A2947),
            const Color(0xFF0D1B2A),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: iconColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: iconColor.withOpacity(0.15),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Icon Container
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: iconColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    icon,
                    size: 28,
                    color: iconColor,
                  ),
                ),
                const SizedBox(width: 16),
                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: isMultiline ? 13 : 14,
                          color: Colors.white.withOpacity(0.7),
                          height: isMultiline ? 1.5 : 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                // Arrow Icon (only if tappable)
                if (onTap != null)
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: iconColor.withOpacity(0.5),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFF8C42).withOpacity(0.15),
            const Color(0xFF0D1B2A),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFFF8C42).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Need Help?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Our team is ready to assist you with travel tips, recommendations, and local insights about Klang Valley.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildQuickActionButton(
                icon: Icons.chat_bubble_rounded,
                label: 'Chat',
                color: const Color(0xFF00D4FF),
                onTap: () => _launchURL(
                    'https://api.whatsapp.com/send?phone=60122200622'),
              ),
              const SizedBox(width: 16),
              _buildQuickActionButton(
                icon: Icons.map_rounded,
                label: 'Directions',
                color: const Color(0xFFFFB800),
                onTap: () =>
                    _launchURL('https://goo.gl/maps/p2Ew3gSvjttiQdGY9'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.4),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
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
