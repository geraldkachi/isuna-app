import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:misau/utils/utils.dart';
import 'package:misau/widget/custom_dropdown.dart';
import 'package:misau/widget/custom_pie_chart.dart';
import 'package:misau/widget/outline_datepicker.dart';
import 'package:misau/widget/outline_dropdown.dart';
import 'package:misau/widget/outline_textfield.dart';

class RecordExpensePayment extends StatefulWidget {
  const RecordExpensePayment({
    super.key,
  });

  @override
  State<RecordExpensePayment> createState() => _RecordExpensePaymentState();
}

class _RecordExpensePaymentState extends State<RecordExpensePayment>
    with SingleTickerProviderStateMixin {
  // List<String> options = ['Monthly', 'Weekly', 'Daily'];
  bool showGreenLine = true;
  bool showOrangeLine = true;
  TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: const Color(0xffF4F4F7),
        body: Padding(
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/svg/back.svg',
                          height: 16,
                          color: const Color(0xff1B1C1E),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        const Text(
                          "Record Expense Payment",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Color(0xff1B1C1E),
                            letterSpacing: -.5,
                          ),
                        )
                      ],
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(
                    height: 26,
                  ),
                  const Row(
                    children: [
                      Text(
                        "State ",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Color(0xff1B1C1E),
                          letterSpacing: -.5,
                        ),
                      ),
                      Text(
                        "*",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Color(0xffE03137),
                          letterSpacing: -.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  const OutlineDropdown(['Osun', 'Justin']),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    "LGA ",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Color(0xff1B1C1E),
                      letterSpacing: -.5,
                    ),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  const OutlineDropdown(['Boluwaduro']),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    "Facility ",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Color(0xff1B1C1E),
                      letterSpacing: -.5,
                    ),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  const OutlineDropdown(['Afao Primary Health Clinic']),
                  const SizedBox(
                    height: 13,
                  ),
                  const Text(
                    "Expense",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                      color: Color(0xff1B1C1E),
                      letterSpacing: -.5,
                    ),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xffE9EAEB),
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Category",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Color(0xff1B1C1E),
                              letterSpacing: -.5,
                            ),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          const OutlineDropdown(['Training - General']),
                          const SizedBox(
                            height: 7,
                          ),
                          const Text(
                            "Sub Category",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Color(0xff1B1C1E),
                              letterSpacing: -.5,
                            ),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          const OutlineDropdown(['Local Training']),
                          const SizedBox(
                            height: 7,
                          ),
                          const Row(
                            children: [
                              Text(
                                "Title ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: Color(0xff1B1C1E),
                                  letterSpacing: -.5,
                                ),
                              ),
                              Text(
                                "*",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Color(0xffE03137),
                                  letterSpacing: -.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          OutlineTextField(
                              controller: titleController,
                              hintText: 'Enter Title'),
                          const SizedBox(
                            height: 7,
                          ),
                          const Row(
                            children: [
                              Text(
                                "Date ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: Color(0xff1B1C1E),
                                  letterSpacing: -.5,
                                ),
                              ),
                              Text(
                                "*",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Color(0xffE03137),
                                  letterSpacing: -.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          const OutlineDatePicker(),
                          const SizedBox(
                            height: 7,
                          ),
                          const Row(
                            children: [
                              Text(
                                "Amount ",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: Color(0xff1B1C1E),
                                  letterSpacing: -.5,
                                ),
                              ),
                              Text(
                                "*",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Color(0xffE03137),
                                  letterSpacing: -.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          OutlineTextField(
                              controller: titleController,
                              hintText: 'Enter Amount',
                              isNumeric: true),
                          const SizedBox(
                            height: 13,
                          ),
                          Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: const Color(0xffE9EAEB), width: 1.5),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Total Balance",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Color(0xff1B1C1E),
                                      letterSpacing: -.5,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    Utils.formatNumber("12456315"),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20,
                                      color: Color(0xff1B1C1E),
                                      letterSpacing: -.5,
                                    ),
                                  )
                                ],
                              )),
                        ],
                      )),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                      width: double.infinity, // Make button full width
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 18.0, horizontal: 10.0),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12.0), // border radius
                          ),
                          // primary: const red, // background color
                        ),
                        child: const Text(
                          "Record Payment",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            )));
  }

  Widget _buildTab(String text) {
    return Tab(
      text: text,
      height: 38,
    );
  }
}
