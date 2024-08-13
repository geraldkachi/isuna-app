import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:misau/features/home/filter_screen.dart';
import 'package:misau/widget/loading_dialog.dart';

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

 static void showLoadingDialog(context) {
    showDialog(context: context, builder: (context) => LoadingDialog());
  }
}
