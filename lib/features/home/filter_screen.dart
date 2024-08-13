import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:misau/app/theme/colors.dart';
import 'package:misau/features/home/home_viemodel.dart';
import 'package:misau/widget/outline_datepicker.dart';
import 'package:misau/widget/outline_dropdown.dart';

class FilterScreen extends ConsumerStatefulWidget {
  const FilterScreen({
    super.key,
  });

  @override
  ConsumerState<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends ConsumerState<FilterScreen>
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
    final homeWatch = ref.watch(homeViemodelProvider);
    final homeRead = ref.read(homeViemodelProvider.notifier);

    final appSize = MediaQuery.of(context).size;
    return Container(
        height: appSize.height * 0.7,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0))),
        child: Padding(
            padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 7,
                  ),
                  const Text(
                    "Filter",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                      color: Color(0xff1B1C1E),
                      letterSpacing: -.5,
                    ),
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
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color(0xffE9EAEB), width: 1.5),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 4.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: homeWatch.selectedState,
                        icon: SvgPicture.asset(
                          'assets/svg/arrow_dropdown.svg',
                          width: 13,
                          height: 13,
                          color: const Color(0xff121827),
                        ),
                        items: homeRead.stateModel?.map((value) {
                          return DropdownMenuItem(
                            value: value.stateCode,
                            child: Text(
                              value.name!,
                              style: const TextStyle(
                                  color: Color(0xff121827),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          homeWatch.selectedState = value;
                          homeRead.getLga(context, value!);
                        },
                      ),
                    ),
                  ),
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
                  Container(
                    height: 54.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color(0xffE9EAEB), width: 1.5),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 4.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: homeWatch.selectedLga,
                        icon: SvgPicture.asset(
                          'assets/svg/arrow_dropdown.svg',
                          width: 13,
                          height: 13,
                          color: const Color(0xff121827),
                        ),
                        items:
                            homeRead.lgaList?.asMap().entries.map((mapValue) {
                          return DropdownMenuItem(
                            value: mapValue.key.toString(),
                            child: Text(
                              mapValue.value,
                              style: const TextStyle(
                                  color: Color(0xff121827),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            onTap: () {
                              // homeWatch.selectedLga = mapValue.value;
                              setState(() {});
                            },
                          );
                        }).toList(),
                        onChanged: (value) {
                          homeWatch.selectedLga = value;
                          setState(() {});
                        },
                      ),
                    ),
                  ),
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
                  DropDownTextField(
                    controller: homeRead.searchfacilityController,
                    clearOption: true,
                    enableSearch: true,
                    clearIconProperty: IconProperty(color: black, size: 15.0),
                    searchTextStyle:
                        const TextStyle(color: black, fontSize: 15.0),
                    textFieldDecoration: InputDecoration(
                        suffixIcon: SvgPicture.asset(
                          'assets/svg/arrow_dropdown.svg',
                          width: 13,
                          height: 13,
                          color: const Color(0xff121827),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: grey50, width: 1.5),
                            borderRadius: BorderRadius.circular(12.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: black, width: 1.5),
                            borderRadius: BorderRadius.circular(12.0))),
                    searchDecoration: InputDecoration(
                        hintText: "Search facility",
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: grey50, width: 1.5),
                            borderRadius: BorderRadius.circular(5.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: grey50, width: 1.5),
                            borderRadius: BorderRadius.circular(5.0))),
                    validator: (value) {
                      if (value == null) {
                        return "Required field";
                      } else {
                        return null;
                      }
                    },
                    dropDownItemCount: 6,
                    dropDownList: homeWatch.facilitiesList!.map((value) {
                      return DropDownValueModel(name: value, value: value);
                    }).toList(),
                    onChanged: (val) {},
                  ),
                  // OutlineDropdown(options: homeRead.facilitiesList),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .4,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "From ",
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
                            OutlineDatePicker(
                              onTap: () => homeRead.selectFromDateCal(context),
                              controller: homeRead.fromDateController,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .4,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "To ",
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
                            OutlineDatePicker(
                              onTap: () => homeRead.selectToDateCal(context),
                              controller: homeRead.toDateController,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width * .4,
                          height: 48,
                          child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                side: const BorderSide(
                                  color: Color(0xff121827),
                                  width: 1.5,
                                ),
                              ),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Color(0xff121827),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ))),
                      const Spacer(),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .4,
                        height: 48,
                        child: SizedBox(
                            width: double.infinity, // Make button full width
                            child: TextButton(
                              onPressed: () {
                                context.pop();
                                homeRead.fetchWalletData(context,
                                    state: homeWatch.selectedState ?? '',
                                    lga: homeWatch.selectedLga ?? '',
                                    facilitys: homeWatch.selectedFacility ?? '',
                                    fromDate: homeWatch.fromDate ?? '',
                                    toDate: homeWatch.toDate ?? '');
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: red,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      12.0), // border radius
                                ),
                              ),
                              child: const Text(
                                "Filter",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )),
                      )
                    ],
                  ),
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
