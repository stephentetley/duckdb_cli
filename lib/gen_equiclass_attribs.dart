/*
 *  Copyright 2026 Stephen Tetley
 *
 * Use of this source code is governed by the MIT license
 * that can be found in the LICENSE.md file.
 */

// Output - create one multilayer Excel file

import 'package:excel_plus/excel_plus.dart';
import 'dart:io';

class TableHeaders {
  final Iterable<String> _headers;
  
  new(this._headers);

  void writeHeaders(Sheet sheet) {
    for (final (ix, item) in _headers.indexed) {
      sheet.updateCell(CellIndex.indexByColumnRow(columnIndex: ix, rowIndex: 0), TextCellValue(item));
    }
  }
  
}

class SheetTable({required String sheetName, required Iterable<String> headers}) {
  final String _sheetName = sheetName;
  final TableHeaders _headers = TableHeaders(headers);

  void writeSheet(Excel excel) {
    final sheet = excel[_sheetName];
    _headers.writeHeaders(sheet);
  }


}

void createXlsx(String path) {
  final excel = Excel.createExcel();
  // first sheet needs to rename `Sheet1`
  final outstations = SheetTable(
      sheetName: 'Telemetry Outstation',
      headers: ['Temp ID', 'Description', 'Manufacturer', 'Model', 'Outstation Address']);

  excel.rename('Sheet1', outstations._sheetName);
  outstations.writeSheet(excel);

  final modems = SheetTable(
      sheetName: 'Modem',
      headers: ['Temp ID', 'Description', 'Manufacturer', 'Model', 'IP Address']);
  modems.writeSheet(excel);

  File(path).writeAsBytesSync(excel.save()!);
}
