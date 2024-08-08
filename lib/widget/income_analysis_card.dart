import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:misau/widget/custom_dropdown.dart';

class IncomeAnalysisCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
              SvgPicture.asset('assets/info_circle.svg'),
              const Spacer(),
              CustomDropdown(options),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              currentMonthIncome == null
                  ? const CircularProgressIndicator()
                  : Text(
                      "NGN $currentMonthIncome",
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 34,
                        color: Color(0xff1B1C1E),
                        letterSpacing: -.5,
                      ),
                    ),
              const SizedBox(width: 7),
              SvgPicture.asset('assets/eye.svg'),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xffD6FBE6),
                  borderRadius: BorderRadius.circular(5),
                ),
                margin: const EdgeInsets.only(right: 14),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Row(children: [
                  SvgPicture.asset('assets/arrow_up.svg'),
                  if (currentMonthIncome != null && lastMonthIncome != null)
                    Text(
                      "${calculatePercentageIncrease(lastMonthIncome!, currentMonthIncome!)}%",
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

  String calculatePercentageIncrease(int lastMonth, int currentMonth) {
    final percentageIncrease = (currentMonth - lastMonth) / lastMonth * 100;
    return percentageIncrease.abs().toStringAsFixed(1);
  }
}
