import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:isuna/app/theme/colors.dart';
import 'package:isuna/features/home/home_viemodel.dart';
import 'package:isuna/models/categories_model.dart';
import 'package:isuna/models/expense_category.dart';
import 'package:isuna/models/pie_chart_model.dart';
import 'package:isuna/utils/string_utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ExpenseWidget extends ConsumerStatefulWidget {
  @override
  ConsumerState<ExpenseWidget> createState() => _ExpenseWidgetState();
}

class _ExpenseWidgetState extends ConsumerState<ExpenseWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // assignColors(widget.expenseCategory.name!);
  }

  @override
  Widget build(BuildContext context) {
    final homeWatch = ref.watch(homeViemodelProvider);
    final homeRead = ref.read(homeViemodelProvider.notifier);

    double total = homeWatch.categoryDataList!
        .fold(0, (sum, item) => sum + item.totalAmount);
    // Generate and assign colors
    List<Color> mainColors =
        generateDistinctColors(homeWatch.categoryDataList!.length);
    for (int i = 0; i < homeWatch.categoryDataList!.length; i++) {
      homeWatch.categoryDataList![i].setColor(mainColors[i]);
      // Generate and assign colors for subcategories
      List<Color> subColors = generateDistinctColors(
          homeWatch.categoryDataList![i].subCategories.length);
      homeWatch.categoryDataList![i].setSubColors(subColors);
    }
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

          SfCircularChart(
              title: ChartTitle(
                  text:
                      homeWatch.selectedCategory?.category ?? 'All Categories'),
              legend: Legend(isVisible: true, position: LegendPosition.bottom),
              series: <CircularSeries>[
                // Render pie chart
                PieSeries<dynamic, String>(
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    showCumulativeValues: true,
                  ),
                  dataLabelMapper: (dynamic data, _) => NumberFormat('#,##0')
                      .format(data is CategoryData
                          ? data.totalAmount.toDouble()
                          : double.parse((data as SubCategoryData).amount)),
                  explode: true,
                  dataSource: homeWatch.selectedCategory?.subCategories ??
                      homeWatch.categoryDataList,
                  pointColorMapper: (dynamic data, _) =>
                      data is CategoryData ? data.color : data.color,
                  xValueMapper: (dynamic data, _) => data is CategoryData
                      ? data.category
                      : (data as SubCategoryData).name,
                  yValueMapper: (dynamic data, _) => data is CategoryData
                      ? data.totalAmount.toInt()
                      : double.parse((data as SubCategoryData).amount),
                  onPointTap: (ChartPointDetails details) {
                    if (homeWatch.selectedCategory == null) {
                      setState(() {
                        homeRead.onCategoryTap(
                            homeWatch.categoryDataList![details.pointIndex!]);
                      });
                    }
                  },
                )
              ]),
          if (homeWatch.selectedCategory != null)
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: red),
              child: Text(
                'Reset',
                style: TextStyle(color: white100),
              ),
              onPressed: () {
                setState(() {
                  homeWatch.selectedCategory = null;
                });
              },
            ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: (homeWatch.selectedCategory?.subCategories ??
                    homeWatch.categoryDataList)
                ?.length,
            itemBuilder: (context, index) {
              final item = homeWatch.selectedCategory?.subCategories[index] ??
                  homeWatch.categoryDataList?[index];
              final name = item is CategoryData
                  ? item.category
                  : (item as SubCategoryData).name;
              final amount = item is CategoryData
                  ? item.totalAmount
                  : (item as SubCategoryData).amount;
              final color = item is CategoryData
                  ? item.color
                  : (item as SubCategoryData).color;
              double percentage = item is CategoryData
                  ? (item.totalAmount / total) * 100
                  : (double.parse((item as SubCategoryData).amount) / total) *
                      100;
              return LegendItem(
                onTap: item is CategoryData
                    ? () => homeRead.onCategoryTap(item)
                    : null,
                name: name,
                percentage: percentage,
                color: color!,
                amount: amount,
              );
            },
          ),
        ],
      ),
    );
  }
}

class LegendItem extends StatelessWidget {
  final String name;
  final double percentage;
  final Color color;
  final dynamic amount;
  final VoidCallback? onTap;

  LegendItem(
      {required this.name,
      required this.percentage,
      required this.color,
      required this.amount,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            // Color Indicator
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 8),
            // Legend Text
            SizedBox(
              width: 200.0,
              child: Text(
                '$name )',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            Spacer(),
            // Amount Text
            Row(
              children: [
                Text(
                  '₦',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      fontFamily: 'AreaNue'),
                ),
                Text(
                  '${StringUtils.currencyConverter(amount is String ? double.parse(amount).toInt() : amount.toInt())}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
