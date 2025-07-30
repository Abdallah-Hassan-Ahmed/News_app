import 'package:flutter/material.dart';
import 'package:news_app/models/category_models.dart';
import 'package:news_app/views/home/categries_viwes.dart';

class CategoriesListView extends StatefulWidget {
  const CategoriesListView({super.key});

  @override
  State<CategoriesListView> createState() => _CategoriesListViewState();
}

class _CategoriesListViewState extends State<CategoriesListView> {
  final List<CategoryModel> categories = [
    CategoryModel(categoryName: 'business', image: 'assets/business.jpg'),
    CategoryModel(categoryName: 'entertainment', image: 'assets/entertainment.jpg'),
    CategoryModel(categoryName: 'general', image: 'assets/general.avif'),
    CategoryModel(categoryName: 'health', image: 'assets/health.jpg'),
    CategoryModel(categoryName: 'science', image: 'assets/science.avif'),
    CategoryModel(categoryName: 'sports', image: 'assets/sports.jpg'),
    CategoryModel(categoryName: 'technology', image: 'assets/technology.jpg'),
  ];

  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: SizedBox(
        height: 45,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemCount: categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final category = categories[index];
            final bool isSelected = selectedIndex == index;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
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
                  color: isSelected ? Colors.deepPurple : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  category.categoryName[0].toUpperCase() + category.categoryName.substring(1),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
