import 'dart:convert';

class ExpenseCategory {
  final String name;
  final List<String> categories;
  final List<int> records;

  ExpenseCategory({
    required this.name,
    required this.categories,
    required this.records,
  });

  // Method to calculate the total expense
  int get total => records.reduce((a, b) => a + b);

  // Method to get category data with percentages
  List<CategoryData> get categoriesWithPercentages {
    return categories.asMap().entries.map((entry) {
      final index = entry.key;
      final category = entry.value;
      final amount = records[index];
      final percentage = total > 0 ? (amount / total * 100).toStringAsFixed(1) : '0.0';
      return CategoryData(
        category: category,
        amount: amount,
        percentage: percentage,
      );
    }).toList();
  }

  // Convert JSON to ExpenseCategory
  factory ExpenseCategory.fromJson(Map<String, dynamic> json) {
    return ExpenseCategory(
      name: json['name'] as String,
      categories: List<String>.from(json['data'] as List),
      records: List<int>.from(json['records'] as List),
    );
  }

  // Convert ExpenseCategory to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'data': categories,
      'records': records,
    };
  }
}

class CategoryData {
  final String category;
  final int amount;
  final String percentage;

  CategoryData({
    required this.category,
    required this.amount,
    required this.percentage,
  });

  // Convert JSON to CategoryData
  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      category: json['category'] as String,
      amount: json['amount'] as int,
      percentage: json['percentage'] as String,
    );
  }

  // Convert CategoryData to JSON
  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'amount': amount,
      'percentage': percentage,
    };
  }
}
