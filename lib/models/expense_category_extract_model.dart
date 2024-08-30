import 'package:isuna/models/expense_category_and%20_sub_category_model.dart';

class Category {
  final String category;
  final List<SubCategory> subCategories;

  Category({required this.category, required this.subCategories});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      category: json['category'],
      subCategories: (json['sub_categories'] as List)
          .map((subCat) => SubCategory.fromJson(subCat))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'sub_categories': subCategories.map((subCat) => subCat.toJson()).toList(),
    };
  }
}

class SubCategory {
  final String subCategory;
  double amount;

  SubCategory({required this.subCategory, required this.amount});

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      subCategory: json['sub-category'],
      amount: double.parse(json['amount']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sub-category': subCategory,
      'amount': amount.toStringAsFixed(2),
    };
  }
}

// lib/services/data_transformer.dart
class DataTransformer {
  static List<Map<String, dynamic>> transformData(List<Datum> inputData) {
    Map<String, Category> categories = {};

    for (var item in inputData) {
      String categoryName = item.category ?? '';
      String subCategoryName = item.subcategory ?? '';
      double amount = double.parse(item.amount!);

      if (!categories.containsKey(categoryName)) {
        categories[categoryName] = Category(
          category: categoryName,
          subCategories: [],
        );
      }

      var existingSubCategory = categories[categoryName]!
          .subCategories
          .firstWhere((subCat) => subCat.subCategory == subCategoryName,
              orElse: () =>
                  SubCategory(subCategory: subCategoryName, amount: 0));

      if (existingSubCategory.amount == 0) {
        categories[categoryName]!.subCategories.add(existingSubCategory);
      }

      existingSubCategory.amount += amount;
    }

    return categories.values.map((category) => category.toJson()).toList();
  }
}
