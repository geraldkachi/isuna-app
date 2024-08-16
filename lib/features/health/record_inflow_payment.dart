import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:misau/app/theme/colors.dart';
import 'package:misau/features/health/health_facilities_view_model.dart';
import 'package:misau/utils/utils.dart';
import 'package:misau/utils/validator.dart';
import 'package:misau/widget/custom_dropdown.dart';
import 'package:misau/widget/custom_pie_chart.dart';
import 'package:misau/widget/outline_datepicker.dart';
import 'package:misau/widget/outline_dropdown.dart';
import 'package:misau/widget/outline_textfield.dart';

class RecordInflowPayment extends ConsumerStatefulWidget {
  const RecordInflowPayment({
    super.key,
  });

  @override
  ConsumerState<RecordInflowPayment> createState() =>
      _RecordInflowPaymentState();
}

class _RecordInflowPaymentState extends ConsumerState<RecordInflowPayment>
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
    final facilitiesWatch = ref.watch(healthFacilitiesViemodelProvider);
    final facilitiesRead = ref.read(healthFacilitiesViemodelProvider.notifier);
    final appSize = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: const Color(0xffF4F4F7),
        body: Padding(
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
            child: Form(
              key: facilitiesWatch.inFlowFormKey,
              autovalidateMode: AutovalidateMode.always,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Status",
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
                      DropdownButtonFormField<String>(
                        value: facilitiesWatch.inflowStatusValue,
                        validator: (value) => Validator.validateField(value),
                        decoration: InputDecoration(
                          hintText: 'Select status',
                          hintStyle: TextStyle(
                            color: Color(0xff121827).withOpacity(0.4),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                              color: grey100,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                              color: grey100,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                              color: black,
                              width: 1.0,
                            ),
                          ),
                        ),
                        icon: SvgPicture.asset(
                          'assets/svg/arrow_dropdown.svg',
                          width: 13,
                          height: 13,
                          color: const Color(0xff121827),
                        ),
                        items: ['Flagged', 'Resolved'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                  color: Color(0xff121827),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            facilitiesWatch.inflowStatusValue = newValue!;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      const Row(
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
                      const SizedBox(
                        height: 7,
                      ),
                      TextFormField(
                        controller: facilitiesWatch.inflowAmountContoller,
                        keyboardType: TextInputType.number,
                        validator: (value) => Validator.validateField(value),
                        decoration: InputDecoration(
                          hintText: 'Enter amount',
                          hintStyle: TextStyle(
                            color: Color(0xff121827).withOpacity(0.4),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                              color: grey100,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                              color: grey100,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                              color: black,
                              width: 1.0,
                            ),
                          ),
                        ),
                        style: const TextStyle(
                          color: Color(0xff121827),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                  Spacer(),
                  SizedBox(
                      height: 48.0,
                      width: double.infinity, // Make button full width
                      child: TextButton(
                        onPressed: () {
                          facilitiesRead.addInflowPayment(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: red,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12.0), // border radius
                          ),
                        ),
                        child: const Text(
                          "Add Payment ",
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
}
