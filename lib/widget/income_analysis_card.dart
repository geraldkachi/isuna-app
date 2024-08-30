import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:isuna/app/theme/colors.dart';
import 'package:isuna/features/home/home_viemodel.dart';
import 'package:isuna/models/income_graph_model.dart';
import 'package:isuna/utils/string_utils.dart';
import 'package:isuna/widget/custom_dropdown.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class IncomeAnalysisCard extends ConsumerStatefulWidget {
  final dynamic currentMonthIncome;
  final dynamic lastMonthIncome;
  final List<String> options;

  IncomeAnalysisCard({
    Key? key,
    required this.currentMonthIncome,
    required this.lastMonthIncome,
    required this.options,
  }) : super(key: key);

  @override
  ConsumerState<IncomeAnalysisCard> createState() => _IncomeAnalysisCardState();
}

class _IncomeAnalysisCardState extends ConsumerState<IncomeAnalysisCard> {
  Widget? chart;

  @override
  Widget build(BuildContext context) {
    final homeWatch = ref.watch(homeViemodelProvider);
    final homeRead = ref.read(homeViemodelProvider.notifier);

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
                "Inflow Analysis ",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                  color: Color(0xff1B1C1E),
                  letterSpacing: -.5,
                ),
              ),
              const SizedBox(width: 3),
              Tooltip(
                  richMessage:
                      TextSpan(text: 'Inflow Analysis:  \n', children: [
                    TextSpan(
                        text:
                            'Display total inflow and also the visual representation of the inflow flow. You can also choose to visualize in different trends. The graph shows the sum of the total recorded inflow per month')
                  ]),
                  child: SvgPicture.asset('assets/svg/info_circle.svg')),
              const Spacer(),
              // CustomDropdown(options),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              homeWatch.hideAmounts
                  ? Text(
                      "****",
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 34,
                        color: Color(0xff1B1C1E),
                        letterSpacing: -.5,
                      ),
                    )
                  : Row(
                      children: [
                        Text(
                          '₦',
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 28,
                              color: Color(0xff1B1C1E),
                              fontFamily: 'AreaNeu'),
                        ),
                        Text(
                          "${StringUtils.currencyConverter(homeWatch.incomeAnalysis.currentMonthIncome.toInt() ?? 0).trim()} ",
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 34,
                            color: Color(0xff1B1C1E),
                            letterSpacing: -.5,
                          ),
                        ),
                      ],
                    ),
              const SizedBox(width: 7),
              InkWell(
                  onTap: () {
                    homeRead.toggleAmountVisibility();
                  },
                  child: SvgPicture.asset(
                    homeWatch.hideAmounts
                        ? 'assets/svg/view-off-slash-stroke-rounded.svg'
                        : 'assets/svg/view-stroke-rounded.svg',
                    height: 20.0,
                    colorFilter: ColorFilter.mode(black500, BlendMode.srcIn),
                  )),
            ],
          ),
          // const SizedBox(height: 13),
          // Row(
          //   children: [
          //     Container(
          //       decoration: BoxDecoration(
          //         color: green400,
          //         borderRadius: BorderRadius.circular(5),
          //       ),
          //       margin: const EdgeInsets.only(right: 14),
          //       padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          //       child: Row(children: [
          //         SvgPicture.asset('assets/svg/arrow_up.svg'),
          //         Text(
          //           "${homeRead.incomePercentageIncrease?.abs().toStringAsFixed(3)}%",
          //           style: const TextStyle(
          //             fontWeight: FontWeight.w600,
          //             fontSize: 14,
          //             color: Color(0xff31AF99),
          //             letterSpacing: -.5,
          //           ),
          //         ),
          //       ]),
          //     ),
          //     const Text(
          //       "Increase this month",
          //       style: TextStyle(
          //         fontWeight: FontWeight.w500,
          //         fontSize: 16,
          //         color: Color(0xff1B1C1E),
          //         letterSpacing: -.5,
          //       ),
          //     ),
          //   ],
          // ),
          const SizedBox(height: 30),
          SizedBox(
            height: 15.0,
          ),
          SizedBox(
            height: 50.0,
            width: 140.0,
            child: DropdownButtonFormField<String>(
              value: homeWatch.selectedIncomeChartType?.toLowerCase(),
              // validator: (value) => Validator.validateField(value),
              decoration: InputDecoration(
                // hintText: 'Select status',
                hintStyle: TextStyle(
                  color: Color(0xff121827).withOpacity(0.4),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                    color: grey100,
                    width: 1.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                    color: grey100,
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                    color: black,
                    width: 1.0,
                  ),
                ),
              ),
              icon: SvgPicture.asset(
                'assets/svg/arrow_dropdown.svg',
                width: 13,
                height: 13,
                color: const Color(0xff121827),
              ),
              items: ['Line', 'Bar', 'Column']
                  .map<DropdownMenuItem<String>>((value) {
                return DropdownMenuItem<String>(
                  value: value.toLowerCase(),
                  child: Text(
                    value,
                    style: const TextStyle(
                        color: Color(0xff121827),
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                homeWatch.selectedIncomeChartType = newValue!;
                print(homeWatch.selectedIncomeChartType);
                switch (homeWatch.selectedIncomeChartType) {
                  case ' ':
                    chart = BarChartSeries(homeWatch: homeWatch);
                    break;
                  case 'bar':
                    chart = BarChartSeries(homeWatch: homeWatch);
                    break;
                  case 'line':
                    chart = LineChart(homeWatch: homeWatch);
                    break;
                  case 'column':
                    chart = ColumnChart(homeWatch: homeWatch);
                    break;
                  default:
                    chart = LineChart(homeWatch: homeWatch);
                }

                setState(() {
                  chart = chart;
                });
              },
            ),
          ),
          const SizedBox(height: 30),
          chart ?? LineChart(homeWatch: homeWatch),
        ],
      ),
    );
  }
}

class ColumnChart extends StatelessWidget {
  const ColumnChart({
    super.key,
    required this.homeWatch,
  });

  final HomeViemodel homeWatch;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(
          labelStyle: TextStyle(fontFamily: 'AreaNeu'),
          numberFormat: NumberFormat.compactCurrency(
            locale: 'en_NG', // Nigeria currency format
            symbol: '₦',
          ),
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CartesianSeries<IncomeGraphModel, String>>[
          ColumnSeries<IncomeGraphModel, String>(
              dataSource: homeWatch.incomeGraphModel,
              xValueMapper: (IncomeGraphModel data, _) => data.month,
              yValueMapper: (IncomeGraphModel data, _) => data.expense?[0],
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(5.0),
                  topLeft: Radius.circular(5.0)),
              color: Color.fromRGBO(8, 142, 255, 1))
        ]);
  }
}

class BarChartSeries extends StatelessWidget {
  const BarChartSeries({
    super.key,
    required this.homeWatch,
  });

  final HomeViemodel homeWatch;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(
          labelStyle: TextStyle(fontFamily: 'AreaNeu'),
          numberFormat: NumberFormat.compactCurrency(
            locale: 'en_NG', // Nigeria currency format
            symbol: '₦',
          ),
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CartesianSeries<IncomeGraphModel, String>>[
          BarSeries<IncomeGraphModel, String>(
              dataSource: homeWatch.incomeGraphModel!.reversed.toList(),
              xValueMapper: (IncomeGraphModel data, _) => data.month,
              yValueMapper: (IncomeGraphModel data, _) => data.expense?[0],
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(5.0),
                  bottomRight: Radius.circular(5.0)),
              color: Color.fromRGBO(8, 142, 255, 1))
        ]);
  }
}

class LineChart extends StatelessWidget {
  const LineChart({
    super.key,
    required this.homeWatch,
  });

  final HomeViemodel homeWatch;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      // title: ChartTitle(text: 'Expense Analysis'),
      primaryXAxis: CategoryAxis(),
      primaryYAxis: NumericAxis(
        labelStyle: TextStyle(fontFamily: 'AreaNeu'),
        numberFormat: NumberFormat.compactCurrency(
          locale: 'en_NG', // Nigeria currency format
          symbol: '₦',
        ),
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CartesianSeries>[
        LineSeries<IncomeGraphModel, String>(
          dataSource: homeWatch.incomeGraphModel,
          xValueMapper: (IncomeGraphModel data, _) => data.month,
          yValueMapper: (IncomeGraphModel data, _) => data.expense?[0],
          markerSettings:
              MarkerSettings(isVisible: true, shape: DataMarkerType.circle),
        ),
      ],
    );
  }
}
