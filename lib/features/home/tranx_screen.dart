import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:isuna/app/theme/colors.dart';
import 'package:isuna/features/home/home_viemodel.dart';
import 'package:isuna/utils/string_utils.dart';
import 'package:isuna/utils/utils.dart';
import 'package:isuna/widget/shimmer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeWatch = ref.watch(homeViemodelProvider);
    final homeRead = ref.read(homeViemodelProvider.notifier);

    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropHeader(),
      controller: homeWatch.transactionRefreshController,
      onRefresh: () => homeRead.onRefresh(context),
      onLoading: () => homeRead.onTransactionLoading(context),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: homeWatch.searchController,
                    onChanged: (value) {
                      homeRead.filterTransactions();
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
                SizedBox(width: 10.0),
                InkWell(
                  onTap: () {
                    homeRead.shareTransactionSheet(context);
                  },
                  child: Container(
                    width: 48.0,
                    height: 48.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xff313131),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: homeWatch.isShareLoading
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
                // const SizedBox(width: 15),
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
                // )
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: InkWell(
                onTap: () {
                  homeWatch.filteredTransactions?.clear();
                  homeWatch.isShowDeleted = true;
                  homeRead.fetchTranxList(context,
                      state: '',
                      lga: '',
                      facility: '',
                      fromDate: '',
                      prev: '',
                      next: '',
                      limit: '10',
                      showDeleted: 'yes',
                      // clearList: () => homeWatch.filteredTransactions?.clear(),
                      toDate: '');
                },
                child: Text(
                  'Show deleted transactions',
                  style: TextStyle(color: red, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            homeWatch.isLoadingTransaction
                ? const ShimmerScreenLoading(
                    height: 600.0,
                    width: double.infinity,
                    radius: 14.0,
                  )
                : Container(
                    margin: const EdgeInsets.only(top: 20),
                    // width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: homeWatch.filteredTransactions!.isEmpty
                        ? const Center(child: Text('No transactions found'))
                        : ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 25),
                            itemCount: homeWatch.filteredTransactions!.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final transaction =
                                  homeWatch.filteredTransactions![index];

                              final isIncome = transaction.income != null;

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
                                  : transaction.expense?.category;

                              return InkWell(
                                onTap: () {
                                  homeWatch.selectedTransaction = transaction;
                                  homeRead.updateStatus();
                                  Utils.showFlagTransactionBottomSheet(
                                      context, homeWatch, homeRead);
                                },
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
                                        isIncome
                                            ? 'assets/svg/direction_down.svg'
                                            : 'assets/svg/direction_up.svg',
                                        height: 19,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            category ?? '--',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                              color: Color(0xff1B1C1E),
                                              letterSpacing: -.5,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            transaction.facility ?? '--',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                              color: Color(0xffABB5BC),
                                              letterSpacing: -.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        isIncome
                                            ? Row(
                                                children: [
                                                  Text(
                                                    '₦',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 17,
                                                      color: Color(0xff1B1C1E),
                                                      fontFamily: 'AreaNeu',
                                                    ),
                                                  ),
                                                  Text(
                                                    transaction.income!.amount
                                                            is String
                                                        ? StringUtils.currencyConverter(
                                                            double.parse(
                                                                    transaction
                                                                        .income!
                                                                        .amount)
                                                                .toInt())
                                                        : StringUtils
                                                            .currencyConverter(
                                                                transaction
                                                                    .income!
                                                                    .amount
                                                                    .toInt()),
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 17,
                                                      color: Color(0xff1B1C1E),
                                                      letterSpacing: -.5,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Row(
                                                children: [
                                                  const Text(
                                                    '₦',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 17,
                                                      color: Color(0xff1B1C1E),
                                                      fontFamily: 'AreaNeu',
                                                    ),
                                                  ),
                                                  Text(
                                                    transaction.expense!.amount
                                                            is String
                                                        ? StringUtils.currencyConverter(
                                                            double.parse(
                                                                    transaction
                                                                        .expense!
                                                                        .amount)
                                                                .toInt())
                                                        : StringUtils
                                                            .currencyConverter(
                                                                transaction
                                                                    .expense!
                                                                    .amount
                                                                    .toInt()),
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 17,
                                                      color: Color(0xff1B1C1E),
                                                      letterSpacing: -.5,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                        const SizedBox(height: 3.0),
                                        Text(
                                          date ?? '--',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                            color: Color(0xffABB5BC),
                                            letterSpacing: -.5,
                                          ),
                                        ),
                                        const SizedBox(height: 7.0),
                                        Container(
                                          padding: EdgeInsets.all(5.0),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              color: transaction.deletedAt !=
                                                      null
                                                  ? red
                                                  : isIncome
                                                      ? transaction.income
                                                                  ?.status ==
                                                              null
                                                          ? green400
                                                          : transaction.income
                                                                      ?.status ==
                                                                  'flagged'
                                                              ? red.withOpacity(
                                                                  0.8)
                                                              : orange
                                                      : transaction.expense
                                                                  ?.status ==
                                                              null
                                                          ? green400
                                                          : transaction.expense
                                                                      ?.status ==
                                                                  'flagged'
                                                              ? red.withOpacity(
                                                                  0.8)
                                                              : orange),
                                          child: Text(
                                            transaction.deletedAt != null
                                                ? 'Deleted'
                                                : isIncome
                                                    ? '${transaction.income?.status ?? 'Active'}'
                                                    : '${transaction.expense?.status ?? 'Active'}',
                                            style: TextStyle(
                                                color: transaction.deletedAt !=
                                                        null
                                                    ? white100
                                                    : isIncome
                                                        ? transaction.income
                                                                    ?.status ==
                                                                null
                                                            ? green200
                                                            : white100
                                                        : transaction.expense
                                                                    ?.status ==
                                                                null
                                                            ? green200
                                                            : white100),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
            const SizedBox(height: 13),
          ],
        ),
      ),
    );
  }
}
