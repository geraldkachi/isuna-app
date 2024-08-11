import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:misau/features/home/home_viemodel.dart';
import 'package:misau/utils/string_utils.dart';

class TotalBalanceCard extends ConsumerWidget {
  final int? totalBalance;
  final int? actualBalance;
  final int? pendingBalance;

  const TotalBalanceCard({
    Key? key,
    required this.totalBalance,
    required this.actualBalance,
    required this.pendingBalance,
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
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
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
              const SizedBox(width: 3),
              SvgPicture.asset('assets/svg/info_circle.svg'),
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
                        fontSize: 28,
                        color: Color(0xff1B1C1E),
                        fontFamily: 'AreaNeu'),
                  ),
                  Text(
                    "${StringUtils.currencyConverter(totalBalance ?? 0)} ",
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Actual Balance ",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12.8,
                      color: Color(0xff1B1C1E),
                      letterSpacing: -.5,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '₦',
                        style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 17.0,
                            color: Color(0xff29AB95),
                            fontFamily: 'AreaNeu'),
                      ),
                      Text(
                        homeWatch.isLoading
                            ? '0'
                            : "${StringUtils.currencyConverter(actualBalance ?? 0)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                          color: Color(0xff29AB95),
                          letterSpacing: -.5,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Pending Transactions",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12.8,
                      color: Color(0xff1B1C1E),
                      letterSpacing: -.5,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '₦',
                        style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 17.0,
                            color: Color(0xffDC1D3C),
                            fontFamily: 'AreaNeu'),
                      ),
                      Text(
                        homeWatch.isLoading
                            ? '0'
                            : "${StringUtils.currencyConverter(pendingBalance ?? 0)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                          color: Color(0xffDC1D3C),
                          letterSpacing: -.5,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
