import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:misau/app/theme/colors.dart';
import 'package:misau/models/expense_category.dart';
import 'package:misau/widget/custom_dropdown.dart';
import 'package:misau/widget/custom_pie_chart.dart';

class ExpenseWidget extends StatelessWidget {
  final ExpenseCategory expenseCategory;

  const ExpenseWidget({super.key, required this.expenseCategory});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "Expense Category ",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                  color: Color(0xff1B1C1E),
                  letterSpacing: -.5,
                ),
              ),
              const SizedBox(width: 3),
              SvgPicture.asset('assets/svg/info_circle.svg'),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 13),
          Center(
              child: CustomPieChart(expenseCategory
                  .categoriesWithPercentages)), // Replace with actual data
          const SizedBox(height: 35),
          ...expenseCategory.categoriesWithPercentages.map((entry) {
            final color = getColorForCategory(entry.category);
            return Padding(
              padding: const EdgeInsets.only(bottom: 23),
              child: Row(
                children: [
                  Container(
                    width: 13,
                    height: 13,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                    ),
                    margin: const EdgeInsets.only(right: 5),
                  ),
                  Expanded(
                    child: Text(
                      '${entry.category} (${entry.percentage}%)',
                      style: const TextStyle(
                        color: Color(0xff6C7278),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -.1,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

Color getColorForCategory(String category) {
  return category.contains("UTILITIES")
      ? const Color(0xffE6844D)
      : category.contains("FUEL & LUBRICANTS")
          ? blue
          : category.contains("Other")
              ? red700
              : Colors.grey;
}
