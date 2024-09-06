import 'dart:io';

import 'package:excel/excel.dart';
import 'package:isuna/models/admin_model.dart';
import 'package:isuna/models/tranx_list_model.dart';
import 'package:isuna/utils/string_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ExcelService {
  Future<void> shareTransaction(List data, {String? facility}) async {
    var excel = Excel.createExcel();
    Sheet sheet = excel['Sheet1'];

    // Add headers
    sheet.appendRow([
      TextCellValue('Date Created'),
      TextCellValue('Facility'),
      TextCellValue('Category'),
      TextCellValue('Balance'),
      TextCellValue('Payment Status'),
      TextCellValue('Status')
    ]);

    // Add data
    for (Transaction item in data) {
      sheet.appendRow([
        TextCellValue('${item.createdAt}'),
        TextCellValue('${item.facility}'),
        TextCellValue('${item.facility}'),
        TextCellValue(item.income?.amount == null
            ? '₦${StringUtils.currencyConverter(double.parse(item.expense?.amount!).toInt())}'
            : '₦${StringUtils.currencyConverter(double.parse(item.income?.amount!).toInt())}'),
        TextCellValue('${item.income == null ? 'expense' : 'income'}'),
        TextCellValue('Active'),
      ]);
    }

    // Save the file
    final directory = await getApplicationDocumentsDirectory();
    String filePath =
        '${directory.path}/${facility ?? 'wallet'}_transations.xlsx';
    File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(excel.save()!);

    // Share the image
    final result = await Share.shareXFiles([XFile(filePath)]);

    if (result.status == ShareResultStatus.success) {}

    // print('Excel file saved at $filePath');
  }
}
