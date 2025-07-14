import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

class NewsService {
  static const String _baseUrl = 'https://newsdata.io/api/1/latest';
  static const String _apiKey = 'pub_c67f33ce8d334b6e8c6840ae1bfe554e';

  /// Ambil berita berdasarkan kategori
  /// Contoh: business, technology, sports, entertainment, health, science
  Future<List<NewsModel>> fetchNews({String category = 'technology'}) async {
    final url = Uri.parse('$_baseUrl?apikey=$_apiKey&category=$category');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      if (jsonData['results'] == null) {
        throw Exception('Data kosong dari API.');
      }

      final List<dynamic> results = jsonData['results'];

      return results
          .map((json) => NewsModel.fromJson(json))
          .where((item) => item.link.isNotEmpty)
          .toList();
    } else {
      throw Exception('Gagal memuat berita (${response.statusCode})');
    }
  }
}
