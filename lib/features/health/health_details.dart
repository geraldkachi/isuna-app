import 'package:excel/excel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:isuna/app/theme/colors.dart';
import 'package:isuna/features/health/health_facilities_view_model.dart';
import 'package:isuna/features/health/record_expense_payment.dart';
import 'package:isuna/features/health/record_inflow_payment.dart';
import 'package:isuna/models/Income_expense_chart_model.dart';
import 'package:isuna/models/pie_chart_model.dart';
import 'package:isuna/models/tranx_list_model.dart';
import 'package:isuna/utils/string_utils.dart';
import 'package:isuna/utils/utils.dart';
import 'package:isuna/widget/custom_dropdown.dart';
import 'package:isuna/widget/custom_pie_chart.dart';
import 'package:isuna/widget/expense_widget.dart';
import 'package:isuna/widget/shimmer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HealthDetails extends ConsumerStatefulWidget {
  const HealthDetails({
    super.key,
  });

  @override
  ConsumerState<HealthDetails> createState() => _HealthDetailsState();
}

class _HealthDetailsState extends ConsumerState<HealthDetails>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<String> options = ['Monthly', 'Weekly', 'Daily'];
  bool showGreenLine = true;
  bool showOrangeLine = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    final facilitiesRead = ref.read(healthFacilitiesViemodelProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // This will run after the build method is completed
      facilitiesRead.onBuild(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final facilitiesWatch = ref.watch(healthFacilitiesViemodelProvider);
    final facilitiesRead = ref.read(healthFacilitiesViemodelProvider.notifier);

    double total = facilitiesWatch.categoryDataList!
        .fold(0, (sum, item) => sum + item.totalAmount);

    List<Color> mainColors =
        generateDistinctColors(facilitiesWatch.categoryDataList!.length);
    for (int i = 0; i < facilitiesWatch.categoryDataList!.length; i++) {
      facilitiesWatch.categoryDataList![i].setColor(mainColors[i]);
      // Generate and assign colors for subcategories
      List<Color> subColors = generateDistinctColors(
          facilitiesWatch.categoryDataList![i].subCategories.length);
      facilitiesWatch.categoryDataList![i].setSubColors(subColors);
    }

    final appSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: const Color(0xffF4F4F7),
        body: Stack(children: [
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
                InkWell(
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/svg/back.svg',
                        height: 16,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      const Text(
                        "Back",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white,
                          letterSpacing: -.5,
                        ),
                      )
                    ],
                  ),
                  onTap: () => context.pop(),
                ),
                const SizedBox(
                  height: 26,
                ),
                Text(
                  facilitiesWatch.selectedFacility!.name ?? '--',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20.0,
                    color: Colors.white,
                    letterSpacing: -.5,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      "${facilitiesWatch.selectedFacility!.lga}  ",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                        color: black400,
                        letterSpacing: -.5,
                      ),
                    ),
                    Icon(
                      Icons.circle,
                      size: 6.0,
                      color: grey100,
                    ),
                    Text(
                      "  ${facilitiesWatch.selectedFacility!.state}",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                        color: black400,
                        letterSpacing: -.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
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
                      color: red.withOpacity(0.7),
                    ),
                    insets: EdgeInsets.zero,
                  ),
                  tabs: [
                    _buildTab('Overview'),
                    _buildTab('Transaction'),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      SmartRefresher(
                        enablePullDown: true,
                        header: WaterDropHeader(),
                        controller: facilitiesWatch.refreshController,
                        onRefresh: () =>
                            facilitiesRead.onRefreshFacility(context),
                        onLoading: () => facilitiesRead.onLoadingFacility(),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              facilitiesWatch.isLoading
                                  ? const ShimmerScreenLoading(
                                      height: 200.0,
                                      width: double.infinity,
                                      radius: 14.0,
                                    )
                                  : Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18, vertical: 13),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Text(
                                                "Book Balance ",
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
                                                  'assets/svg/info_circle.svg'),
                                              const Spacer(),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 13,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              facilitiesWatch.hideAmounts
                                                  ? Text(
                                                      "****",
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontSize: 32,
                                                        color:
                                                            Color(0xff1B1C1E),
                                                        letterSpacing: -.5,
                                                      ),
                                                    )
                                                  : Row(
                                                      children: [
                                                        Text(
                                                          '₦',
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                              fontSize: 32,
                                                              color: Color(
                                                                  0xff1B1C1E),
                                                              fontFamily:
                                                                  'AreaNeu'),
                                                        ),
                                                        Text(
                                                          StringUtils.currencyConverter(
                                                              facilitiesWatch
                                                                      .facilityBalancesModel
                                                                      .actualBalance ??
                                                                  0),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w900,
                                                            fontSize: 34,
                                                            color: Color(
                                                                0xff1B1C1E),
                                                            letterSpacing: -.5,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                              const SizedBox(
                                                width: 7,
                                              ),
                                              InkWell(
                                                  onTap: () {
                                                    facilitiesRead
                                                        .toggleAmountVisibility();
                                                  },
                                                  child: SvgPicture.asset(
                                                    facilitiesWatch.hideAmounts
                                                        ? 'assets/svg/view-off-slash-stroke-rounded.svg'
                                                        : 'assets/svg/view-stroke-rounded.svg',
                                                    height: 20.0,
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                            black500,
                                                            BlendMode.srcIn),
                                                  ))
                                            ],
                                          ),
                                          // const SizedBox(
                                          //   height: 13,
                                          // ),
                                          // Row(
                                          //   children: [
                                          //     Container(
                                          //       decoration: BoxDecoration(
                                          //         color: green400,
                                          //         borderRadius:
                                          //             BorderRadius.circular(5),
                                          //       ),
                                          //       margin: const EdgeInsets.only(
                                          //           right: 14),
                                          //       padding:
                                          //           const EdgeInsets.symmetric(
                                          //               horizontal: 4,
                                          //               vertical: 4),
                                          //       child: Row(children: [
                                          //         SvgPicture.asset(
                                          //             'assets/svg/arrow_up.svg'),
                                          //         Text(
                                          //           '${facilitiesWatch.incomPercentageIncrease?.abs().toStringAsFixed(3)}',
                                          //           style: TextStyle(
                                          //             fontWeight:
                                          //                 FontWeight.w600,
                                          //             fontSize: 14,
                                          //             color: Color(0xff31AF99),
                                          //             letterSpacing: -.5,
                                          //           ),
                                          //         )
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
                                          const SizedBox(
                                            height: 18,
                                          ),
                                          Row(
                                            children: [
                                              InkWell(
                                                child: Container(
                                                  width: 135,
                                                  height: 45,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xffDC1D3C),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  margin: const EdgeInsets.only(
                                                      right: 14),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 4,
                                                      vertical: 4),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        SvgPicture.asset(
                                                            'assets/svg/expense.svg'),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        const Text(
                                                          "Expense",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 16,
                                                            color: Colors.white,
                                                            letterSpacing: -.5,
                                                          ),
                                                        )
                                                      ]),
                                                ),
                                                onTap: () {
                                                  context.go(
                                                      '/main_screen/health_details/record_expense_payment');
                                                },
                                              ),
                                              const Spacer(),
                                              SizedBox(
                                                height: 45.0,
                                                width: 135.0,
                                                child: TextButton(
                                                  onPressed: () {
                                                    context.go(
                                                        '/main_screen/health_details/record_inflow_payment');
                                                  },
                                                  style: TextButton.styleFrom(
                                                      backgroundColor: green300,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12.0))),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        SvgPicture.asset(
                                                            'assets/svg/inflow.svg'),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        const Text(
                                                          "Inflow",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 16,
                                                            color: Colors.white,
                                                            letterSpacing: -.5,
                                                          ),
                                                        )
                                                      ]),
                                                ),
                                              ),
                                              // InkWell(
                                              //   child: Container(
                                              //     width: 135,
                                              //     height: 45,
                                              //     decoration: BoxDecoration(
                                              //       color: const Color(0xff30B099),
                                              //       borderRadius:
                                              //           BorderRadius.circular(12),
                                              //     ),
                                              //     padding: const EdgeInsets.symmetric(
                                              //         horizontal: 4, vertical: 4),
                                              //     child: Row(
                                              //         mainAxisAlignment:
                                              //             MainAxisAlignment.center,
                                              //         children: [
                                              //           SvgPicture.asset(
                                              //               'assets/svg/inflow.svg'),
                                              //           const SizedBox(
                                              //             width: 8,
                                              //           ),
                                              //           const Text(
                                              //             "Inflow",
                                              //             style: TextStyle(
                                              //               fontWeight:
                                              //                   FontWeight.w600,
                                              //               fontSize: 16,
                                              //               color: Colors.white,
                                              //               letterSpacing: -.5,
                                              //             ),
                                              //           )
                                              //         ]),
                                              //   ),
                                              //   onTap: () {
                                              //     Navigator.push(
                                              //         context,
                                              //         MaterialPageRoute(
                                              //             builder: (context) =>
                                              //                 const RecordInflowPayment()));
                                              //   },
                                              // )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          )
                                        ],
                                      )),
                              const SizedBox(
                                height: 20,
                              ),
                              facilitiesWatch.isLoading
                                  ? const ShimmerScreenLoading(
                                      height: 500.0,
                                      width: double.infinity,
                                      radius: 14.0,
                                    )
                                  : Container(
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
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Row(
                                                  children: [
                                                    Switch(
                                                      value: showGreenLine,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          showGreenLine = value;
                                                        });
                                                      },
                                                      activeColor: const Color(
                                                          0xFF34B77F),
                                                      trackOutlineColor:
                                                          MaterialStateProperty
                                                              .resolveWith(
                                                        (final Set<
                                                                MaterialState>
                                                            states) {
                                                          if (states.contains(
                                                              MaterialState
                                                                  .selected)) {
                                                            return const Color(
                                                                0xFF34B77F);
                                                          }

                                                          return const Color(
                                                              0xff6C7278);
                                                        },
                                                      ),
                                                      activeTrackColor:
                                                          Colors.white,
                                                      inactiveTrackColor:
                                                          Colors.white,
                                                      inactiveThumbColor:
                                                          const Color(
                                                              0xff6C7278),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    const Text(
                                                      'Income\nStatistics',
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        letterSpacing: -.5,
                                                        height: 1.2,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Color(0xff6C7278),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const Spacer(),
                                                Row(
                                                  children: [
                                                    Switch(
                                                      value: showOrangeLine,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          showOrangeLine =
                                                              value;
                                                        });
                                                      },
                                                      activeColor: const Color(
                                                          0xFFE7844E),
                                                      trackOutlineColor:
                                                          MaterialStateProperty
                                                              .resolveWith(
                                                        (final Set<
                                                                MaterialState>
                                                            states) {
                                                          if (states.contains(
                                                              MaterialState
                                                                  .selected)) {
                                                            return const Color(
                                                                0xFFE7844E);
                                                          }

                                                          return const Color(
                                                              0xff6C7278);
                                                        },
                                                      ),
                                                      activeTrackColor:
                                                          Colors.white,
                                                      inactiveTrackColor:
                                                          Colors.white,
                                                      inactiveThumbColor:
                                                          const Color(
                                                              0xff6C7278),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    const Text(
                                                      'Expense\nStatistics',
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        letterSpacing: -.5,
                                                        height: 1.2,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Color(0xff6C7278),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            SfCartesianChart(
                                                primaryXAxis: CategoryAxis(),
                                                primaryYAxis: NumericAxis(
                                                  numberFormat:
                                                      NumberFormat.compact(),
                                                ),
                                                tooltipBehavior:
                                                    TooltipBehavior(
                                                        enable: true),
                                                series: <CartesianSeries<
                                                    GraphChartData, String>>[
                                                  showGreenLine
                                                      ? ColumnSeries<GraphChartData, String>(
                                                          dataSource: facilitiesWatch
                                                              .graphChartData,
                                                          xValueMapper:
                                                              (GraphChartData data, _) =>
                                                                  data.x,
                                                          yValueMapper:
                                                              (GraphChartData data, _) =>
                                                                  data.y1,
                                                          borderRadius: BorderRadius.only(
                                                              topRight:
                                                                  Radius.circular(
                                                                      5.0),
                                                              topLeft:
                                                                  Radius.circular(
                                                                      5.0)),
                                                          color:
                                                              Color(0xFF34B77F))
                                                      : ColumnSeries<GraphChartData, String>(
                                                          dataSource: [],
                                                          xValueMapper:
                                                              (GraphChartData data, _) =>
                                                                  data.x,
                                                          yValueMapper: (GraphChartData data, _) => data.y1,
                                                          borderRadius: BorderRadius.only(topRight: Radius.circular(5.0), topLeft: Radius.circular(5.0)),
                                                          color: Color(0xFF34B77F)),
                                                  showOrangeLine
                                                      ? ColumnSeries<
                                                          GraphChartData, String>(
                                                          dataSource:
                                                              facilitiesWatch
                                                                  .graphChartData,
                                                          xValueMapper:
                                                              (GraphChartData
                                                                          data,
                                                                      _) =>
                                                                  data.x,
                                                          yValueMapper:
                                                              (GraphChartData
                                                                          data,
                                                                      _) =>
                                                                  data.y2,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          5.0),
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          5.0)),
                                                          color:
                                                              Color(0xFFE7844E),
                                                          name: 'Expense',
                                                        )
                                                      : ColumnSeries<GraphChartData,
                                                              String>(
                                                          dataSource: [],
                                                          xValueMapper:
                                                              (GraphChartData data,
                                                                      _) =>
                                                                  data.x,
                                                          yValueMapper:
                                                              (GraphChartData data,
                                                                      _) =>
                                                                  data.y2,
                                                          borderRadius: BorderRadius.only(
                                                              topRight:
                                                                  Radius.circular(
                                                                      5.0),
                                                              topLeft:
                                                                  Radius.circular(
                                                                      5.0)),
                                                          color: Color(0xFFE7844E))
                                                ]),
                                          ]),
                                    ),
                              const SizedBox(
                                height: 20,
                              ),
                              facilitiesWatch.isLoading
                                  ? const ShimmerScreenLoading(
                                      height: 500.0,
                                      width: double.infinity,
                                      radius: 14.0,
                                    )
                                  : Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18, vertical: 13),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                              SvgPicture.asset(
                                                  'assets/svg/info_circle.svg'),
                                              const Spacer(),
                                            ],
                                          ),
                                          const SizedBox(height: 13),
                                          SfCircularChart(
                                              title: ChartTitle(
                                                  text: facilitiesWatch
                                                          .selectedCategoryChart
                                                          ?.category ??
                                                      'All Categories'),
                                              legend: Legend(
                                                  isVisible: true,
                                                  position:
                                                      LegendPosition.bottom),
                                              series: <CircularSeries>[
                                                // Render pie chart
                                                PieSeries<dynamic, String>(
                                                  dataLabelSettings:
                                                      DataLabelSettings(
                                                    isVisible: true,
                                                    showCumulativeValues: true,
                                                  ),
                                                  dataLabelMapper: (dynamic
                                                              data,
                                                          _) =>
                                                      NumberFormat('#,##0').format(data
                                                              is CategoryData
                                                          ? data.totalAmount
                                                              .toDouble()
                                                          : double.parse((data
                                                                  as SubCategoryData)
                                                              .amount)),
                                                  explode: true,
                                                  dataSource: facilitiesWatch
                                                          .selectedCategoryChart
                                                          ?.subCategories ??
                                                      facilitiesWatch
                                                          .categoryDataList,
                                                  pointColorMapper:
                                                      (dynamic data, _) =>
                                                          data is CategoryData
                                                              ? data.color
                                                              : data.color,
                                                  xValueMapper: (dynamic data,
                                                          _) =>
                                                      data is CategoryData
                                                          ? data.category
                                                          : (data as SubCategoryData)
                                                              .name,
                                                  yValueMapper: (dynamic
                                                              data,
                                                          _) =>
                                                      data
                                                              is CategoryData
                                                          ? data.totalAmount
                                                              .toInt()
                                                          : double.parse((data
                                                                  as SubCategoryData)
                                                              .amount),
                                                  onPointTap: (ChartPointDetails
                                                      details) {
                                                    if (facilitiesWatch
                                                            .selectedCategory ==
                                                        null) {
                                                      setState(() {
                                                        facilitiesRead.onCategoryTap(
                                                            facilitiesWatch
                                                                    .categoryDataList![
                                                                details
                                                                    .pointIndex!]);
                                                      });
                                                    }
                                                  },
                                                )
                                              ]),
                                          if (facilitiesWatch
                                                  .selectedCategoryChart !=
                                              null)
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: red),
                                              child: Text(
                                                'Reset',
                                                style:
                                                    TextStyle(color: white100),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  facilitiesWatch
                                                          .selectedCategoryChart =
                                                      null;
                                                });
                                              },
                                            ),
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount: (facilitiesWatch
                                                        .selectedCategoryChart
                                                        ?.subCategories ??
                                                    facilitiesWatch
                                                        .categoryDataList)
                                                ?.length,
                                            itemBuilder: (context, index) {
                                              final item = facilitiesWatch
                                                      .selectedCategoryChart
                                                      ?.subCategories[index] ??
                                                  facilitiesWatch
                                                      .categoryDataList?[index];
                                              final name = item is CategoryData
                                                  ? item.category
                                                  : (item as SubCategoryData)
                                                      .name;
                                              final amount = item
                                                      is CategoryData
                                                  ? item.totalAmount
                                                  : (item as SubCategoryData)
                                                      .amount;
                                              final color = item is CategoryData
                                                  ? item.color
                                                  : (item as SubCategoryData)
                                                      .color;
                                              double percentage = item
                                                      is CategoryData
                                                  ? (item.totalAmount / total) *
                                                      100
                                                  : (double.parse((item
                                                                  as SubCategoryData)
                                                              .amount) /
                                                          total) *
                                                      100;
                                              return LegendItem(
                                                onTap: item is CategoryData
                                                    ? () => facilitiesRead
                                                        .onCategoryTap(item)
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
                                    ),
                              const SizedBox(
                                height: 13,
                              ),
                            ],
                          ),
                        ),
                      ),
                      TransactionTab(),
                    ],
                  ),
                )
              ],
            ),
          )
        ]));
  }

  Widget _buildTab(String text) {
    return Tab(
      text: text,
      height: 38,
    );
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
}

class TransactionTab extends ConsumerWidget {
  const TransactionTab({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final facilitiesWatch = ref.watch(healthFacilitiesViemodelProvider);
    final facilitiesRead = ref.read(healthFacilitiesViemodelProvider.notifier);

    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropHeader(),
      controller: facilitiesWatch.transactionController,
      onRefresh: () => facilitiesRead.onRefreshFacility(context),
      onLoading: () => facilitiesRead.onLoadingTransactions(context),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48.0,
                    width: 230,
                    child: TextField(
                      controller: facilitiesWatch.transactionSearchController,
                      onChanged: (value) {
                        facilitiesRead.filterTransactions();
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Search transactions',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(11.5),
                          child: SvgPicture.asset(
                            'assets/svg/search.svg',
                            color: Colors.black,
                            width: 16,
                            height: 16,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 14.0),
                      ),
                      style: const TextStyle(
                        fontSize: 15.0,
                        letterSpacing: -.5,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                InkWell(
                  onTap: () {
                    facilitiesWatch.transactionSearchController.text.isEmpty
                        ? null
                        : facilitiesRead.fetchFacilityTransactionList(context);
                  },
                  child: Container(
                    width: 48.0,
                    height: 48.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xff313131),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: SvgPicture.asset(
                      'assets/svg/search.svg',
                      height: 20,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                InkWell(
                  onTap: () {
                    facilitiesRead.shareTransactionSheet(context);
                  },
                  child: Container(
                    width: 48.0,
                    height: 48.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xff313131),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: facilitiesWatch.isShareLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.0,
                            ),
                          )
                        : SvgPicture.asset(
                            'assets/svg/export.svg',
                            height: 19,
                          ),
                  ),
                ),
                // const SizedBox(
                //   width: 15,
                // ),
                // Container(
                //   width: 48.0,
                //   height: 48.0,
                //   decoration: const BoxDecoration(
                //     shape: BoxShape.circle,
                //     color: Color(0xffDC1D3C),
                //   ),
                //   padding: const EdgeInsets.all(13),
                //   child: SvgPicture.asset(
                //     'assets/svg/add.svg',
                //     height: 10,
                //     width: 10,
                //   ),
                // ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            facilitiesWatch.isLoading
                ? const ShimmerScreenLoading(
                    height: 600.0,
                    width: double.infinity,
                    radius: 14.0,
                  )
                : Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) => const SizedBox(
                              height: 25,
                            ),
                        itemCount: facilitiesWatch.filteredTransactions!.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final transaction =
                              facilitiesWatch.filteredTransactions![index];
                          final isIncome = transaction.income != null;
                          // final amount = isIncome
                          //     ? "+NGN${transaction.income!.amount}"
                          //     : "-NGN${transaction.expense!.amount}";
                          final date = isIncome
                              ? transaction.income!.date
                                  ?.toLocal()
                                  .toString()
                                  .split(' ')[0]
                              : transaction.expense!.date
                                  ?.toLocal()
                                  .toString()
                                  .split(' ')[0];
                          final category = isIncome
                              ? "Income"
                              : transaction.expense!.category;

                          return AuditTransactionTile(
                            title: transaction.facility,
                            subTitle: category,
                            transaction: transaction,
                            onTap: () {
                              facilitiesWatch.selectedTransaction = transaction;
                              facilitiesRead.updateStatus();
                              Utils.showHealthFlagTransactionBottomSheet(
                                  context);
                            },
                            amount: isIncome
                                ? StringUtils.currencyConverter(
                                    convertToInt(transaction.income!.amount) ??
                                        0)
                                : StringUtils.currencyConverter(
                                    convertToInt(transaction.expense!.amount) ??
                                        0),
                            date: date,
                            cashFlow: isIncome
                                ? 'assets/svg/direction_down.svg'
                                : 'assets/svg/direction_up.svg',
                          );
                        }),
                  ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  int? convertToInt(dynamic value) {
    if (value is int) {
      return value; // Already an integer
    } else if (value is double) {
      return value.toInt(); // Convert double to integer
    } else if (value is String) {
      // Try to parse the string to an integer
      int? parsedInt = int.tryParse(value);
      if (parsedInt != null) {
        return parsedInt;
      }

      // If parsing to int fails, try parsing as double first and then convert
      double? parsedDouble = double.tryParse(value);
      if (parsedDouble != null) {
        return parsedDouble.toInt();
      }

      // Return null if neither int nor double parsing succeeds
      return null;
    }

    // Return null if value is of an unsupported type
    return null;
  }
}

class AuditTransactionTile extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final String? amount;
  final String? date;
  final String? cashFlow;
  final Transaction? transaction;
  final VoidCallback? onTap;

  const AuditTransactionTile(
      {super.key,
      this.title,
      this.subTitle,
      this.amount,
      this.date,
      this.cashFlow,
      this.transaction,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: 56.0,
              height: 56.0,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xffF4F4F7),
              ),
              padding: const EdgeInsets.all(11),
              margin: const EdgeInsets.only(right: 13),
              child: SvgPicture.asset(
                cashFlow!,
                height: 19,
              )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 100.0,
                child: Text(
                  title ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xff1B1C1E),
                    letterSpacing: -.5,
                  ),
                ),
              ),
              SizedBox(
                height: 3,
              ),
              SizedBox(
                width: 100.0,
                child: Text(
                  subTitle ?? '--',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color(0xffABB5BC),
                    letterSpacing: -.5,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text(
                    '₦',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                      color: Color(0xff1B1C1E),
                      fontFamily: 'AreaNeu',
                    ),
                  ),
                  Text(
                    amount ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xff1B1C1E),
                      letterSpacing: -.5,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                date ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Color(0xffABB5BC),
                  letterSpacing: -.5,
                ),
              ),
              const SizedBox(height: 7.0),
              Container(
                padding: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: transaction?.income != null
                        ? transaction?.income?.status == null
                            ? green400
                            : transaction?.income?.status == 'flagged'
                                ? red.withOpacity(0.8)
                                : orange
                        : transaction?.expense?.status == null
                            ? green400
                            : transaction?.expense?.status == 'flagged'
                                ? red.withOpacity(0.8)
                                : orange),
                child: Text(
                  transaction?.income != null
                      ? '${transaction?.income?.status ?? 'Active'}'
                      : '${transaction?.expense?.status ?? 'Active'}',
                  style: TextStyle(
                      color: transaction?.income != null
                          ? transaction?.income?.status == null
                              ? green200
                              : white100
                          : transaction?.expense?.status == null
                              ? green200
                              : white100),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
