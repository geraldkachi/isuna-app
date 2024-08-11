import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:misau/app/theme/colors.dart';
import 'package:misau/features/home/home_viemodel.dart';
import 'package:misau/utils/string_utils.dart';
import 'package:misau/widget/custom_dropdown.dart';

class IncomeAnalysisCard extends ConsumerWidget {
  final int? currentMonthIncome;
  final int? lastMonthIncome;
  final List<String> options;

  const IncomeAnalysisCard({
    Key? key,
    required this.currentMonthIncome,
    required this.lastMonthIncome,
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
                "Income Analysis ",
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
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 28,
                        color: Color(0xff1B1C1E),
                        fontFamily: 'AreaNeu'),
                  ),
                  Text(
                    "${StringUtils.currencyConverter(homeWatch.incomeAnalysis.currentMonthIncome ?? 0).trim()} ",
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
                  color: green400,
                  borderRadius: BorderRadius.circular(5),
                ),
                margin: const EdgeInsets.only(right: 14),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Row(children: [
                  SvgPicture.asset('assets/svg/arrow_up.svg'),
                  Text(
                    "+${homeRead.calculatePercentageIncrease().trim()}%",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xff31AF99),
                      letterSpacing: -.5,
                    ),
                  ),
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
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
