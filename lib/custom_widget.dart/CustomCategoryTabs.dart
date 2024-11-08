import 'package:flutter/material.dart';
import 'package:magixcart/constant/Colors.dart';

class CustomCategoryTabs extends StatefulWidget {
  final Future<List<String>> categoriesFuture;
  final Function(String) onCategorySelected;

  const CustomCategoryTabs({
    required this.categoriesFuture,
    required this.onCategorySelected,
  });

  @override
  _CustomCategoryTabsState createState() => _CustomCategoryTabsState();
}

class _CustomCategoryTabsState extends State<CustomCategoryTabs> {
  String selectedCategory = '';  

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5.0),
      height: 60,
      child: FutureBuilder<List<String>>(
        future: widget.categoriesFuture, 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No categories available.'));
          } else {
            List<String> categories = snapshot.data!;
            return ListView(
              scrollDirection: Axis.horizontal,
              children: categories.map((category) {
                return _buildCategoryTab(category);
              }).toList(),
            );
          }
        },
      ),
    );
  }
  Widget _buildCategoryTab(String category) {
    bool isSelected = category == selectedCategory;
    String displayText = category.length > 9 ? '${category.substring(0, 11)}...' : category;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
        widget.onCategorySelected(category);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
        child: Container(
          width: 90,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.baseLightCoral : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.baseLightCoral : Colors.blue[100]!,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Text(
            displayText,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.baseLightCoral,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
