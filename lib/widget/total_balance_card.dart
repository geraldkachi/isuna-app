import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isuna/app/theme/colors.dart';
import 'package:isuna/features/home/home_viemodel.dart';
import 'package:isuna/utils/string_utils.dart';

class TotalBalanceCard extends ConsumerWidget {
  final dynamic totalBalance;
  final dynamic actualBalance;
  final dynamic pendingBalance;

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
                "Book Balance ",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                  color: Color(0xff1B1C1E),
                  letterSpacing: -.5,
                ),
              ),
              const SizedBox(width: 3),
              Tooltip(
                  richMessage: TextSpan(text: 'Book Balance:  \n', children: [
                    TextSpan(
                        text: 'Actual Balance: Total inflow - Total Expense')
                  ]),
                  child: SvgPicture.asset('assets/svg/info_circle.svg')),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              homeWatch.hideAmounts
                  ? Text(
                      "****",
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 34,
                        color: Color(0xff1B1C1E),
                        letterSpacing: -.5,
                      ),
                    )
                  : Row(
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
                          "${StringUtils.currencyConverter(totalBalance?.toInt() ?? 0)} ",
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
              InkWell(
                  onTap: () {
                    homeRead.toggleAmountVisibility();
                  },
                  child: SvgPicture.asset(
                    homeWatch.hideAmounts
                        ? 'assets/svg/view-off-slash-stroke-rounded.svg'
                        : 'assets/svg/view-stroke-rounded.svg',
                    height: 20.0,
                    colorFilter: ColorFilter.mode(black500, BlendMode.srcIn),
                  )),
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
                  homeWatch.hideAmounts
                      ? Text(
                          "****",
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 20.0,
                            color: Color(0xff29AB95),
                          ),
                        )
                      : Row(
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
                                  : "${StringUtils.currencyConverter(actualBalance?.toInt() ?? 0)}",
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
                crossAxisAlignment: CrossAxisAlignment.end,
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
                  homeWatch.hideAmounts
                      ? Text(
                          "****",
                          style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 17.0,
                              color: Color(0xffDC1D3C),
                              fontFamily: 'AreaNeu'),
                        )
                      : Row(
                          children: [
                            // Text(
                            //   '₦',
                            //   style: const TextStyle(
                            //       fontWeight: FontWeight.w900,
                            //       fontSize: 17.0,
                            //       color: Color(0xffDC1D3C),
                            //       fontFamily: 'AreaNeu'),
                            // ),
                            Text(
                              pendingBalance,
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
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Number of Facilities",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12.8,
                      color: Color(0xff1B1C1E),
                      letterSpacing: -.5,
                    ),
                  ),
                  Text(
                    "${homeWatch.balances.totalFacilities} ",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 20.0,
                      color: Color(0xff1B1C1E),
                      letterSpacing: -.5,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "States",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12.8,
                      color: Color(0xff1B1C1E),
                      letterSpacing: -.5,
                    ),
                  ),
                  Text(
                    "${homeWatch.balances.totalState} ",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 20.0,
                      color: Color(0xff1B1C1E),
                      letterSpacing: -.5,
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
