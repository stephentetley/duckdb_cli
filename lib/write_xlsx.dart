/*
 *  Copyright 2026 Stephen Tetley
 *
 * Use of this source code is governed by the MIT license
 * that can be found in the LICENSE.md file.
 */

import 'package:excel_plus/excel_plus.dart';
import 'dart:io';


class ExcelWorkbook {
  String path;
  final excel = Excel.createExcel();
  int _sheetCount = 1;

  ExcelWorkbook(this.path);

  ExcelSheet addSheet(String sheetName) {
    // first sheet needs to rename `Sheet1`
    if (_sheetCount == 1) {
      excel.rename('Sheet1', sheetName);
    }
    else {
      _sheetCount++;
    }
    final sheet = excel[sheetName];
    return ExcelSheet(sheet: sheet);
  }

  void save() {
    File(path).writeAsBytesSync(excel.save()!);
  }
}

class ExcelSheet({required Sheet sheet}) {
  final Sheet _sheet = sheet;

  void addHeaders(Iterable<String> colNames) {
    for (final (ix, item) in colNames.indexed) {
      _sheet.updateCell(CellIndex.indexByColumnRow(columnIndex: ix, rowIndex: 0), TextCellValue(item));
    }
  }
}


