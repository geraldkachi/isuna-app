import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:misau/app/theme/colors.dart';
import 'package:misau/features/home/home_viemodel.dart';
import 'package:misau/features/home/tranx_screen.dart';
import 'package:misau/utils/utils.dart';
import 'package:misau/widget/app_header.dart';
import 'package:misau/widget/expense_analysis_card.dart';
import 'package:misau/widget/expense_widget.dart';
import 'package:misau/widget/income_analysis_card.dart';
import 'package:misau/widget/shimmer.dart';
import 'package:misau/widget/total_balance_card.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<String> options = ['Monthly', 'Weekly', 'Daily'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    final homeRead = ref.read(homeViemodelProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeRead.onInit ? null : homeRead.fetchWalletData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeWatch = ref.watch(homeViemodelProvider);
    final homeRead = ref.read(homeViemodelProvider.notifier);

    return Scaffold(
        backgroundColor: const Color(0xffF4F4F7),
        body: Stack(
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
                    firstName: homeWatch.userData.firstName ?? 'User',
                    lastName: homeWatch.userData.lastName ?? 'User',
                    onNotification: () {},
                    onFilter: () => Utils.showFilterBottomSheet(context),
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
                        color: red.withOpacity(0.7),
                      ),
                      insets: EdgeInsets.zero,
                    ),
                    tabs: [
                      _buildTab('Overview'),
                      _buildTab('Transaction'),
                      // _buildTab('Statistics'),
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
                            homeWatch.isLoading
                                ? const ShimmerScreenLoading(
                                    height: 200.0,
                                    width: double.infinity,
                                    radius: 14.0,
                                  )
                                : TotalBalanceCard(
                                    totalBalance:
                                        homeWatch.balances.totalBalance,
                                    actualBalance:
                                        homeWatch.balances.actualBalance,
                                    pendingBalance:
                                        homeWatch.balances.pendingBalance,
                                  ),
                            const SizedBox(height: 20),
                            homeWatch.isLoading
                                ? const ShimmerScreenLoading(
                                    height: 200.0,
                                    width: double.infinity,
                                    radius: 14.0,
                                  )
                                : IncomeAnalysisCard(
                                    currentMonthIncome: homeWatch
                                        .incomeAnalysis.currentMonthIncome,
                                    lastMonthIncome: homeWatch
                                        .incomeAnalysis.lastMonthIncome,
                                    options: options,
                                  ),
                            const SizedBox(height: 20),
                            homeWatch.isLoading
                                ? const ShimmerScreenLoading(
                                    height: 200.0,
                                    width: double.infinity,
                                    radius: 14.0,
                                  )
                                : ExpenseAnalysisCard(
                                    currentMonthExpense: homeWatch
                                        .expenseAnalysis.currentMonthExpense,
                                    lastMonthExpense: homeWatch
                                        .expenseAnalysis.lastMonthExpense,
                                    options: options,
                                  ),
                            const SizedBox(height: 20),
                            homeWatch.isLoading
                                ? const ShimmerScreenLoading(
                                    height: 350.0,
                                    width: double.infinity,
                                    radius: 14.0,
                                  )
                                : ExpenseWidget(
                                    expenseCategory: homeWatch.expenseCategory,
                                  ),
                            const SizedBox(height: 20),
                            AccountsCard(),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      TransactionsScreen(),
                      // StatisticsTab(appSize: appSize, homeWatch: homeWatch, options: options),
                    ],
                  )),
                ],
              ),
            )
          ],
        ));
  }

  Widget _buildTab(String text) {
    return Tab(
      text: text,
      height: 38,
    );
  }
}

class AccountsCard extends StatelessWidget {
  const AccountsCard({
    super.key,
  });

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
        children: [
          Row(
            children: [
              const Text(
                "Accounts ",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                  color: Color(0xff1B1C1E),
                  letterSpacing: -.5,
                ),
              ),
              const SizedBox(width: 3),
              SvgPicture.asset('assets/svg/info_circle.svg'),
            ],
          ),
          SizedBox(
            height: 30.0,
          ),
          // Row(
          //   children: [
          //     AccountsConntainer(
          //       title: 'Personal',
          //       IconUrl: 'assets/svg/user_icon.svg',
          //       subTitle: '230',
          //     ),
          //     Spacer(),
          //     AccountsConntainer(
          //       title: 'Business',
          //       IconUrl: 'assets/svg/bag_icon.svg',
          //       subTitle: '46',
          //     )
          //   ],
          // ),
          // SizedBox(
          //   height: 20.0,
          // ),
          Row(
            children: [
              AccountsConntainer(
                title: 'Health Facilities',
                IconUrl: 'assets/svg/hospital.svg',
                subTitle: '150',
              ),
              Spacer(),
              AccountsConntainer(
                title: 'Managers',
                IconUrl: 'assets/svg/people_icon.svg',
                subTitle: '322',
              )
            ],
          )
        ],
      ),
    );
  }
}

class AccountsConntainer extends StatelessWidget {
  final String? IconUrl;
  final String? title;
  final String? subTitle;
  const AccountsConntainer({
    super.key,
    this.IconUrl,
    this.title,
    this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.0,
      width: 150.0,
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          border: Border.all(color: grey100),
          borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              height: 40.0,
              width: 40.0,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0), color: white100),
              child: SvgPicture.asset(
                IconUrl!,
              )),
          SizedBox(
            height: 15.0,
          ),
          Text(
            title!,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.0),
          ),
          Text(
            subTitle!,
            style: TextStyle(
                fontWeight: FontWeight.w600, color: black400, fontSize: 13.0),
          ),
        ],
      ),
    );
  }
}
