/*
 *  Copyright 2026 Stephen Tetley
 *
 * Use of this source code is governed by the MIT license
 * that can be found in the LICENSE.md file.
 */

import 'package:excel_plus/excel_plus.dart';
import 'dart:io';


class ExcelWorkbook {
  final String _path;
  final Excel _excel;
  int _sheetCount = 1;

  ExcelWorkbook._(this._path, this._excel);

  ExcelWorkbook.createOrReplace(this._path) : _excel = Excel.createExcel();

  factory ExcelWorkbook.editIfExists(String path) { 
    var excel = Excel.decodeBytes(File(path).readAsBytesSync());
    return ExcelWorkbook._(path, excel);
  }

  ExcelSheet addSheet(String sheetName) {
    // first sheet needs to rename `Sheet1`
    if (_sheetCount == 1) {
      _excel.rename('Sheet1', sheetName);
    }
    else {
      _sheetCount++;
    }
    final sheet = _excel[sheetName];
    return ExcelSheet(sheet: sheet);
  }

  void save() {
    File(_path).writeAsBytesSync(_excel.save()!);
  }

  void saveAs(String dest) {
    File(dest).writeAsBytesSync(_excel.save()!);
  }  
}

class ExcelSheet({required Sheet sheet}) {
  final Sheet _sheet = sheet;

  void addHeaders(Iterable<String> colNames) {
    List<TextCellValue> cells = colNames.map((col) => TextCellValue(col)).toList();
    _sheet.appendRow(cells);
  }

  void addRow(Iterable<CellValue> cells) {
    _sheet.appendRow(cells.toList());
  }
}


