import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:misau/features/home/home_viemodel.dart';
import 'package:misau/provider/auth_provider.dart';
import 'package:misau/models/tranx_list_model.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(homeViemodelProvider.notifier).initListener();
  }

  @override
  void dispose() {
    ref.watch(homeViemodelProvider).searchController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeWatch = ref.watch(homeViemodelProvider);
    final homeRead = ref.read(homeViemodelProvider.notifier);

    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 200,
                child: TextField(
                  controller: homeWatch.searchController,
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
                  'assets/svg/export.svg',
                  height: 19,
                ),
              ),
              const SizedBox(width: 15),
              Container(
                width: 50.0,
                height: 50.0,
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
          Container(
            margin: const EdgeInsets.only(top: 20),
            height: homeWatch.filteredTransactions!.length * 120.0,
            width: double.infinity,
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
                      final amount = isIncome
                          ? "+NGN${transaction.income!.amount}"
                          : "-NGN${transaction.expense!.amount}";
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
                              isIncome
                                  ? 'assets/svg/direction_up.svg'
                                  : 'assets/svg/direction_down.svg',
                              height: 19,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  category,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17,
                                    color: Color(0xff1B1C1E),
                                    letterSpacing: -.5,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  transaction.facility,
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
                                    amount,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17,
                                      color: Color(0xff1B1C1E),
                                      letterSpacing: -.5,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                date,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: Color(0xffABB5BC),
                                  letterSpacing: -.5,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
          ),
          const SizedBox(height: 13),
        ],
      ),
    );
  }
}
