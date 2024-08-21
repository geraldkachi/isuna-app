import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:isuna/app/theme/colors.dart';
import 'package:isuna/features/health/health_facilities_view_model.dart';
import 'package:isuna/utils/utils.dart';
import 'package:isuna/utils/validator.dart';
import 'package:isuna/widget/custom_dropdown.dart';
import 'package:isuna/widget/custom_pie_chart.dart';
import 'package:isuna/widget/outline_datepicker.dart';
import 'package:isuna/widget/outline_dropdown.dart';
import 'package:isuna/widget/outline_textfield.dart';

class RecordExpensePayment extends ConsumerStatefulWidget {
  const RecordExpensePayment({
    super.key,
  });

  @override
  ConsumerState<RecordExpensePayment> createState() =>
      _RecordExpensePaymentState();
}

class _RecordExpensePaymentState extends ConsumerState<RecordExpensePayment>
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
            child: SingleChildScrollView(
              child: Form(
                key: facilitiesWatch.expenseFormKey,
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
                      onTap: () {
                        context.pop();
                        facilitiesRead.clearExpenseFields();
                      },
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Column(
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
                        DropdownButtonFormField<String>(
                          value: facilitiesWatch.selectedCategory,
                          validator: (value) => Validator.validateField(value),
                          decoration: InputDecoration(
                            hintText: 'Select Category',
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
                          items: facilitiesWatch.categoriesModel
                              .map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem<String>(
                              value: value.name,
                              child: SizedBox(
                                width: 300.0,
                                child: Text(
                                  value.name!,
                                  style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: Color(0xff121827),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              facilitiesWatch.selectedCategory = newValue!;
                              facilitiesWatch.selectedSubCategory = null;
                            });
                          },
                        ),
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
                        DropdownButtonFormField<String>(
                          value: facilitiesWatch.selectedSubCategory,
                          validator: (value) => Validator.validateField(value),
                          decoration: InputDecoration(
                            hintText: 'Select Sub category',
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
                          items: facilitiesWatch.selectedCategory != null
                              ? facilitiesWatch.categoriesModel
                                  .firstWhere(
                                    (category) =>
                                        category.name ==
                                        facilitiesWatch.selectedCategory,
                                  )
                                  .subCategory!
                                  .map<DropdownMenuItem<String>>((value) {
                                  return DropdownMenuItem<String>(
                                    value: value.name,
                                    child: SizedBox(
                                      width: 300.0,
                                      child: Text(
                                        value.name!,
                                        style: const TextStyle(
                                            color: Color(0xff121827),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    onTap: () {
                                      // setState(() {
                                      //   facilitiesWatch.selectedSubCategory =
                                      //       value.value.name!;
                                      // });
                                    },
                                  );
                                }).toList()
                              : [],
                          onChanged: (newValue) {
                            setState(() {
                              facilitiesWatch.selectedSubCategory = newValue!;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        // const Text(
                        //   "Status",
                        //   style: TextStyle(
                        //     fontWeight: FontWeight.w500,
                        //     fontSize: 15,
                        //     color: Color(0xff1B1C1E),
                        //     letterSpacing: -.5,
                        //   ),
                        // ),
                        // const SizedBox(
                        //   height: 7,
                        // ),
                        // DropdownButtonFormField<String>(
                        //   value: facilitiesWatch.expenseStatusValue,
                        //   validator: (value) => Validator.validateField(value),
                        //   decoration: InputDecoration(
                        //     hintText: 'Select status',
                        //     hintStyle: TextStyle(
                        //       color: Color(0xff121827).withOpacity(0.4),
                        //       fontSize: 16,
                        //       fontWeight: FontWeight.w600,
                        //     ),
                        //     border: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(12.0),
                        //       borderSide: const BorderSide(
                        //         color: grey100,
                        //         width: 1.0,
                        //       ),
                        //     ),
                        //     enabledBorder: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(12.0),
                        //       borderSide: const BorderSide(
                        //         color: grey100,
                        //         width: 1.0,
                        //       ),
                        //     ),
                        //     focusedBorder: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(12.0),
                        //       borderSide: const BorderSide(
                        //         color: black,
                        //         width: 1.0,
                        //       ),
                        //     ),
                        //   ),
                        //   icon: SvgPicture.asset(
                        //     'assets/svg/arrow_dropdown.svg',
                        //     width: 13,
                        //     height: 13,
                        //     color: const Color(0xff121827),
                        //   ),
                        //   items: ['Flagged', 'Resolved']
                        //       .map<DropdownMenuItem<String>>((value) {
                        //     return DropdownMenuItem<String>(
                        //       value: value,
                        //       child: Text(
                        //         value,
                        //         style: const TextStyle(
                        //             color: Color(0xff121827),
                        //             fontSize: 16,
                        //             fontWeight: FontWeight.w600),
                        //       ),
                        //     );
                        //   }).toList(),
                        //   onChanged: (newValue) {
                        //     setState(() {
                        //       facilitiesWatch.expenseStatusValue = newValue!;
                        //       newValue == 'Flagged'
                        //           ? facilitiesWatch.isReasonVisible = true
                        //           : facilitiesWatch.isReasonVisible = false;
                        //     });
                        //   },
                        // ),
                        // const SizedBox(
                        //   height: 7,
                        // ),
                        facilitiesWatch.isReasonVisible
                            ? Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Reason ",
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
                                ],
                              )
                            : SizedBox.shrink(),
                        facilitiesWatch.isReasonVisible
                            ? OutlineTextField(
                                controller: titleController,
                                hintText: 'Reason',
                                maxLines: 4,
                                isNumeric: true)
                            : SizedBox.shrink(),
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
                        const SizedBox(
                          height: 7,
                        ),
                        OutlineTextField(
                            controller: facilitiesWatch.expenseAmountContoller,
                            hintText: 'Enter Amount',
                            isNumeric: true),
                        const SizedBox(
                          height: 13,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                        height: 48.0,
                        width: double.infinity, // Make button full width
                        child: ElevatedButton(
                          onPressed: () {
                            facilitiesRead.addExpensePayment(context);
                            facilitiesRead.clearExpenseFields();
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: red,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12.0), // border radius
                            ),
                            // primary: const red, // background color
                          ),
                          child: const Text(
                            "Add Payment",
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
