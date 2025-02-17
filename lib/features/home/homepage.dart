import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:isuna/app/theme/colors.dart';
import 'package:isuna/features/home/home_viemodel.dart';
import 'package:isuna/features/home/statistics_tab.dart';
import 'package:isuna/features/home/tranx_screen.dart';
import 'package:isuna/utils/utils.dart';
import 'package:isuna/widget/app_header.dart';
import 'package:isuna/widget/expense_analysis_card.dart';
import 'package:isuna/widget/expense_widget.dart';
import 'package:isuna/widget/income_analysis_card.dart';
import 'package:isuna/widget/shimmer.dart';
import 'package:isuna/widget/total_balance_card.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
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
  late TabController? _tabController;
  List<String> options = ['Monthly', 'Weekly', 'Daily'];
  bool _isStatsTabEnabled = false;
  int? prevIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
                    logout: homeRead.logout,
                  ),
                  GestureDetector(
                    child: TabBar(
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
                      onTap: (index) {
                        if (index == 2) {
                          print('index $index');
                          _tabController?.index = prevIndex!;
                          return;
                        }
                        prevIndex = index;
                      },
                      tabs: [
                        _buildTab('Overview'),
                        _buildTab('Transaction'),
                        _buildTab('Statistics'),
                      ],
                    ),
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
                        controller: homeWatch.refreshController,
                        onRefresh: () => homeRead.onRefresh(context),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              homeWatch.isLoadingBooking
                                  ? const ShimmerScreenLoading(
                                      height: 230.0,
                                      width: double.infinity,
                                      radius: 14.0,
                                    )
                                  : TotalBalanceCard(
                                      totalBalance:
                                          homeWatch.balances.actualBalance,
                                      actualBalance:
                                          homeWatch.balances.actualBalance,
                                      pendingBalance: '0',
                                    ),
                              const SizedBox(height: 20),
                              homeWatch.isLoadingIncomeAnalysis
                                  ? const ShimmerScreenLoading(
                                      height: 400.0,
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
                              homeWatch.isLoadingExpenseAnalysis
                                  ? const ShimmerScreenLoading(
                                      height: 400.0,
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
                              homeWatch.isLoadingExpenseCategory
                                  ? const ShimmerScreenLoading(
                                      height: 450.0,
                                      width: double.infinity,
                                      radius: 14.0,
                                    )
                                  : ExpenseWidget(
                                      // expenseCategory:
                                      //     homeWatch.expenseCategory,
                                      ),
                              const SizedBox(height: 20),
                              AccountsCard(),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                      TransactionsScreen(),
                      IgnorePointer(
                          child: StatisticsTab(
                              homeWatch: homeWatch, options: options)),
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

class AccountsCard extends ConsumerWidget {
  const AccountsCard({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          Row(
            children: [
              AccountsConntainer(
                title: 'Health Facilities',
                IconUrl: 'assets/svg/hospital.svg',
                subTitle: homeWatch.balances.totalState == 1
                    ? homeWatch.balances.totalFacilities.toString()
                    : homeWatch.summaryModel.facility.toString(),
                onTap: () =>
                    ref.read(homeViemodelProvider.notifier).navToFacilities(),
              ),
              Spacer(),
              homeWatch.summaryModel.personal != null
                  ? AccountsConntainer(
                      title: 'Managers',
                      IconUrl: 'assets/svg/people_icon.svg',
                      subTitle: homeWatch.balances.totalState == 1
                          ? '0'
                          : homeWatch.summaryModel.admin.toString(),
                      // onTap: () =>
                      //     ref.read(homeViemodelProvider.notifier).navToAdmin(),
                    )
                  : SizedBox.shrink()
            ],
          ),
          SizedBox(
            height: 20.0,
          ),

          //     Spacer(),
          // AccountsConntainer(
          //   title: 'Business',
          //   IconUrl: 'assets/svg/bag_icon.svg',
          //   subTitle: ,
          // )
          //   ],
          // )
        ],
      ),
    );
  }
}

class AccountsConntainer extends StatelessWidget {
  final String? IconUrl;
  final String? title;
  final String? subTitle;
  final VoidCallback? onTap;
  const AccountsConntainer(
      {super.key, this.IconUrl, this.title, this.subTitle, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}
