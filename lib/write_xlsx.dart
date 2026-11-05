import 'package:excel_plus/excel_plus.dart';
import 'dart:io';

void writeSheet(String path) {
  final excel = Excel.createExcel();
  final sheet = excel['Sheet1'];

  sheet.updateCell(CellIndex.indexByString('A1'), TextCellValue('Batch Number'));

  File(path).writeAsBytesSync(excel.save()!);

}
