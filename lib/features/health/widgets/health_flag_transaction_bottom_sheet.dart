import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:isuna/app/theme/colors.dart';
import 'package:isuna/features/health/health_facilities_view_model.dart';
import 'package:isuna/features/home/home_viemodel.dart';
import 'package:isuna/utils/string_utils.dart';
import 'package:isuna/utils/validator.dart';
import 'package:isuna/widget/outline_textfield.dart';

class HealthFlagTransactionBottomSheet extends ConsumerStatefulWidget {
  HealthFlagTransactionBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<HealthFlagTransactionBottomSheet> createState() =>
      _HealthFlagTransactionBottomSheetState();
}

class _HealthFlagTransactionBottomSheetState
    extends ConsumerState<HealthFlagTransactionBottomSheet> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final facilitiesWatch = ref.watch(healthFacilitiesViemodelProvider);
    final facilitiesRead = ref.read(healthFacilitiesViemodelProvider.notifier);

    final income = facilitiesWatch.selectedTransaction?.income;
    final expense = facilitiesWatch.selectedTransaction?.expense;

    final appSize = MediaQuery.of(context).size;
    return Container(
      height: appSize.height * facilitiesWatch.bottomSheetHeight,
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
                onPressed: () {
                  context.pop();
                  facilitiesRead.clearFlagBottomSheetFields();
                },
                icon: Icon(
                  Icons.close,
                  size: 20.0,
                )),
          ),
          Row(
            children: [
              Text(
                'State: ',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.0),
              ),
              SizedBox(
                width: 30.0,
              ),
              Text('${facilitiesWatch.selectedTransaction?.state}',
                  style:
                      TextStyle(fontWeight: FontWeight.w400, fontSize: 15.0)),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              Text(
                'LGA: ',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.0),
              ),
              SizedBox(
                width: 43.0,
              ),
              Text('${facilitiesWatch.selectedTransaction?.lga}',
                  style:
                      TextStyle(fontWeight: FontWeight.w400, fontSize: 15.0)),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              Text(
                'Facility: ',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.0),
              ),
              SizedBox(
                width: 20.0,
              ),
              Text('${facilitiesWatch.selectedTransaction?.facility}',
                  style:
                      TextStyle(fontWeight: FontWeight.w400, fontSize: 15.0)),
            ],
          ),
          SizedBox(
            height: 30.0,
          ),
          Text('Transaction',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20.0)),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15.0)),
                  Text(
                      '${DateFormat("dd-MM-yyyy").format(facilitiesWatch.selectedTransaction!.createdAt!)}',
                      style: TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 15.0))
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Amount',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15.0)),
                  Row(
                    children: [
                      Text('₦',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15.0,
                              fontFamily: 'AreaNeu')),
                      Text(
                          '${income?.amount != null ? StringUtils.currencyConverter(income?.amount is String ? int.parse(income?.amount) : double.parse(income?.amount).toInt()) : StringUtils.currencyConverter(expense?.amount is String ? double.parse(expense?.amount).toInt() : expense?.amount.toInt())}',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 15.0)),
                    ],
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Type',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15.0)),
                  Text('${income == null ? 'Expense' : 'Income'}',
                      style: TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 15.0))
                ],
              )
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          facilitiesWatch.isStatusWidget
              ? Text(income?.status != null
                  ? 'Transaction was ${facilitiesWatch.isResolved ? 'resolved' : 'flagged'} by ${income?.log?[0].firstName} ${income?.log?[0].lastName} \n Reason: ${income?.reason}'
                  : 'Transaction was ${facilitiesWatch.isResolved ? 'resolved' : 'flagged'} by ${expense?.log?[0].firstName} ${expense?.log?[0].lastName} \n Reason: ${expense?.reason}')
              : SizedBox.shrink(),
          // statusDropdown!,
          const SizedBox(
            height: 10.0,
          ),
          facilitiesWatch.isReasonVisible
              ? Row(
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
                )
              : SizedBox.shrink(),
          SizedBox(
            height: facilitiesWatch.isReasonVisible ? 7.0 : 0.0,
          ),
          facilitiesWatch.isReasonVisible
              ? OutlineTextField(
                  controller: facilitiesWatch.reasonController,
                  hintText: 'Reason',
                  maxLines: 4,
                  isNumeric: true)
              : SizedBox.shrink(),
          // const Spacer(),
          SizedBox(
            height: 15.0,
          ),
          facilitiesWatch.isResolved
              ? SizedBox.shrink()
              : !facilitiesWatch.isStatusWidget
                  ? FlagButtons(
                      facilitiesRead: facilitiesRead,
                      facilitiesWatch: facilitiesWatch,
                      flagLabel: 'Flag',
                      onStatusChange: () {
                        facilitiesRead.flagTransaction(context, 'flagged');
                      },
                    )
                  : FlagButtons(
                      facilitiesRead: facilitiesRead,
                      facilitiesWatch: facilitiesWatch,
                      flagLabel: 'Resolve',
                      onStatusChange: () {
                        facilitiesRead.flagTransaction(context, 'resolved');
                      },
                    ),
          const SizedBox(
            height: 30.0,
          ),
        ],
      ),
    );
  }

  Column StatusDropdown(HomeViemodel facilitiesWatch) {
    return Column(
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
          value: facilitiesWatch.statusValue?.toLowerCase(),
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
          items: ['', 'Flagged', 'Resolved']
              .map<DropdownMenuItem<String>>((value) {
            return DropdownMenuItem<String>(
              value: value.toLowerCase(),
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
              facilitiesWatch.statusValue = newValue!;
              newValue == 'flagged'
                  ? facilitiesWatch.isReasonVisible = true
                  : facilitiesWatch.isReasonVisible = false;
            });
          },
        ),
      ],
    );
  }
}

class FlagButtons extends StatelessWidget {
  const FlagButtons(
      {super.key,
      required this.facilitiesRead,
      required this.facilitiesWatch,
      this.flagLabel,
      this.onStatusChange});

  final HealthFacilitiesViewModel facilitiesRead;
  final HealthFacilitiesViewModel facilitiesWatch;
  final String? flagLabel;
  final VoidCallback? onStatusChange;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 48.0,
            child: TextButton(
              onPressed: () {
                facilitiesRead.deleteTransaction(context);
              },
              style: TextButton.styleFrom(
                backgroundColor: red,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0), // border radius
                ),
              ),
              child: facilitiesWatch.isDeleted
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.0,
                      ),
                    )
                  : const Text(
                      "Delete",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: SizedBox(
            height: 48.0,
            child: OutlinedButton(
                onPressed: onStatusChange,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  side: const BorderSide(
                    color: Color(0xff121827),
                    width: 1.5,
                  ),
                ),
                child: facilitiesWatch.isStatus
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: black,
                          strokeWidth: 2.0,
                        ),
                      )
                    : Text(
                        flagLabel!,
                        style: TextStyle(
                          color: Color(0xff121827),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      )),
          ),
        ),
      ],
    );
  }
}
