import 'package:flutter/material.dart';
import '../models/news_model.dart';
import '../service/news_service.dart';
import '../widgets/news_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<NewsModel>> _newsFuture;

  @override
  void initState() {
    super.initState();
    // ✅ Hanya panggil sekali saat init
    _newsFuture = NewsService().fetchNews(category: 'technology');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("🔥 Berita Hot"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<NewsModel>>(
        future: _newsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Terjadi kesalahan:\n${snapshot.error}",
                style: const TextStyle(color: Colors.redAccent),
                textAlign: TextAlign.center,
              ),
            );
          } else if (snapshot.hasData) {
            final newsList = snapshot.data!;
            return ListView.builder(
              itemCount: newsList.length,
              itemBuilder: (context, index) => NewsCard(news: newsList[index]),
            );
          } else {
            return const Center(child: Text("Tidak ada berita tersedia"));
          }
        },
      ),
    );
  }
}
