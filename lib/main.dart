// ignore_for_file: constant_identifier_names
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klangvalley4locals/blog_page.dart';
import 'package:klangvalley4locals/contact_us.dart';
import 'package:klangvalley4locals/explorekl.dart';
import 'package:klangvalley4locals/shop.dart';
import 'package:klangvalley4locals/spa.dart';
import 'package:klangvalley4locals/stay.dart';
import 'package:klangvalley4locals/beyondkl.dart';
import 'package:klangvalley4locals/medicaltourism.dart';
import 'package:klangvalley4locals/highlights.dart';
import 'package:klangvalley4locals/home_page.dart';
import 'package:klangvalley4locals/about_us.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'ebook_page.dart';
import 'package:in_app_update/in_app_update.dart';
import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  MobileAds.instance.initialize();
  CachedNetworkImage.logLevel = CacheManagerLogLevel.debug;

  await FlutterDownloader.initialize(
    debug: true,
    ignoreSsl: true,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.changeLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  void changeLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KL The Guide',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A1A2E),
          primary: const Color(0xFF1A1A2E),
          secondary: const Color(0xFF0F3460),
          surface: Colors.white,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        useMaterial3: true,
        fontFamily: 'System',
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: false,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.0,
            color: Colors.white,
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          elevation: 8,
          height: 70,
          indicatorColor: const Color(0xFF1A1A2E).withOpacity(0.1),
          indicatorShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
                letterSpacing: 0.5,
              );
            }
            return const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xFF9CA3AF),
              letterSpacing: 0.3,
            );
          }),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 6,
        ),
      ),
      locale: _locale,
      supportedLocales: S.delegate.supportedLocales,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const MyHomePage(title: 'Home'),
      routes: {
        '/highlights-0': (context) => AboutKV(),
        '/highlights-1': (context) => GetAround(),
        '/highlights-2': (context) => const TravelTips(),
        '/rmd-0': (context) => ExploreKL(),
        '/explorekl-0': (context) => const ExploreKL_Beauty(),
        '/explorekl-1': (context) => const ExploreKL_HS2(),
        '/explorekl-2': (context) => const ExploreKL_PWOR2(),
        '/explorekl-3': (context) => const ExploreKL_WTE2(),
        '/explorekl-4': (context) => const ExploreKL_NL2(),
        '/explorekl-5': (context) => const ExploreKL_KL4K2(),
        '/explorekl-6': (context) => const ExploreKL_SS2(),
        '/explorekl-7': (context) => const ExploreKL_P2(),
        '/rmd-1': (context) => const Shop(),
        '/rmd-2': (context) => const Stay(),
        '/rmd-3': (context) => const Spa(),
        '/rmd-4': (context) => const MedicalT(),
        '/ebook': (context) => Ebook(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  int currentPageIndex = 0;
  DateTime? currentBackPressTime;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      currentBackPressTime = null;
    }
  }

  void _selectLanguage(String language) {
    final localeMap = {
      'ms': const Locale('ms', 'MY'),
      'zh': const Locale('zh', 'CN'),
      'ta': const Locale('ta', 'IN'),
      'hi': const Locale('hi', 'IN'),
      'th': const Locale('th', 'TH'),
      'fil': const Locale('fil', 'FIL'),
      'id': const Locale('id', 'ID'),
      'es': const Locale('es', 'ES'),
      'pt': const Locale('pt', 'BR'),
      'fr': const Locale('fr', 'FR'),
      'ru': const Locale('ru', 'RU'),
      'en': const Locale('en', 'US'),
    };

    final languageNames = {
      'ms': 'Bahasa Malaysia',
      'zh': '中文',
      'ta': 'தமிழ்',
      'hi': 'हिंदी',
      'th': 'ไทย',
      'es': 'Español',
      'fil': 'Filipino',
      'id': 'Bahasa Indonesia',
      'pt': 'Português',
      'fr': 'Français',
      'ru': 'Русский',
      'en': 'English',
    };

    MyApp.setLocale(context, localeMap[language] ?? const Locale('en', 'US'));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Text(
              languageNames[language] ?? 'English',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1A1A2E),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );

    Navigator.pop(context);
  }

  Future<bool> _onWillPop() async {
    final now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.exit_to_app, color: Colors.white, size: 20),
              SizedBox(width: 12),
              Text(
                'Press back again to exit',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF1A1A2E),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        extendBodyBehindAppBar: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1A1A2E),
                    Color(0xFF0F3460),
                    Color(0xFF1A1A2E),
                  ],
                ),
              ),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.location_city_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text("KLANG VALLEY"),
              ],
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            actions: const <Widget>[
              AppBarMore(),
              SizedBox(width: 8),
            ],
          ),
        ),
        drawer: _buildDrawer(),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: NavigationBar(
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index;
              });
              _animationController.reset();
              _animationController.forward();
            },
            selectedIndex: currentPageIndex,
            destinations: <Widget>[
              NavigationDestination(
                selectedIcon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A2E).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.location_city_rounded,
                    color: Color(0xFF1A1A2E),
                    size: 24,
                  ),
                ),
                icon: const Icon(
                  Icons.location_city_outlined,
                  size: 24,
                ),
                label: S.of(context).home,
              ),
              NavigationDestination(
                selectedIcon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A2E).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.auto_stories_rounded,
                    color: Color(0xFF1A1A2E),
                    size: 24,
                  ),
                ),
                icon: const Icon(
                  Icons.auto_stories_outlined,
                  size: 24,
                ),
                label: S.of(context).ebook,
              ),
            ],
          ),
        ),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: [
            HomeScreen(),
            const BlogListScreen(),
            Ebook(),
          ][currentPageIndex],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    final languages = [
      {'code': 'en', 'name': 'English', 'icon': '🇬🇧'},
      {'code': 'ms', 'name': 'Bahasa Malaysia', 'icon': '🇲🇾'},
      {'code': 'zh', 'name': 'Mandarin', 'icon': '🇨🇳'},
      {'code': 'ta', 'name': 'Tamil', 'icon': '🇮🇳'},
      {'code': 'hi', 'name': 'Hindi', 'icon': '🇮🇳'},
      {'code': 'th', 'name': 'Thai', 'icon': '🇹🇭'},
      {'code': 'fil', 'name': 'Tagalog', 'icon': '🇵🇭'},
      {'code': 'id', 'name': 'Bahasa Indonesia', 'icon': '🇮🇩'},
      {'code': 'es', 'name': 'Spanish', 'icon': '🇪🇸'},
      {'code': 'pt', 'name': 'Portuguese', 'icon': '🇵🇹'},
      {'code': 'fr', 'name': 'French', 'icon': '🇫🇷'},
      {'code': 'ru', 'name': 'Russian', 'icon': '🇷🇺'},
    ];

    return Drawer(
      child: Container(
        color: const Color(0xFFF8F9FA),
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1A1A2E),
                    Color(0xFF0F3460),
                    Color(0xFF16213E),
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.translate_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        S.of(context).pickALanguage,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Select your preferred language',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 12),
                itemCount: languages.length,
                itemBuilder: (context, index) {
                  final lang = languages[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      leading: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A2E).withOpacity(0.05),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          lang['icon']!,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                      title: Text(
                        lang['name']!,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFF9CA3AF),
                        size: 20,
                      ),
                      onTap: () => _selectLanguage(lang['code']!),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppBarMore extends StatelessWidget {
  const AppBarMore({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert_rounded),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 8,
      offset: const Offset(0, 50),
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: S.of(context).aboutUs,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A2E).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.info_outline_rounded,
                    size: 18,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(width: 14),
                Text(
                  S.of(context).aboutUs,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const PopupMenuDivider(height: 1),
          PopupMenuItem<String>(
            value: S.of(context).contactUs,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A2E).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.mail_outline_rounded,
                    size: 18,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(width: 14),
                Text(
                  S.of(context).contactUs,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ];
      },
      onSelected: (value) {
        if (value == S.of(context).contactUs) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ContactUsPage()),
          );
        } else if (value == S.of(context).aboutUs) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AboutUsPage()),
          );
        }
      },
    );
  }
}

class MyFlutterApp {
  MyFlutterApp._();

  static const _kFontFam = 'MyFlutterApp';
  static const String? _kFontPkg = null;

  static const IconData instagram_1 =
      IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);

  static const IconData whatsapp =
      IconData(0xf232, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}

void _launchURL(url) async {
  var url2 = Uri.parse(url);
  if (await canLaunchUrl(url2)) {
    await launchUrl(url2, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $url';
  }
}

class ImageData {
  final String imageUrl;
  final String actionUrl;

  ImageData({
    required this.imageUrl,
    required this.actionUrl,
  });
}
