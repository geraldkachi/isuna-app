import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:misau/app/theme/colors.dart';
import 'package:misau/features/health/health_facilities_view_model.dart';
import 'package:misau/features/health/record_expense_payment.dart';
import 'package:misau/features/health/record_inflow_payment.dart';
import 'package:misau/utils/string_utils.dart';
import 'package:misau/widget/custom_dropdown.dart';
import 'package:misau/widget/custom_pie_chart.dart';
import 'package:misau/widget/shimmer.dart';

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
                      SingleChildScrollView(
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
                                              "Total Balance ",
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
                                                      color: Color(0xff1B1C1E),
                                                      letterSpacing: -.5,
                                                    ),
                                                  )
                                                : Row(
                                                    children: [
                                                      Text(
                                                        '₦',
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w900,
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
                                                          color:
                                                              Color(0xff1B1C1E),
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
                                                  colorFilter: ColorFilter.mode(
                                                      black500,
                                                      BlendMode.srcIn),
                                                ))
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 13,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: green400,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              margin: const EdgeInsets.only(
                                                  right: 14),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4,
                                                      vertical: 4),
                                              child: Row(children: [
                                                SvgPicture.asset(
                                                    'assets/svg/arrow_up.svg'),
                                                const Text(
                                                  "+3.1%",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                    color: Color(0xff31AF99),
                                                    letterSpacing: -.5,
                                                  ),
                                                )
                                              ]),
                                            ),
                                            const Text(
                                              "Increase this month",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                color: Color(0xff1B1C1E),
                                                letterSpacing: -.5,
                                              ),
                                            ),
                                          ],
                                        ),
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
                                                      BorderRadius.circular(12),
                                                ),
                                                margin: const EdgeInsets.only(
                                                    right: 14),
                                                padding:
                                                    const EdgeInsets.symmetric(
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
                                                  activeColor:
                                                      const Color(0xFF34B77F),
                                                  trackOutlineColor:
                                                      MaterialStateProperty
                                                          .resolveWith(
                                                    (final Set<MaterialState>
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
                                                      const Color(0xff6C7278),
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
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xff6C7278),
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
                                                      showOrangeLine = value;
                                                    });
                                                  },
                                                  activeColor:
                                                      const Color(0xFFE7844E),
                                                  trackOutlineColor:
                                                      MaterialStateProperty
                                                          .resolveWith(
                                                    (final Set<MaterialState>
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
                                                      const Color(0xff6C7278),
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
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xff6C7278),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        SizedBox(
                                            width: appSize.width,
                                            height: 400,
                                            child: LineChart(
                                              LineChartData(
                                                maxY: 100000,
                                                maxX: facilitiesRead
                                                        .balanceIncomeModel
                                                        .categories!
                                                        .length
                                                        .toDouble() -
                                                    1,
                                                titlesData: FlTitlesData(
                                                  show: true,
                                                  bottomTitles: AxisTitles(
                                                    sideTitles: SideTitles(
                                                      showTitles: true,
                                                      reservedSize: 40,
                                                      interval: 3,
                                                      getTitlesWidget:
                                                          (double value,
                                                              TitleMeta meta) {
                                                        int index =
                                                            value.toInt();
                                                        if (index >= 0 &&
                                                            index <
                                                                facilitiesRead
                                                                    .balanceIncomeModel
                                                                    .categories!
                                                                    .length) {
                                                          return Text(
                                                              facilitiesRead
                                                                  .balanceIncomeModel
                                                                  .categories![index],
                                                              style: TextStyle(
                                                                color: black400,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w100,
                                                                fontSize: 14,
                                                              ));
                                                        }
                                                        return SizedBox
                                                            .shrink();

                                                        // const style = TextStyle(
                                                        //   color: black400,
                                                        //   fontWeight:
                                                        //       FontWeight.w100,
                                                        //   fontSize: 14,
                                                        // );
                                                        // Widget text;
                                                        // switch (value.toInt()) {
                                                        //   case 0:
                                                        //     text = const Text(
                                                        //         'Jan',
                                                        //         style: style);
                                                        //     break;
                                                        //   case 1:
                                                        //     text = const Text(
                                                        //         'Feb',
                                                        //         style: style);
                                                        //     break;
                                                        //   case 2:
                                                        //     text = const Text(
                                                        //         'Mar',
                                                        //         style: style);
                                                        //     break;
                                                        //   case 3:
                                                        //     text = const Text(
                                                        //         'Apr',
                                                        //         style: style);
                                                        //     break;
                                                        //   case 4:
                                                        //     text = const Text(
                                                        //         'May',
                                                        //         style: style);
                                                        //     break;
                                                        //   default:
                                                        //     text = const Text(
                                                        //         '',
                                                        //         style: style);
                                                        //     break;
                                                        // }
                                                        // return SideTitleWidget(
                                                        //   axisSide:
                                                        //       meta.axisSide,
                                                        //   space: 8,
                                                        //   child: text,
                                                        // );
                                                      },
                                                    ),
                                                  ),
                                                  leftTitles: AxisTitles(
                                                    sideTitles: SideTitles(
                                                      showTitles: true,
                                                      reservedSize: 45,
                                                      getTitlesWidget:
                                                          (double value,
                                                              TitleMeta meta) {
                                                        const style = TextStyle(
                                                          color:
                                                              Color(0xffABB5BC),
                                                          fontWeight:
                                                              FontWeight.w100,
                                                          fontSize: 14,
                                                        );
                                                        const nairaStyle =
                                                            TextStyle(
                                                                color: Color(
                                                                    0xffABB5BC),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w100,
                                                                fontSize: 12,
                                                                fontFamily:
                                                                    'AreaNeu');
                                                        Widget text;
                                                        switch (value.toInt()) {
                                                          case 10000:
                                                            text = Row(
                                                              children: [
                                                                Text('₦',
                                                                    style:
                                                                        nairaStyle),
                                                                const Text(
                                                                    '10k',
                                                                    style:
                                                                        style),
                                                              ],
                                                            );
                                                            break;
                                                          case 20000:
                                                            text = Row(
                                                              children: [
                                                                Text('₦',
                                                                    style:
                                                                        nairaStyle),
                                                                const Text(
                                                                    '20k',
                                                                    style:
                                                                        style),
                                                              ],
                                                            );
                                                            break;
                                                          case 30000:
                                                            text = Row(
                                                              children: [
                                                                Text('₦',
                                                                    style:
                                                                        nairaStyle),
                                                                const Text(
                                                                    '30k',
                                                                    style:
                                                                        style),
                                                              ],
                                                            );
                                                            break;
                                                          case 40000:
                                                            text = Row(
                                                              children: [
                                                                Text('₦',
                                                                    style:
                                                                        nairaStyle),
                                                                const Text(
                                                                    '40k',
                                                                    style:
                                                                        style),
                                                              ],
                                                            );
                                                            break;
                                                          case 50000:
                                                            text = Row(
                                                              children: [
                                                                Text('₦',
                                                                    style:
                                                                        nairaStyle),
                                                                const Text(
                                                                    '50k',
                                                                    style:
                                                                        style),
                                                              ],
                                                            );
                                                            break;

                                                          case 60000:
                                                            text = Row(
                                                              children: [
                                                                Text('₦',
                                                                    style:
                                                                        nairaStyle),
                                                                const Text(
                                                                    '60k',
                                                                    style:
                                                                        style),
                                                              ],
                                                            );
                                                            break;

                                                          case 70000:
                                                            text = Row(
                                                              children: [
                                                                Text('₦',
                                                                    style:
                                                                        nairaStyle),
                                                                const Text(
                                                                    '70k',
                                                                    style:
                                                                        style),
                                                              ],
                                                            );
                                                            break;

                                                          case 80000:
                                                            text = Row(
                                                              children: [
                                                                Text('₦',
                                                                    style:
                                                                        nairaStyle),
                                                                const Text(
                                                                    '80k',
                                                                    style:
                                                                        style),
                                                              ],
                                                            );
                                                            break;

                                                          case 90000:
                                                            text = Row(
                                                              children: [
                                                                Text('₦',
                                                                    style:
                                                                        nairaStyle),
                                                                const Text(
                                                                    '90k',
                                                                    style:
                                                                        style),
                                                              ],
                                                            );
                                                            break;
                                                          case 100000:
                                                            text = Row(
                                                              children: [
                                                                Text('₦',
                                                                    style:
                                                                        nairaStyle),
                                                                const Text(
                                                                    '100k',
                                                                    style:
                                                                        style),
                                                              ],
                                                            );
                                                            break;
                                                          default:
                                                            text = const Text(
                                                                '',
                                                                style: style);
                                                            break;
                                                        }
                                                        return SideTitleWidget(
                                                          axisSide:
                                                              meta.axisSide,
                                                          space: 7,
                                                          child: text,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  rightTitles: const AxisTitles(
                                                    sideTitles: SideTitles(
                                                        showTitles: false),
                                                  ),
                                                  topTitles: const AxisTitles(
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
                                                    return const FlLine(
                                                      color: Color(0xffE5EAED),
                                                      strokeWidth: 1,
                                                    );
                                                  },
                                                  drawVerticalLine: false,
                                                ),
                                                borderData: FlBorderData(
                                                  show: false,
                                                ),
                                                lineBarsData: [
                                                  if (showGreenLine)
                                                    LineChartBarData(
                                                      spots: List.generate(
                                                          facilitiesRead
                                                              .balanceIncomeModel
                                                              .data!
                                                              .length, (index) {
                                                        return FlSpot(
                                                          index.toDouble(),
                                                          facilitiesRead
                                                              .balanceIncomeModel
                                                              .data![index]
                                                              .toDouble(),
                                                        );
                                                      }),

                                                      // [
                                                      //   const FlSpot(0, 8),
                                                      //   const FlSpot(1, 10),
                                                      //   const FlSpot(2, 14),
                                                      //   const FlSpot(3, 15),
                                                      //   const FlSpot(4, 13),
                                                      // ],
                                                      isCurved: true,
                                                      color: const Color(
                                                          0xFF34B77F),
                                                      barWidth: 4,
                                                      belowBarData: BarAreaData(
                                                        show: true,
                                                        color: const Color(
                                                                0xFF34B77F)
                                                            .withOpacity(0.3),
                                                      ),
                                                      dotData: const FlDotData(
                                                        show: false,
                                                      ),
                                                    ),
                                                  if (showOrangeLine)
                                                    LineChartBarData(
                                                      spots: List.generate(
                                                          facilitiesRead
                                                              .balanceExpenseModel
                                                              .data!
                                                              .length, (index) {
                                                        return FlSpot(
                                                          index.toDouble(),
                                                          facilitiesRead
                                                              .balanceExpenseModel
                                                              .data![index]
                                                              .toDouble(),
                                                        );
                                                      }),
                                                      // [
                                                      //   const FlSpot(0, 12),
                                                      //   const FlSpot(1, 14),
                                                      //   const FlSpot(2, 18),
                                                      //   const FlSpot(3, 19),
                                                      //   const FlSpot(4, 17),
                                                      // ],
                                                      isCurved: true,
                                                      color: const Color(
                                                          0xFFE7844E),
                                                      barWidth: 4,
                                                      belowBarData: BarAreaData(
                                                        show: true,
                                                        color: const Color(
                                                                0xFFE7844E)
                                                            .withOpacity(0.3),
                                                      ),
                                                      dotData: const FlDotData(
                                                        show: false,
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            )),
                                      ],
                                    ),
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
                                        Center(
                                          child: CustomPieChart(facilitiesWatch
                                              .expenseCategory
                                              .categoriesWithPercentages),
                                        ),
                                        const SizedBox(
                                          height: 35,
                                        ),
                                        ...facilitiesWatch.expenseCategory
                                            .categoriesWithPercentages
                                            .map((entry) {
                                          final color = getColorForCategory(
                                              entry.category);
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 23),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 13,
                                                  height: 13,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: color,
                                                  ),
                                                  margin: const EdgeInsets.only(
                                                      right: 5),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    '${entry.category} (${entry.percentage}%)',
                                                    style: const TextStyle(
                                                      color: Color(0xff6C7278),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      letterSpacing: -.1,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ],
                                    )),
                            const SizedBox(
                              height: 13,
                            ),
                          ],
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

    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: facilitiesWatch.searchController,
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
                    contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
                  ),
                  style: const TextStyle(
                    fontSize: 15.0,
                    letterSpacing: -.5,
                  ),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Container(
                width: 48.0,
                height: 48.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xff313131),
                ),
                padding: const EdgeInsets.all(10),
                child: SvgPicture.asset(
                  'assets/svg/export.svg',
                  height: 19,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Container(
                width: 48.0,
                height: 48.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xffDC1D3C),
                ),
                padding: const EdgeInsets.all(13),
                child: SvgPicture.asset(
                  'assets/svg/add.svg',
                  height: 10,
                  width: 10,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
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
                                .toLocal()
                                .toString()
                                .split(' ')[0]
                            : transaction.expense!.date
                                .toLocal()
                                .toString()
                                .split(' ')[0];
                        final category =
                            isIncome ? "Income" : transaction.expense!.category;

                        return AuditTransactionTile(
                          title: transaction.facility,
                          subTitle: category,
                          amount: StringUtils.currencyConverter(isIncome
                              ? transaction.income!.amount.toInt()
                              : transaction.expense!.amount.toInt()),
                          date: date,
                          cashFlow: isIncome
                              ? 'assets/svg/direction_up.svg'
                              : 'assets/svg/direction_down.svg',
                        );
                      }),
                ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}

class AuditTransactionTile extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final String? amount;
  final String? date;
  final String? cashFlow;
  const AuditTransactionTile(
      {super.key,
      this.title,
      this.subTitle,
      this.amount,
      this.date,
      this.cashFlow});

  @override
  Widget build(BuildContext context) {
    return Row(
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
                subTitle!,
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
          ],
        ),
      ],
    );
  }
}
