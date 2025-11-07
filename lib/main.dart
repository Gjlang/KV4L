// ignore_for_file: constant_identifier_names
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
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
import 'package:klangvalley4locals/shop.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'ebook_page.dart';
import 'package:in_app_update/in_app_update.dart';
import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  CachedNetworkImage.logLevel = CacheManagerLogLevel.debug;
  // Check the app version and build number

  await FlutterDownloader.initialize(
      debug:
      true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
      true // option: set to false to disable working with http links (default: false)
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // Add setLocale method to update locale dynamically
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.changeLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  // Method to change the locale
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
            seedColor: const Color.fromARGB(255, 0, 71, 133)),
        useMaterial3: true,
      ),
      // Add locale to MaterialApp
      locale: _locale,
      // Add supported locales
      supportedLocales: S.delegate.supportedLocales,
      // Add localization delegates
      localizationsDelegates: const [
        S.delegate, // Localization delegate for the app
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
      }
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  int currentPageIndex = 0;

  void _selectLanguage(String language) {
    setState(() {
      Locale newLocale;
      Map<String, Locale> localeMap = {
        'ms': Locale('ms', 'MY'), // Malay
        'zh': Locale('zh', 'CN'), // Mandarin
        'ta': Locale('ta', 'IN'), // Tamil
        'hi': Locale('hi', 'IN'), // Hindi
        'th': Locale('th', 'TH'), // Thai
        'fil': Locale('fil', 'FIL'), // Filipino
        'id': Locale('id', 'ID'), // Indonesian
        'es': Locale('es', 'ES'), // Spanish
        'pt': Locale('pt', 'BR'), // Portuguese
        'fr': Locale('fr', 'FR'), // French
        'ru': Locale('ru', 'RU'), // Russian
        'en': Locale('en', 'US'), // Default to English
      };
      newLocale = localeMap[language] ?? Locale('en', 'US');
      MyApp.setLocale(context, newLocale);
    });

    // Show a snackbar to confirm language change
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text({
          'ms': 'Bahasa Malaysia',
          'zh': '中文',
          'ta': 'தமிழ்',
          'hi': 'हिंदी',
          'th': 'ไทย.',
          'es': 'Español',
          'fil': 'Filipino',
          'id': 'Bahasa Indonesia',
          'pt': 'Português',
          'fr': 'français',
          'ru': 'русский',
          'en': 'English',
        }[language]!),
      ),
    );

    Navigator.pop(context); // Close the drawer after selecting a language
  }

  final String desiredVersion = '1.5.0'; // Replace with your desired version

  late BannerAd _bannerAd;
  DateTime? currentBackPressTime;

  bool isDialogShown = false; // Add a flag to track if the dialog is shown

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // // Create a BannerAd instance
    // _bannerAd = BannerAd(
    //   adUnitId: 'ca-app-pub-7002644831588730/4427349537',
    //   size: AdSize.mediumRectangle,
    //   request: const AdRequest(),
    //   listener: const BannerAdListener(),
    // );
    //
    // // Load the ad
    // _bannerAd.load();
    //
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   // Use addPostFrameCallback to ensure the dialog is shown after the first frame
    //
    //   _checkVersionAndShowDialog();
    //   if (!isDialogShown) {
    //     fetchDataFromApi();
    //   }
    // });

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _showVoucherPopup(); // Call the function to show the pop-up on app launch
    // });
  }

  // Function to display the pop-up message with the "View" button
  // void _showVoucherPopup() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('New Vouchers Available!'),
  //         content: const Text('New vouchers have been added. Check them out!'),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(); // Close the dialog
  //             },
  //             child: const Text('Cancel'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(); // Close the dialog first
  //             },
  //             child: const Text('View'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }


  Future<void> _checkVersionAndShowDialog() async {
    // Check for an update using Google's In-App Update API
    try {
      AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        if (updateInfo.immediateUpdateAllowed) {
          // Trigger immediate update
          InAppUpdate.performImmediateUpdate();
        } else if (updateInfo.flexibleUpdateAllowed) {
          // Trigger flexible update
          InAppUpdate.startFlexibleUpdate().then((_) {
            InAppUpdate.completeFlexibleUpdate();
          });
        }
      }
    } catch (e) {
      print("Error checking for updates: $e");
    }

    // Custom version check remains (if needed)
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;
    final currentBuildNumber = packageInfo.buildNumber;

    final desiredVersionAndBuild = await _fetchDesiredVersionAndBuild();
    final String desiredVersion = desiredVersionAndBuild['version']!;
    final String desiredBuildNumber = desiredVersionAndBuild['buildNumber']!;


  }

  Future<Map<String, String>> _fetchDesiredVersionAndBuild() async {
    final response = await http.post(
      Uri.parse(
          'https://www.kltheguide.com.my/admin/functions.php'), // Replace with your API endpoint
      body: {'appAdsSettings': 'appAdsSettings'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print(jsonData);

      return {
        'version': jsonData['desiredVersion'],
        'buildNumber': jsonData['desiredBuildNumber'],
      };
    } else {
      throw Exception('Failed to fetch desired version and build number');
    }
  }

  bool _isUpdateRequired(String currentVersion, String desiredVersion,
      String currentBuildNumber, String desiredBuildNumber) {
    List<int> currentVersionParts =
    currentVersion.split('.').map(int.parse).toList();
    List<int> desiredVersionParts =
    desiredVersion.split('.').map(int.parse).toList();

    for (int i = 0; i < currentVersionParts.length; i++) {
      if (currentVersionParts[i] < desiredVersionParts[i]) {
        return true;
      } else if (currentVersionParts[i] > desiredVersionParts[i]) {
        return false;
      }
    }

    // If versions are equal, check build numbers
    return int.parse(currentBuildNumber) < int.parse(desiredBuildNumber);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      currentBackPressTime = null; // Reset the back button press time
    }
  }



  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Welcome'),
          content: Text('This is an example AlertDialog on app launch.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _onWillPop() async {
    final now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Press back again to exit'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }
    return true;
  }

  // Future<List<ImageData>> fetchImageUrls() async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('https://www.kltheguide.com.my/admin/functions.php'),
  //       body: {'appAdsURL': 'appAdsURL'},
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final List<dynamic> jsonData = json.decode(response.body);
  //       final List<ImageData> imageUrls = jsonData.map((item) {
  //         return ImageData(
  //           imageUrl: item['imageURL'] as String,
  //           actionUrl: item['URL'] as String,
  //         );
  //       }).toList();
  //
  //       return imageUrls;
  //     } else {
  //       throw Exception('Failed to load image URLs from the API');
  //     }
  //   } catch (e) {
  //     print('Error fetching image URLs: $e');
  //     return []; // Return an empty list in case of an error
  //   }
  // }

  // Future<void> fetchDataFromApi() async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('https://www.kltheguide.com.my/admin/functions.php'),
  //       body: {'appAdsSettings': 'appAdsSettings'},
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final jsonData = json.decode(response.body);
  //       var admobrandomswitch = jsonData['admobrandomswitch'];
  //       print(isDialogShown);
  //       int? switch2 = int.parse(admobrandomswitch);
  //
  //       // Set a fixed delay of 30 seconds
  //       int delayInSeconds = 30;
  //
  //       final Random random = Random();
  //
  //       if (switch2 == 1) {
  //         if (random.nextInt(5) == 1) {
  //           // Show the AdMob ad
  //           if (isDialogShown) {
  //             _showWelcomeDialog(delayInSeconds);
  //           } else {
  //             _showWelcomeDialog(0);
  //             isDialogShown = true;
  //           }
  //         } else {
  //           // Show custom ads with a fixed delay of 7 seconds
  //           final List<ImageData> imageDatas = await fetchImageUrls();
  //           if (imageDatas.isNotEmpty) {
  //             final randomImageData =
  //             imageDatas[random.nextInt(imageDatas.length)];
  //             if (isDialogShown) {
  //               _showRandomPopup(delayInSeconds, randomImageData);
  //             } else {
  //               _showRandomPopup(0, randomImageData);
  //               isDialogShown = true;
  //             }
  //           }
  //         }
  //       } else {
  //         // Handle cases when 'switch2' is not 1
  //         final List<ImageData> imageDatas = await fetchImageUrls();
  //         if (imageDatas.isNotEmpty) {
  //           final randomImageData =
  //           imageDatas[random.nextInt(imageDatas.length)];
  //           if (isDialogShown) {
  //             _showRandomPopup(delayInSeconds, randomImageData);
  //           } else {
  //             _showRandomPopup(0, randomImageData);
  //             isDialogShown = true;
  //           }
  //         }
  //       }
  //     } else {
  //       throw Exception('Failed to load data from the API');
  //     }
  //   } catch (e) {
  //     print('Error fetching data from API: $e');
  //   }
  // }
  //
  // void _showRandomPopup(int delayInSeconds, ImageData imageData) async {
  //   Future.delayed(Duration(seconds: delayInSeconds), () async {
  //     if (imageData != 'null') {
  //       final randomImageUrl = imageData.imageUrl;
  //
  //       showDialog(
  //         barrierDismissible: false,
  //         context: context,
  //         builder: (BuildContext context) {
  //           return FutureBuilder<void>(
  //             future: Future.delayed(Duration(seconds: 0), () {}),
  //             builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
  //               if (snapshot.connectionState == ConnectionState.waiting) {
  //                 // While waiting for the delay, show a loading indicator
  //                 return Center(child: CircularProgressIndicator());
  //               } else {
  //                 // After the delay, display the image and actions
  //                 return WillPopScope(
  //                   onWillPop: () async {
  //                     return false;
  //                   },
  //                   child: AlertDialog(
  //                     shadowColor: Colors.transparent,
  //                     buttonPadding: EdgeInsets.zero,
  //                     contentPadding: EdgeInsets.zero,
  //                     actionsPadding: EdgeInsets.zero,
  //                     insetPadding: EdgeInsets.zero,
  //                     actionsAlignment: MainAxisAlignment.center,
  //                     // title: Text('Random Popup'),
  //                     backgroundColor: Colors.transparent,
  //                     content: GestureDetector(
  //                       child: Image.network(randomImageUrl),
  //                       onTap: () {
  //                         if (imageData.actionUrl.isNotEmpty) {
  //                           print(Uri.decodeFull(imageData.actionUrl));
  //                           _launchURL(Uri.decodeFull(imageData.actionUrl));
  //                         }
  //                       },
  //                     ),
  //                     actions: <Widget>[
  //                       TextButton(
  //                         onPressed: () {
  //                           Navigator.of(context).pop(); // Close the dialog
  //                           fetchDataFromApi();
  //                         },
  //                         child: Icon(
  //                           Icons.cancel_outlined,
  //                           size: 32,
  //                           color: Colors.white,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 );
  //               }
  //             },
  //           );
  //         },
  //       );
  //     }
  //   });
  // }

  // void _showWelcomeDialog(int delaySec) {
  //   // Add a delay of 3 seconds before showing the dialog
  //   Future.delayed(Duration(seconds: delaySec), () {
  //     showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (BuildContext context) {
  //         return WillPopScope(
  //           onWillPop: () async {
  //             return false;
  //           },
  //           child: AlertDialog(
  //             buttonPadding: EdgeInsets.zero,
  //             contentPadding: EdgeInsets.zero,
  //             actionsPadding: EdgeInsets.zero,
  //             insetPadding: EdgeInsets.zero,
  //             actionsAlignment: MainAxisAlignment.center,
  //             // title: Text('Random Popup'),
  //             backgroundColor: Colors.transparent,
  //             content: SizedBox(
  //               height: 250,
  //               width: 300,
  //               child: AdWidget(
  //                 ad: _bannerAd,
  //               ),
  //             ),
  //             actions: [
  //               TextButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop(); // Close the dialog
  //                   fetchDataFromApi();
  //                 },
  //                 child: Icon(
  //                   Icons.cancel_outlined,
  //                   size: 32,
  //                   color: Colors.white,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         );
  //       },
  //     );
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title:
          const Text("KLANG VALLEY FOR LOCALS", style: TextStyle(color: Colors.white)),
          backgroundColor: const Color.fromARGB(255, 0, 71, 133),
          iconTheme: const IconThemeData(color: Colors.white),
          actions: const <Widget>[
            AppBarMore(),
          ],
        ),
        // Move the drawer here inside the Scaffold
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 0, 71, 133),
                ),
                child: Text(
                  S.of(context).pickALanguage,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                title: const Text('Bahasa Malaysia'),
                onTap: () => _selectLanguage('ms'),
              ),
              ListTile(
                title: const Text('English'),
                onTap: () => _selectLanguage('en'),
              ),
              ListTile(
                title: const Text('Mandarin'),
                onTap: () => _selectLanguage('zh'),
              ),
              ListTile(
                title: const Text('Tamil'),
                onTap: () => _selectLanguage('ta'),
              ),
              ListTile(
                title: const Text('Hindi'),
                onTap: () => _selectLanguage('hi'),
              ),
              ListTile(
                title: const Text('Thai'),
                onTap: () => _selectLanguage('th'),
              ),
              ListTile(
                title: const Text('Tagalog'),
                onTap: () => _selectLanguage('fil'),
              ),
              ListTile(
                title: const Text('Bahasa Indonesia'),
                onTap: () => _selectLanguage('id'),
              ),
              ListTile(
                title: const Text('Spanish'),
                onTap: () => _selectLanguage('es'),
              ),
              ListTile(
                title: const Text('Portuguese'),
                onTap: () => _selectLanguage('pt'),
              ),
              ListTile(
                title: const Text('French'),
                onTap: () => _selectLanguage('fr'),
              ),
              ListTile(
                title: const Text('Russian'),
                onTap: () => _selectLanguage('ru'),
              ),
            ],
          ),
        ),
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          selectedIndex: currentPageIndex,
          destinations: <Widget>[
            NavigationDestination(
                selectedIcon:
                Icon(Icons.home, color: Color.fromARGB(255, 0, 71, 133)),
                icon: Icon(Icons.home_outlined),
                label: S.of(context).home),
            NavigationDestination(
                selectedIcon: Icon(Icons.menu_book,
                    color: Color.fromARGB(255, 0, 71, 133)),
                icon: Icon(Icons.menu_book_outlined),
                label: S.of(context).ebook),
          ],
        ),
        body: [
          HomeScreen(),
          const BlogListScreen(),
          Ebook(),
          // EventScreen(),
        ][currentPageIndex],
      ),
    );
  }
}

class AppBarMore extends StatelessWidget {
  const AppBarMore({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      color: Colors.white,
      onSelected: (value) {
        // Handle the item selection here.
        if (value == S.of(context).contactUs) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ContactUsPage(),
          ));
        } else if (value == S.of(context).aboutUs) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AboutUsPage(),
          ));
        }
        // Add more options for additional pages as needed.
      },
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: S.of(context).aboutUs,
            child: Text(S.of(context).aboutUs),
          ),
          PopupMenuItem<String>(
            value: S.of(context).contactUs,
            child: Text(S.of(context).contactUs),
          ),
          // Add more PopupMenuItem entries for additional pages.
        ];
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
