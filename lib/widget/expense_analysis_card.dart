import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:misau/features/home/home_viemodel.dart';
import 'package:misau/widget/custom_dropdown.dart';

class ExpenseAnalysisCard extends ConsumerWidget {
  final int? currentMonthExpense;
  final int? lastMonthExpense;
  final List<String> options;

  const ExpenseAnalysisCard({
    Key? key,
    required this.currentMonthExpense,
    required this.lastMonthExpense,
    required this.options,
  }) : super(key: key);

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "Expense Analysis ",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                  color: Color(0xff1B1C1E),
                  letterSpacing: -.5,
                ),
              ),
              const SizedBox(width: 3),
              SvgPicture.asset('assets/svg/info_circle.svg'),
              const Spacer(),
              CustomDropdown(options),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             Row(
                      children: [
                        Text(
                          '₦',
                          style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 34,
                              color: Color(0xff1B1C1E),
                              fontFamily: 'AreaNeu'),
                        ),
                        Text(
                          "${homeRead.expenseAnalysis.currentMonthExpense ?? 0}",
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
              SvgPicture.asset('assets/svg/eye.svg'),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xffF9C6BE),
                  borderRadius: BorderRadius.circular(5),
                ),
                margin: const EdgeInsets.only(right: 14),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Row(children: [
                  SvgPicture.asset('assets/svg/arrow_down.svg'),
                  Text(
                    "${homeRead.calculatePercentageDecrease()}%",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xffC65469),
                      letterSpacing: -.5,
                    ),
                  ),
                ]),
              ),
              const Text(
                "Decreased this month",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Color(0xff1B1C1E),
                  letterSpacing: -.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  String calculatePercentageIncrease(int currentMonth, int lastMonth) {
    final percentageIncrease = (lastMonth - currentMonth) / currentMonth * 100;
    return percentageIncrease.abs().toStringAsFixed(1);
  }
}
