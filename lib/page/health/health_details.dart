import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:misau/page/health/record_expense_payment.dart';
import 'package:misau/page/health/record_inflow_payment.dart';
import 'package:misau/widget/custom_dropdown.dart';
import 'package:misau/widget/custom_pie_chart.dart';

class HealthDetails extends StatefulWidget {
  const HealthDetails({
    super.key,
  });

  @override
  State<HealthDetails> createState() => _HealthDetailsState();
}

class _HealthDetailsState extends State<HealthDetails>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<String> options = ['Monthly', 'Weekly', 'Daily'];
  bool showGreenLine = true;
  bool showOrangeLine = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
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
                        'assets/back.svg',
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
                  onTap: () => Navigator.pop(context),
                ),
                const SizedBox(
                  height: 26,
                ),
                const Text(
                  "Ayodele General Hosital",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 23,
                    color: Colors.white,
                    letterSpacing: -.5,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Ori-Ade . Osun State",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Color(0xffA1A6A9),
                    letterSpacing: -.5,
                  ),
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
                      color: const Color(0xffDC1C3D).withOpacity(0.7),
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
                            Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 13),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                            'assets/info_circle.svg'),
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
                                        const Text(
                                          "NGN 8,556,224",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 34,
                                            color: Color(0xff1B1C1E),
                                            letterSpacing: -.5,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 7,
                                        ),
                                        SvgPicture.asset('assets/eye.svg')
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 13,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xffD6FBE6),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          margin:
                                              const EdgeInsets.only(right: 14),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4, vertical: 4),
                                          child: Row(children: [
                                            SvgPicture.asset(
                                                'assets/arrow_up.svg'),
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
                                              color: const Color(0xffDC1D3C),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            margin: const EdgeInsets.only(
                                                right: 14),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4, vertical: 4),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                      'assets/expense.svg'),
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
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const RecordExpensePayment()));
                                          },
                                        ),
                                        const Spacer(),
                                        InkWell(
                                          child: Container(
                                            width: 135,
                                            height: 45,
                                            decoration: BoxDecoration(
                                              color: const Color(0xff30B099),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4, vertical: 4),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                      'assets/inflow.svg'),
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
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        RecordInflowPayment()));
                                          },
                                        )
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
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                      SvgPicture.asset('assets/info_circle.svg')
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
                                            activeColor: Color(0xFF34B77F),
                                            trackOutlineColor:
                                                MaterialStateProperty
                                                    .resolveWith(
                                              (final Set<MaterialState>
                                                  states) {
                                                if (states.contains(
                                                    MaterialState.selected)) {
                                                  return Color(0xFF34B77F);
                                                }

                                                return const Color(0xff6C7278);
                                              },
                                            ),
                                            activeTrackColor: Colors.white,
                                            inactiveTrackColor: Colors.white,
                                            inactiveThumbColor:
                                                Color(0xff6C7278),
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
                                            activeColor: Color(0xFFE7844E),
                                            trackOutlineColor:
                                                MaterialStateProperty
                                                    .resolveWith(
                                              (final Set<MaterialState>
                                                  states) {
                                                if (states.contains(
                                                    MaterialState.selected)) {
                                                  return Color(0xFFE7844E);
                                                }

                                                return const Color(0xff6C7278);
                                              },
                                            ),
                                            activeTrackColor: Colors.white,
                                            inactiveTrackColor: Colors.white,
                                            inactiveThumbColor:
                                                Color(0xff6C7278),
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
                                          maxY: 25,
                                          titlesData: FlTitlesData(
                                            show: true,
                                            bottomTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                showTitles: true,
                                                reservedSize: 40,
                                                getTitlesWidget: (double value,
                                                    TitleMeta meta) {
                                                  const style = TextStyle(
                                                    color: Color(0xffABB5BC),
                                                    fontWeight: FontWeight.w100,
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
                                                    space: 8,
                                                    child: text,
                                                  );
                                                },
                                              ),
                                            ),
                                            leftTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                showTitles: true,
                                                reservedSize: 40,
                                                getTitlesWidget: (double value,
                                                    TitleMeta meta) {
                                                  const style = TextStyle(
                                                    color: Color(0xffABB5BC),
                                                    fontWeight: FontWeight.w100,
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
                                              sideTitles:
                                                  SideTitles(showTitles: false),
                                            ),
                                            topTitles: AxisTitles(
                                              sideTitles:
                                                  SideTitles(showTitles: false),
                                            ),
                                          ),
                                          gridData: FlGridData(
                                            show: true,
                                            drawHorizontalLine: true,
                                            horizontalInterval: 5,
                                            getDrawingHorizontalLine: (value) {
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
                                          lineBarsData: [
                                            if (showGreenLine)
                                              LineChartBarData(
                                                spots: [
                                                  FlSpot(0, 8),
                                                  FlSpot(1, 10),
                                                  FlSpot(2, 14),
                                                  FlSpot(3, 15),
                                                  FlSpot(4, 13),
                                                ],
                                                isCurved: true,
                                                color: Color(0xFF34B77F),
                                                barWidth: 4,
                                                belowBarData: BarAreaData(
                                                  show: true,
                                                  color: Color(0xFF34B77F)
                                                      .withOpacity(0.3),
                                                ),
                                                dotData: FlDotData(
                                                  show: false,
                                                ),
                                              ),
                                            if (showOrangeLine)
                                              LineChartBarData(
                                                spots: [
                                                  FlSpot(0, 12),
                                                  FlSpot(1, 14),
                                                  FlSpot(2, 18),
                                                  FlSpot(3, 19),
                                                  FlSpot(4, 17),
                                                ],
                                                isCurved: true,
                                                color: Color(0xFFE7844E),
                                                barWidth: 4,
                                                belowBarData: BarAreaData(
                                                  show: true,
                                                  color: Color(0xFFE7844E)
                                                      .withOpacity(0.3),
                                                ),
                                                dotData: FlDotData(
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
                            Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 13),
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
                                        const SizedBox(
                                          width: 3,
                                        ),
                                        SvgPicture.asset(
                                            'assets/info_circle.svg'),
                                        const Spacer(),
                                        CustomDropdown(options)
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 13,
                                    ),
                                    Center(
                                      child: CustomPieChart([]),
                                    ),
                                    const SizedBox(
                                      height: 35,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: 13,
                                          height: 13,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xff30B099),
                                          ),
                                          margin:
                                              const EdgeInsets.only(right: 5),
                                        ),
                                        const Text(
                                          'Travel & Transport (40.1%)',
                                          style: TextStyle(
                                            color: Color(0xff6C7278),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: -.1,
                                          ),
                                        ),
                                        const Spacer(),
                                        const Text(
                                          'NGN500.000',
                                          style: TextStyle(
                                            color: Color(0xff1B1C1E),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: -.1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 23,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: 13,
                                          height: 13,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xffE6844D),
                                          ),
                                          margin:
                                              const EdgeInsets.only(right: 5),
                                        ),
                                        const Text(
                                          'Utilities (25%)',
                                          style: TextStyle(
                                            color: Color(0xff6C7278),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: -.1,
                                          ),
                                        ),
                                        const Spacer(),
                                        const Text(
                                          'NGN1000.000',
                                          style: TextStyle(
                                            color: Color(0xff1B1C1E),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: -.1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 23,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: 13,
                                          height: 13,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xffC65468),
                                          ),
                                          margin:
                                              const EdgeInsets.only(right: 5),
                                        ),
                                        const Text(
                                          'Maintenance (6.1%)',
                                          style: TextStyle(
                                            color: Color(0xff6C7278),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: -.1,
                                          ),
                                        ),
                                        const Spacer(),
                                        const Text(
                                          'NGN365.000',
                                          style: TextStyle(
                                            color: Color(0xff1B1C1E),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: -.1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 23,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: 13,
                                          height: 13,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xff4D81E7),
                                          ),
                                          margin:
                                              const EdgeInsets.only(right: 5),
                                        ),
                                        const Text(
                                          'Other Services (19.2%)',
                                          style: TextStyle(
                                            color: Color(0xff6C7278),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: -.1,
                                          ),
                                        ),
                                        const Spacer(),
                                        const Text(
                                          'NGN234.098',
                                          style: TextStyle(
                                            color: Color(0xff1B1C1E),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: -.1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 23,
                                    ),
                                  ],
                                )),
                            const SizedBox(
                              height: 13,
                            ),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 200,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: 'Search transactions',
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.all(11.5),
                                        child: SvgPicture.asset(
                                          'assets/search.svg',
                                          color: Colors.black,
                                          width: 16,
                                          height: 16,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 14.0),
                                    ),
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      letterSpacing: -.5,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  width: 50.0,
                                  height: 50.0,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xff313131),
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: SvgPicture.asset(
                                    'assets/export.svg',
                                    height: 19,
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Container(
                                  width: 50.0,
                                  height: 50.0,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xffDC1D3C),
                                  ),
                                  padding: const EdgeInsets.all(13),
                                  child: SvgPicture.asset(
                                    'assets/add.svg',
                                    height: 10,
                                    width: 10,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              height: 500,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              child: ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  height: 25,
                                ),
                                itemCount: 6,
                                shrinkWrap: true,
                                itemBuilder: (context, index) => Row(
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
                                        'assets/direction_up.svg',
                                        height: 19,
                                      ),
                                    ),
                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Figma Pro",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 17,
                                            color: Color(0xff1B1C1E),
                                            letterSpacing: -.5,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          "Ayodele General",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                            color: Color(0xffABB5BC),
                                            letterSpacing: -.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "-NGN23.21",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 17,
                                            color: Color(0xff1B1C1E),
                                            letterSpacing: -.5,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          "10/02/22",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                            color: Color(0xffABB5BC),
                                            letterSpacing: -.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 13,
                            ),
                          ],
                        ),
                      ),
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
}
