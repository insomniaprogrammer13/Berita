class NewsModel {
  final String title;
  final String description;
  final String link;
  final String imageUrl;

  NewsModel({
    required this.title,
    required this.description,
    required this.link,
    required this.imageUrl,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      link: json['link'] ?? '',
      imageUrl: json['image_url'] ?? '', // sesuaikan dengan struktur JSON API
    );
  }
}
