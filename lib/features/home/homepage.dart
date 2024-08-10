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

    // Future.wait([
    //   homeRead.fetchBalances(context),
    //   homeRead.fetchIncome(context),
    //   homeRead.fetchTranxList(context),
    //   homeRead.fetchExpenseAnalysis(context),
    //   homeRead.fetchExpenseCategory(context),
    // ]);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Safe to modify state here
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
                            const SizedBox(height: 13),
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
