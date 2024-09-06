import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isuna/features/health/faciliteies_filter_scren.dart';
import 'package:isuna/features/health/widgets/health_flag_transaction_bottom_sheet.dart';
import 'package:isuna/features/home/filter_screen.dart';
import 'package:isuna/widget/flag_transaction_bottom_sheet.dart';
import 'package:isuna/widget/loading_dialog.dart';

class Utils {
  static String formatNumber(String numberString) {
    if (numberString.isEmpty) {
      return '';
    }

    try {
      final number = double.parse(numberString);
      final formatter = NumberFormat('#,##0.##');
      return formatter.format(number);
    } catch (e) {
      return numberString; // Return the original string if parsing fails
    }
  }

  static void showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      builder: (context) {
        return const FilterScreen();
      },
    );
  }

  static void showFacilitiesFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      builder: (context) {
        return const FacilitiesFilterScreen();
      },
    );
  }

  static void showFlagTransactionBottomSheet(BuildContext context,
      [viewModelWatch, viewModelRead]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      builder: (context) {
        return FlagTransactionBottomSheet();
      },
    );
  }

    static void showHealthFlagTransactionBottomSheet(BuildContext context,
      [viewModelWatch, viewModelRead]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      builder: (context) {
        return HealthFlagTransactionBottomSheet();
      },
    );
  }

  static void showLoadingDialog(context) {
    showDialog(context: context, builder: (context) => LoadingDialog());
  }
}
