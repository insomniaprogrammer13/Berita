import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/news_model.dart';
import '../service/news_service.dart';
import '../widgets/news_card.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late Future<List<NewsModel>> _favorites;

  @override
  void initState() {
    super.initState();
    _favorites = _loadFavoriteNews();
  }

  Future<List<NewsModel>> _loadFavoriteNews() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> favoriteUrls = prefs.getStringList('favorites') ?? [];

    final allNews = await NewsService().fetchNews(); // Default news (all category)
    return allNews.where((news) => favoriteUrls.contains(news.link)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorit")),
      body: FutureBuilder<List<NewsModel>>(
        future: _favorites,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
          }

          final favoriteNews = snapshot.data;

          if (favoriteNews == null || favoriteNews.isEmpty) {
            return const Center(child: Text("Belum ada berita favorit"));
          }

          return ListView.builder(
            itemCount: favoriteNews.length,
            itemBuilder: (context, index) {
              return NewsCard(news: favoriteNews[index]);
            },
          );
        },
      ),
    );
  }
}
