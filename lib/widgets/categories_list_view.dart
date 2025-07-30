import 'package:flutter/material.dart';
import 'package:news_app/models/category_models.dart';
import 'package:news_app/views/home/categries_viwes.dart';

class CategoriesListView extends StatelessWidget {
  const CategoriesListView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CategoryModel> categories = [
      CategoryModel(categoryName: 'business', image: 'assets/business.jpg'),
      CategoryModel(categoryName: 'entertainment', image: 'assets/entertainment.jpg'),
      CategoryModel(categoryName: 'general', image: 'assets/general.avif'),
      CategoryModel(categoryName: 'health', image: 'assets/health.jpg'),
      CategoryModel(categoryName: 'science', image: 'assets/science.avif'),
      CategoryModel(categoryName: 'sports', image: 'assets/sports.jpg'),
      CategoryModel(categoryName: 'technology', image: 'assets/technology.jpg'),
    ];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = categories[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CategoryViwes(category: category.categoryName),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                category.categoryName[0].toUpperCase() + category.categoryName.substring(1),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
