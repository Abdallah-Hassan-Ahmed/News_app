import 'package:flutter/material.dart';

class ArticleModel {
  String id;
  String title;
  String description;
  String content;
  String? imageUrl;
  DateTime publishedAt;
  String source;
  String? author;
  String url;
  String category; // <-- شيل final عشان نقدر نعدله
  bool isBookmarked;

  ArticleModel({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.imageUrl,
    required this.publishedAt,
    required this.source,
    required this.author,
    required this.url,
    required this.category,
    this.isBookmarked = false,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['url'] ?? UniqueKey().toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['urlToImage'],
      publishedAt: DateTime.parse(json['publishedAt'] ?? DateTime.now().toString()),
      source: json['source']['name'] ?? '',
      author: json['author'],
      url: json['url'] ?? '',
      category: '', // هتحط القيمة لاحقًا
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'content': content,
      'imageUrl': imageUrl,
      'publishedAt': publishedAt.toIso8601String(),
      'source': source,
      'author': author,
      'url': url,
      'category': category,
      'isBookmarked': isBookmarked,
    };
  }

  ArticleModel copyWith({
    String? id,
    String? title,
    String? description,
    String? content,
    String? imageUrl,
    DateTime? publishedAt,
    String? source,
    String? author,
    String? url,
    String? category,
    bool? isBookmarked,
  }) {
    return ArticleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      publishedAt: publishedAt ?? this.publishedAt,
      source: source ?? this.source,
      author: author ?? this.author,
      url: url ?? this.url,
      category: category ?? this.category,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  @override
  String toString() {
    return 'ArticleModel(title: $title, source: $source, publishedAt: $publishedAt)';
  }
}
