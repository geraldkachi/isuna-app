import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:misau/utils/utils.dart';
import 'package:misau/widget/custom_dropdown.dart';
import 'package:misau/widget/custom_pie_chart.dart';
import 'package:misau/widget/outline_datepicker.dart';
import 'package:misau/widget/outline_dropdown.dart';
import 'package:misau/widget/outline_textfield.dart';

class RecordInflowPayment extends StatefulWidget {
  const RecordInflowPayment({
    super.key,
  });

  @override
  State<RecordInflowPayment> createState() => _RecordInflowPaymentState();
}

class _RecordInflowPaymentState extends State<RecordInflowPayment>
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
                          'assets/back.svg',
                          height: 16,
                          color: Color(0xff1B1C1E),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        const Text(
                          "Record Inflow Payment",
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
                  Row(
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
                  SizedBox(
                    height: 7,
                  ),
                  OutlineDropdown(['Osun', 'Justin']),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    "LGA ",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Color(0xff1B1C1E),
                      letterSpacing: -.5,
                    ),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  OutlineDropdown(['Boluwaduro']),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    "Facility ",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Color(0xff1B1C1E),
                      letterSpacing: -.5,
                    ),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  OutlineDropdown(['Afao Primary Health Clinic']),
                  SizedBox(
                    height: 13,
                  ),
                  Text(
                    "Inflow",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                      color: Color(0xff1B1C1E),
                      letterSpacing: -.5,
                    ),
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
                          Text(
                            "Category",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Color(0xff1B1C1E),
                              letterSpacing: -.5,
                            ),
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          OutlineDropdown(['Training - General']),
                          SizedBox(
                            height: 7,
                          ),
                          Text(
                            "Sub Category",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Color(0xff1B1C1E),
                              letterSpacing: -.5,
                            ),
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          OutlineDropdown(['Local Training']),
                          SizedBox(
                            height: 7,
                          ),
                          Row(
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
                          SizedBox(
                            height: 7,
                          ),
                          OutlineTextField(
                              controller: titleController,
                              hintText: 'Enter Title'),
                          SizedBox(
                            height: 7,
                          ),
                          Row(
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
                          SizedBox(
                            height: 7,
                          ),
                          OutlineDatePicker(),
                          SizedBox(
                            height: 7,
                          ),
                          Row(
                            children: [
                              Text(
                                "Amount ",
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
                          SizedBox(
                            height: 7,
                          ),
                          OutlineTextField(
                              controller: titleController,
                              hintText: 'Enter Amount',
                              isNumeric: true),
                          SizedBox(
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
                                  Text(
                                    "Total Balance",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Color(0xff1B1C1E),
                                      letterSpacing: -.5,
                                    ),
                                  ),
                                  SizedBox(
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
                          primary: const Color(0xffDC1C3D), // background color
                        ),
                        child: const Text(
                          "Record ",
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
