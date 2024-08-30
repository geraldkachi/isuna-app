// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:isuna/app/theme/colors.dart';

class CategoryData {
  final String category;
  final List<SubCategoryData> subCategories;
  final double totalAmount;
  Color? color;
  List<Color> subColors;

  CategoryData(this.category, this.subCategories)
      : totalAmount = subCategories.fold(
            0, (sum, item) => sum + double.parse(item.amount)),
        color = grey300,
        subColors = [];

  factory CategoryData.fromMap(Map<String, dynamic> map) {
    return CategoryData(
      map['category'] as String,
      List<SubCategoryData>.from(
          (map['sub_categories'] as List<Map<String, dynamic>>)
              .map<SubCategoryData>(
        (x) => SubCategoryData.fromMap(x),
      )),
      // map['totalAmount'] as double,
    );
  }

  void setColor(Color newColor) {
    color = newColor;
  }

  void setSubColors(List<Color> newSubColors) {
    subColors = newSubColors;
    for (int i = 0; i < subCategories.length; i++) {
      subCategories[i].setColor(subColors[i]);
    }
  }
}

class SubCategoryData {
  final String name;
  final String amount;
  Color color;

  SubCategoryData(this.name, this.amount) : color = Colors.grey;

  factory SubCategoryData.fromMap(Map<String, dynamic> map) {
    return SubCategoryData(
      map['sub-category'] as String,
      map['amount'] as String,
    );
  }

  void setColor(Color newColor) {
    color = newColor;
  }
}

List<Color> generateDistinctColors(int count) {
  List<Color> colors = [];
  final random = Random(42); // Fixed seed for consistency

  for (int i = 0; i < count; i++) {
    final hue = (i * 360 / count + random.nextDouble() * 30) % 360;
    final saturation = 0.5 + random.nextDouble() * 0.3; // 0.5 to 0.8
    final lightness = 0.4 + random.nextDouble() * 0.3; // 0.4 to 0.7

    colors.add(HSLColor.fromAHSL(1.0, hue, saturation, lightness).toColor());
  }

  return colors;
}
