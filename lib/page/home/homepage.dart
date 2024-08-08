import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:misau/page/home/filter_screen.dart';
import 'package:misau/page/home/tranx_screen.dart';
import 'package:misau/provider/auth_provider.dart';
import 'package:misau/widget/app_header.dart';
import 'package:misau/widget/custom_dropdown.dart';
import 'package:misau/widget/custom_pie_chart.dart';
import 'package:misau/widget/expense_analysis_card.dart';
import 'package:misau/widget/expense_widget.dart';
import 'package:misau/widget/income_analysis_card.dart';
import 'package:misau/widget/total_balance_card.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<String> options = ['Monthly', 'Weekly', 'Daily'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    Provider.of<AuthProvider>(context, listen: false).fetchWalletData();
  }

  @override
  Widget build(BuildContext context) {
    final appSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: const Color(0xffF4F4F7),
        body: Consumer<AuthProvider>(builder: (context, auth, child) {
          return Stack(
            children: [
              Container(
                width: double.infinity,
                height: 350,
                color: const Color(0xff1A1A1A),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppHeader(
                      firstName: auth.userData?.firstName ?? 'User',
                      lastName: auth.userData?.lastName ?? 'User',
                      onNotification: () {},
                      onFilter: () => showFilterBottomSheet(context),
                      onSearch: () {},
                    ),
                    TabBar(
                      controller: _tabController,
                      dividerColor: const Color(0xff5F5F5F),
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorPadding: EdgeInsets.zero,
                      unselectedLabelColor: const Color(0xffA1A6A9),
                      labelColor: Colors.white,
                      indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(
                          width: 1.0,
                          color: const Color(0xffDC1C3D).withOpacity(0.7),
                        ),
                        insets: EdgeInsets.zero,
                      ),
                      tabs: [
                        _buildTab('Overview'),
                        _buildTab('Transaction'),
                        _buildTab('Statistics'),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                        child: TabBarView(
                      controller: _tabController,
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              TotalBalanceCard(
                                totalBalance: auth.balances?.totalBalance,
                                actualBalance: auth.balances?.actualBalance,
                                pendingBalance: auth.balances?.pendingBalance,
                              ),
                              const SizedBox(height: 20),
                              IncomeAnalysisCard(
                                currentMonthIncome:
                                    auth.incomeAnalysis?.currentMonthIncome,
                                lastMonthIncome:
                                    auth.incomeAnalysis?.lastMonthIncome,
                                options: options,
                              ),
                              const SizedBox(height: 20),
                              ExpenseAnalysisCard(
                                currentMonthExpense:
                                    auth.expenseAnalysis?.currentMonthExpense,
                                lastMonthExpense:
                                    auth.expenseAnalysis?.lastMonthExpense,
                                options: options,
                              ),
                              const SizedBox(height: 20),
                              if (auth.expenseCategory != null)
                                ExpenseWidget(
                                  expenseCategory: auth.expenseCategory!,
                                ),
                              const SizedBox(height: 13),
                            ],
                          ),
                        ),
                        TransactionsScreen(),
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              // Container(
                              //     width: double.infinity,
                              //     decoration: BoxDecoration(
                              //       color: Colors.white,
                              //       borderRadius: BorderRadius.circular(14),
                              //     ),
                              //     padding: const EdgeInsets.symmetric(
                              //         horizontal: 18, vertical: 24),
                              //     child: Column(
                              //       crossAxisAlignment:
                              //           CrossAxisAlignment.start,
                              //       children: [
                              //         Row(
                              //           children: [
                              //             const Text(
                              //               "Balance Statistics ",
                              //               style: TextStyle(
                              //                 fontWeight: FontWeight.w600,
                              //                 fontSize: 17,
                              //                 color: Color(0xff1B1C1E),
                              //                 letterSpacing: -.5,
                              //               ),
                              //             ),
                              //             const SizedBox(
                              //               width: 3,
                              //             ),
                              //             SvgPicture.asset(
                              //                 'assets/info_circle.svg')
                              //           ],
                              //         ),
                              //         const SizedBox(
                              //           height: 13,
                              //         ),
                              //         SizedBox(
                              //           width: appSize.width,
                              //           height: 400,
                              //           child: BarChart(
                              //             BarChartData(
                              //               alignment:
                              //                   BarChartAlignment.spaceAround,
                              //               maxY: 25,
                              //               barTouchData:
                              //                   BarTouchData(enabled: false),
                              //               titlesData: FlTitlesData(
                              //                 show: true,
                              //                 bottomTitles: AxisTitles(
                              //                   sideTitles: SideTitles(
                              //                     showTitles: true,
                              //                     reservedSize:
                              //                         40, // Increased reserved size for bottom titles
                              //                     getTitlesWidget:
                              //                         (double value,
                              //                             TitleMeta meta) {
                              //                       const style = TextStyle(
                              //                         color: Color(0xffABB5BC),
                              //                         fontWeight:
                              //                             FontWeight.w100,
                              //                         fontSize: 14,
                              //                       );
                              //                       Widget text;
                              //                       switch (value.toInt()) {
                              //                         case 0:
                              //                           text = Text('Jan',
                              //                               style: style);
                              //                           break;
                              //                         case 1:
                              //                           text = Text('Feb',
                              //                               style: style);
                              //                           break;
                              //                         case 2:
                              //                           text = Text('Mar',
                              //                               style: style);
                              //                           break;
                              //                         case 3:
                              //                           text = Text('Apr',
                              //                               style: style);
                              //                           break;
                              //                         case 4:
                              //                           text = Text('May',
                              //                               style: style);
                              //                           break;
                              //                         default:
                              //                           text = Text('',
                              //                               style: style);
                              //                           break;
                              //                       }
                              //                       return SideTitleWidget(
                              //                         axisSide: meta.axisSide,
                              //                         space:
                              //                             8, // Reduced space between the titles and the bars
                              //                         child: text,
                              //                       );
                              //                     },
                              //                   ),
                              //                 ),
                              //                 leftTitles: AxisTitles(
                              //                   sideTitles: SideTitles(
                              //                     showTitles: true,
                              //                     reservedSize:
                              //                         40, // Increased reserved size for left titles
                              //                     getTitlesWidget:
                              //                         (double value,
                              //                             TitleMeta meta) {
                              //                       const style = TextStyle(
                              //                         color: Color(0xffABB5BC),
                              //                         fontWeight:
                              //                             FontWeight.w100,
                              //                         fontSize: 14,
                              //                       );
                              //                       Widget text;
                              //                       switch (value.toInt()) {
                              //                         case 1:
                              //                           text = Text('\$1k',
                              //                               style: style);
                              //                           break;
                              //                         case 5:
                              //                           text = Text('\$5k',
                              //                               style: style);
                              //                           break;
                              //                         case 10:
                              //                           text = Text('\$10k',
                              //                               style: style);
                              //                           break;
                              //                         case 15:
                              //                           text = Text('\$15k',
                              //                               style: style);
                              //                           break;
                              //                         case 20:
                              //                           text = Text('\$20k',
                              //                               style: style);
                              //                           break;
                              //                         default:
                              //                           text = Text('',
                              //                               style: style);
                              //                           break;
                              //                       }
                              //                       return SideTitleWidget(
                              //                         axisSide: meta.axisSide,
                              //                         space: 7,
                              //                         child: text,
                              //                       );
                              //                     },
                              //                   ),
                              //                 ),
                              //                 rightTitles: AxisTitles(
                              //                   sideTitles: SideTitles(
                              //                       showTitles: false),
                              //                 ),
                              //                 topTitles: AxisTitles(
                              //                   sideTitles: SideTitles(
                              //                       showTitles: false),
                              //                 ),
                              //               ),
                              //               gridData: FlGridData(
                              //                 show: true,
                              //                 drawHorizontalLine: true,
                              //                 horizontalInterval: 5,
                              //                 getDrawingHorizontalLine:
                              //                     (value) {
                              //                   return FlLine(
                              //                     color: Color(0xffE5EAED),
                              //                     strokeWidth: 1,
                              //                   );
                              //                 },
                              //                 drawVerticalLine: false,
                              //               ),
                              //               borderData: FlBorderData(
                              //                 show: false,
                              //               ),
                              //               barGroups: [
                              //                 BarChartGroupData(
                              //                   x: 0,
                              //                   barRods: [
                              //                     BarChartRodData(
                              //                       toY: 8,
                              //                       color: Color(0xFFB1C7F3),
                              //                       width: 35,
                              //                       borderRadius:
                              //                           BorderRadius.zero,
                              //                     ),
                              //                   ],
                              //                 ),
                              //                 BarChartGroupData(
                              //                   x: 1,
                              //                   barRods: [
                              //                     BarChartRodData(
                              //                       toY: 10,
                              //                       color: Color(0xFFB1C7F3),
                              //                       width: 35,
                              //                       borderRadius:
                              //                           BorderRadius.zero,
                              //                     ),
                              //                   ],
                              //                 ),
                              //                 BarChartGroupData(
                              //                   x: 2,
                              //                   barRods: [
                              //                     BarChartRodData(
                              //                       toY: 14,
                              //                       color: Color(0xFFB1C7F3),
                              //                       width: 35,
                              //                       borderRadius:
                              //                           BorderRadius.zero,
                              //                     ),
                              //                   ],
                              //                 ),
                              //                 BarChartGroupData(
                              //                   x: 3,
                              //                   barRods: [
                              //                     BarChartRodData(
                              //                       toY: 15,
                              //                       color: Color(0xFFB1C7F3),
                              //                       width: 35,
                              //                       borderRadius:
                              //                           BorderRadius.zero,
                              //                     ),
                              //                   ],
                              //                 ),
                              //                 BarChartGroupData(
                              //                   x: 4,
                              //                   barRods: [
                              //                     BarChartRodData(
                              //                       toY: 13,
                              //                       color: Color(0xFFB1C7F3),
                              //                       width: 35,
                              //                       borderRadius:
                              //                           BorderRadius.zero,
                              //                     ),
                              //                   ],
                              //                 ),
                              //               ],
                              //             ),
                              //           ),
                              //         )
                              //       ],
                              //     )),
                              // const SizedBox(
                              //   height: 20,
                              // ),
                             IncomeAnalysisCard(
                                currentMonthIncome:
                                    auth.incomeAnalysis?.currentMonthIncome,
                                lastMonthIncome:
                                    auth.incomeAnalysis?.lastMonthIncome,
                                options: options,
                              ),
                              const SizedBox(height: 20),
                              ExpenseAnalysisCard(
                                currentMonthExpense:
                                    auth.expenseAnalysis?.currentMonthExpense,
                                lastMonthExpense:
                                    auth.expenseAnalysis?.lastMonthExpense,
                                options: options,
                              ),
                              const SizedBox(height: 20),
                              if (auth.expenseCategory != null)
                                ExpenseWidget(
                                  expenseCategory: auth.expenseCategory!,
                                ),
                              const SizedBox(height: 13),
                              ],
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
              )
            ],
          );
        }));
  }

  Widget _buildTab(String text) {
    return Tab(
      text: text,
      height: 38,
    );
  }
}

void showFilterBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20.0),
      ),
    ),
    builder: (context) {
      return FilterScreen();
    },
  );
}

double calculatePercentageIncrease(int oldValue, int newValue) {
  if (oldValue == 0) {
    if (newValue > 0) {
      // If oldValue is 0 and newValue is greater than 0, percentage increase is 100%
      return 100.0;
    } else {
      // If both oldValue and newValue are 0, percentage increase is 0%
      return 0.0;
    }
  }

  double increase = newValue.toDouble() - oldValue.toDouble();
  double percentageIncrease = (increase / oldValue) * 100;
  return percentageIncrease;
}
