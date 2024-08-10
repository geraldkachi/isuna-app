import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:misau/features/home/home_viemodel.dart';
import 'package:misau/widget/expense_analysis_card.dart';
import 'package:misau/widget/expense_widget.dart';
import 'package:misau/widget/income_analysis_card.dart';

class StatisticsTab extends StatelessWidget {
  const StatisticsTab({
    super.key,
    required this.appSize,
    required this.homeWatch,
    required this.options,
  });

  final Size appSize;
  final HomeViemodel homeWatch;
  final List<String> options;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.symmetric(
                  horizontal: 18, vertical: 24),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Balance Statistics ",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: Color(0xff1B1C1E),
                          letterSpacing: -.5,
                        ),
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      SvgPicture.asset(
                          'assets/svg/info_circle.svg')
                    ],
                  ),
                  const SizedBox(
                    height: 13,
                  ),
                  SizedBox(
                    width: appSize.width,
                    height: 400,
                    child: BarChart(
                      BarChartData(
                        alignment:
                            BarChartAlignment.spaceAround,
                        maxY: 25,
                        barTouchData:
                            BarTouchData(enabled: false),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize:
                                  40, // Increased reserved size for bottom titles
                              getTitlesWidget:
                                  (double value,
                                      TitleMeta meta) {
                                const style = TextStyle(
                                  color: Color(0xffABB5BC),
                                  fontWeight:
                                      FontWeight.w100,
                                  fontSize: 14,
                                );
                                Widget text;
                                switch (value.toInt()) {
                                  case 0:
                                    text = Text('Jan',
                                        style: style);
                                    break;
                                  case 1:
                                    text = Text('Feb',
                                        style: style);
                                    break;
                                  case 2:
                                    text = Text('Mar',
                                        style: style);
                                    break;
                                  case 3:
                                    text = Text('Apr',
                                        style: style);
                                    break;
                                  case 4:
                                    text = Text('May',
                                        style: style);
                                    break;
                                  default:
                                    text = Text('',
                                        style: style);
                                    break;
                                }
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  space:
                                      8, // Reduced space between the titles and the bars
                                  child: text,
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize:
                                  40, // Increased reserved size for left titles
                              getTitlesWidget:
                                  (double value,
                                      TitleMeta meta) {
                                const style = TextStyle(
                                  color: Color(0xffABB5BC),
                                  fontWeight:
                                      FontWeight.w100,
                                  fontSize: 14,
                                );
                                Widget text;
                                switch (value.toInt()) {
                                  case 1:
                                    text = Text('\$1k',
                                        style: style);
                                    break;
                                  case 5:
                                    text = Text('\$5k',
                                        style: style);
                                    break;
                                  case 10:
                                    text = Text('\$10k',
                                        style: style);
                                    break;
                                  case 15:
                                    text = Text('\$15k',
                                        style: style);
                                    break;
                                  case 20:
                                    text = Text('\$20k',
                                        style: style);
                                    break;
                                  default:
                                    text = Text('',
                                        style: style);
                                    break;
                                }
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  space: 7,
                                  child: text,
                                );
                              },
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(
                                showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(
                                showTitles: false),
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawHorizontalLine: true,
                          horizontalInterval: 5,
                          getDrawingHorizontalLine:
                              (value) {
                            return FlLine(
                              color: Color(0xffE5EAED),
                              strokeWidth: 1,
                            );
                          },
                          drawVerticalLine: false,
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        barGroups: [
                          BarChartGroupData(
                            x: 0,
                            barRods: [
                              BarChartRodData(
                                toY: 8,
                                color: Color(0xFFB1C7F3),
                                width: 35,
                                borderRadius:
                                    BorderRadius.zero,
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 1,
                            barRods: [
                              BarChartRodData(
                                toY: 10,
                                color: Color(0xFFB1C7F3),
                                width: 35,
                                borderRadius:
                                    BorderRadius.zero,
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 2,
                            barRods: [
                              BarChartRodData(
                                toY: 14,
                                color: Color(0xFFB1C7F3),
                                width: 35,
                                borderRadius:
                                    BorderRadius.zero,
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 3,
                            barRods: [
                              BarChartRodData(
                                toY: 15,
                                color: Color(0xFFB1C7F3),
                                width: 35,
                                borderRadius:
                                    BorderRadius.zero,
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 4,
                            barRods: [
                              BarChartRodData(
                                toY: 13,
                                color: Color(0xFFB1C7F3),
                                width: 35,
                                borderRadius:
                                    BorderRadius.zero,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )),
          const SizedBox(
            height: 20,
          ),
          IncomeAnalysisCard(
            currentMonthIncome:
                homeWatch.incomeAnalysis.currentMonthIncome,
            lastMonthIncome:
                homeWatch.incomeAnalysis.lastMonthIncome,
            options: options,
          ),
          const SizedBox(height: 20),
          ExpenseAnalysisCard(
            currentMonthExpense:
                homeWatch.expenseAnalysis.currentMonthExpense,
            lastMonthExpense:
                homeWatch.expenseAnalysis.lastMonthExpense,
            options: options,
          ),
          const SizedBox(height: 20),
          ExpenseWidget(
            expenseCategory: homeWatch.expenseCategory!,
          ),
          const SizedBox(height: 13),
        ],
      ),
    );
  }
}
