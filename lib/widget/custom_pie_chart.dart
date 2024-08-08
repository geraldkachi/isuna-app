import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:misau/models/expense_category.dart';
import 'package:misau/widget/expense_widget.dart';

class CustomPieChart extends StatelessWidget {
  final List<CategoryData> categoriesList;
  CustomPieChart(this.categoriesList);

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      SizedBox(
        width: 210,
        height: 210,
        child: PieChart(
          PieChartData(
            sections: getSections(),
            borderData: FlBorderData(
              show: false,
            ),
            sectionsSpace: 10,
            centerSpaceRadius: 70,
          ),
        ),
      ),
      Positioned(
          child: Container(
        width: 121,
        height: 121,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 7,
              blurRadius: 7,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: const Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '100%',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    letterSpacing: -.5,
                    height: 0),
              ),
              Text(
                'Data Recorded',
                style: TextStyle(color: Color(0xff6C7278), fontSize: 12.5),
              )
            ],
          ),
        ),
      ))
    ]);
  }

  List<PieChartSectionData> getSections() {
    return categoriesList.map((category) => PieChartSectionData(
        color:  getColorForCategory(category.category),
        value: category.amount.toDouble(),
        title: '',
        radius: 30,
      )).toList() ;
  }
}
