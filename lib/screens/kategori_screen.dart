import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/news_service.dart';
import '../models/news_model.dart';
import '../widgets/news_card.dart';

class KategoriScreen extends StatefulWidget {
  const KategoriScreen({super.key});

  @override
  State<KategoriScreen> createState() => _KategoriScreenState();
}

class _KategoriScreenState extends State<KategoriScreen> {
  String selectedCategory = 'technology';
  late Future<List<NewsModel>> _news;
  Set<String> favoriteUrls = {};

  final List<String> categories = [
    'business', 'technology', 'sports', 'health', 'science', 'entertainment'
  ];

  @override
  void initState() {
    super.initState();
    _news = NewsService().fetchNews(category: selectedCategory);
    _loadFavorites();
  }

  void _onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
      _news = NewsService().fetchNews(category: selectedCategory);
    });
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteUrls = prefs.getStringList('favorites')?.toSet() ?? {};
    });
  }

  Future<void> _toggleFavorite(String url) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (favoriteUrls.contains(url)) {
        favoriteUrls.remove(url);
      } else {
        favoriteUrls.add(url);
      }
      prefs.setStringList('favorites', favoriteUrls.toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Kategori: ${selectedCategory.toUpperCase()}")),
      body: Column(
        children: [
          SizedBox(
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (_, i) {
                final category = categories[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    onPressed: () => _onCategorySelected(category),
                    child: Text(category.toUpperCase()),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<NewsModel>>(
              future: _news,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                    children: snapshot.data!.map((news) {
                      final isFavorited = favoriteUrls.contains(news.link);
                      return Column(
                        children: [
                          NewsCard(news: news),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                onPressed: () => _toggleFavorite(news.link),
                                icon: Icon(
                                  isFavorited ? Icons.favorite : Icons.favorite_border,
                                  color: isFavorited ? Colors.red : Colors.grey,
                                ),
                                label: Text(isFavorited ? 'Favorit' : 'Tambah ke Favorit'),
                              ),
                            ),
                          ),
                          const Divider(),
                        ],
                      );
                    }).toList(),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}
