import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jan/news/article.dart';
import 'package:jan/news/consts.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePages extends StatefulWidget {
  const HomePages({Key? key}) : super(key: key);

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  final Dio dio = Dio();

  List<Article> articles = [];

  @override
  void initState() {
    super.initState();
    _getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "News",
          style: TextStyle(color: Colors.white), // Set text color
        ),
        backgroundColor: const Color(0xFF390da0), // Set app bar color
      ),
      body: _buildUI(),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF390da0), // Set bottom nav bar color
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              color: Colors.white, // Set icon color
              onPressed: () {
                // Navigate to Home
              },
            ),
            IconButton(
              icon: const Icon(Icons.location_on),
              color: Colors.white, // Set icon color
              onPressed: () {
                // Navigate to Geotag
              },
            ),
            IconButton(
              icon: const Icon(Icons.new_releases),
              color: Colors.white, // Set icon color
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePages()));
              },
            ),
            IconButton(
              icon: const Icon(Icons.report),
              color: Colors.white, // Set icon color
              onPressed: () {
                // Navigate to Grievance Redressal
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUI() {
    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        return ListTile(
          onTap: () {
            _launchUrl(
              Uri.parse(article.url ?? ""),
            );
          },
          leading: Image.network(
            article.urlToImage ?? PLACEHOLDER_IMAGE_LINK,
            height: 250,
            width: 100,
            fit: BoxFit.cover,
          ),
          title: Text(
            article.title ?? "",
            style: const TextStyle(color: Color(0xFF390da0)), // Set title text color
          ),
          subtitle: Text(
            article.publishedAt ?? "",
            style: const TextStyle(color: Color(0xFF390da0)), // Set subtitle text color
          ),
        );
      },
    );
  }

  Future<void> _getNews() async {
    final response = await dio.get(
      'https://newsapi.org/v2/top-headlines?country=in&category=business&apiKey=$NEWS_API_KEY',
    );
    final articlesJson = response.data["articles"] as List;
    setState(() {
      List<Article> newsArticle =
      articlesJson.map((a) => Article.fromJson(a)).toList();
      newsArticle = newsArticle.where((a) => a.title != "[Removed]").toList();
      articles = newsArticle;
    });
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launch(url.toString())) {
      throw Exception('Could not launch $url');
    }
  }
}
