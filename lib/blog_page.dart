import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:klangvalley4locals/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class BlogListScreen extends StatefulWidget {
  const BlogListScreen({super.key});

  @override
  State<BlogListScreen> createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {
  List<dynamic> blogPosts = [];
  String? nextPageToken;
  int maxResults = 10;
  bool isLoading = false;
  late SharedPreferences prefs;

  DefaultCacheManager cacheManager = DefaultCacheManager();

  @override
  void initState() {
    super.initState();
    _fetchInitialBlogPosts();
    initPrefs();
  }

  @override
  void dispose() {
    cacheManager.dispose(); // Dispose the cache manager when no longer needed.
    super.dispose();
  }

  String formatDate(String rawDate) {
    final parsedDate = DateTime.parse(rawDate);
    final formattedDate = DateFormat('d MMMM y').format(parsedDate);
    return formattedDate;
  }

  Future<void> _fetchInitialBlogPosts() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    const apiKey =
        'AIzaSyASiRcIRFUAMCXCGK-DRFKkwo6NLGNdNqc'; // Replace with your Blogger API key
    const blogId = '1732826187557117921'; // Replace with your Blogger blog ID
    final apiUrl = 'https://www.googleapis.com/blogger/v3/blogs/$blogId/posts?'
        'key=$apiKey'
        '&maxResults=$maxResults'
        '&fetchImages=true';

    final response = await cacheManager.getSingleFile(apiUrl);

    final String jsonData = await response.readAsString();
    final Map<String, dynamic> data = json.decode(jsonData);
    setState(() {
      blogPosts = data['items'];
      nextPageToken = data['nextPageToken'];
      isLoading = false;
    });
  }

  Future<void> _fetchMoreBlogPosts() async {
    if (isLoading || nextPageToken == null) return;

    setState(() {
      isLoading = true;
    });

    const apiKey =
        'AIzaSyC7NA9vDhkVtk4lWisJxGW--fYXLIeM__w'; // Replace with your Blogger API key
    const blogId = '1732826187557117921'; // Replace with your Blogger blog ID
    final apiUrl = 'https://www.googleapis.com/blogger/v3/blogs/$blogId/posts?'
        'key=$apiKey'
        '&maxResults=$maxResults'
        '&pageToken=$nextPageToken'
        '&fetchImages=true';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        blogPosts.addAll(data['items']);
        nextPageToken = data['nextPageToken'];
        isLoading = false;
      });
    }
  }

  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  bool isBookmarked(dynamic post) {
    final postId = post['id'].toString();
    return prefs.getBool(postId) ?? false;
  }

  void toggleBookmark(dynamic post) {
    final postId = post['id'].toString();
    final isBookmarked = prefs.getBool(postId) ?? false;
    Vibration.vibrate(duration: 100);
    setState(() {
      // Update the UI immediately
      if (isBookmarked) {
        removeBookmark(post);
        prefs.setBool(postId, false);
        showSnackBar(context, 'Bookmark removed');
      } else {
        addBookmark(post);
        prefs.setBool(postId, true);
        showSnackBar(context, 'Bookmark added');
      }
    });
  }

  void addBookmark(dynamic post) async {
    List<String>? bookmarkStrings = prefs.getStringList('bookmarks') ?? [];

    String bookmarkJson = json.encode(post);
    bookmarkStrings.add(bookmarkJson);
    await prefs.setStringList('bookmarks', bookmarkStrings);
  }

  void removeBookmark(dynamic post) async {
    List<String>? bookmarkStrings = prefs.getStringList('bookmarks') ?? [];
    String bookmarkJson = json.encode(post);

    // Check if the bookmarkJson exists in the list and remove it
    if (bookmarkStrings.contains(bookmarkJson)) {
      bookmarkStrings.remove(bookmarkJson);
      await prefs.setStringList('bookmarks', bookmarkStrings);
    }
  }

  void _navigateToArticlePage(dynamic article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticlePage(article: article),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: blogPosts.length + 1, // Add one for loading indicator
        itemBuilder: (context, index) {
          if (index == blogPosts.length) {
            if (isLoading) {
              return const SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.0),
                    ),
                    Center(child: CircularProgressIndicator()),
                  ],
                ),
              );
            } else {
              return ListTile(
                title: const Icon(
                  Icons.expand_circle_down,
                  size: 64,
                ),
                onTap: _fetchMoreBlogPosts,
              );
            }
          }

          final post = blogPosts[index];
          final imageUrl = post['images'][0]['url'];
          final formattedPublishedDate = formatDate(post['published']);

          return GestureDetector(
            onTap: () => _navigateToArticlePage(post),
            onLongPress: () => {
              toggleBookmark(post),
            },
            child: Card(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    height: 200,
                    placeholder: (context, url) => Container(
                      height: 200,
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  ListTile(
                    title: Text(post['title']),
                    subtitle: Text(formattedPublishedDate),
                    trailing: isBookmarked(post)
                        ? const Icon(Icons.bookmark, color: Colors.blue)
                        : const Icon(Icons.bookmark_border),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ArticlePage extends StatefulWidget {
  final dynamic article;

  const ArticlePage({super.key, required this.article});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  double deviceWidth = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Calculate the device width once the widget has been built
      setState(() {
        deviceWidth = MediaQuery.of(context).size.width;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String plainText = widget.article['content'];

    // print(plainText);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        title:
            const Text("Blog Details", style: TextStyle(color: Colors.white)),
        // foregroundColor: const Color.fromARGB(255, 0, 71, 133),
        backgroundColor: const Color.fromARGB(255, 0, 71, 133),
        actions: const <Widget>[
          AppBarMore(),
        ],
      ),
      body: InAppWebView(
        onWebViewCreated: (controller) {},
        onLoadStop: (controller, url) async {
          // Get the initial HTML content and print it
        },
        initialData: InAppWebViewInitialData(
          data: '''
      <!DOCTYPE html>
      <html>
        <head>
                <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
      
          <style>
            /* CSS styles for images */
            img {
              width: 100%;
              height: auto;
            }
            body {
               word-wrap: break-word;
            }
          </style>
        </head>
        <body>
          <!-- Inject your Blogger API content here -->
                  $plainText
      
        </body>
      </html>
        ''',
          mimeType: 'text/html',
        ),
      ),
    );
  }
}
