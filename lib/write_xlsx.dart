/*
 *  Copyright 2026 Stephen Tetley
 *
 * Use of this source code is governed by the MIT license
 * that can be found in the LICENSE.md file.
 */


import 'package:excel_plus/excel_plus.dart';
import 'package:sqlite3/sqlite3.dart';
import 'dart:io';

enum _ExcelMode { create, edit }


/// https://www.sqlite.org/datatype3.html
CellValue _makeCell(String ty, dynamic value) {
  return switch (ty.toUpperCase()) {
    'CHARACTER' || 'VARCHAR' || 'TEXT' => TextCellValue(value),
    'INT' || 'INTEGER' => IntCellValue(value),
    'REAL' || 'DOUBLE' || 'DOUBLE PRECISION' || 'FLOAT' => DoubleCellValue(value),
    _ => TextCellValue(value),
  };
}


class ExcelWorkbook {
  final String _outputPath;
  final Excel _excel;
  final _ExcelMode _mode;
  final Map<String, Iterable<({String name, String ty})>> _sheetInfo = {};

  ExcelWorkbook._(this._outputPath, this._excel, this._mode);

  factory ExcelWorkbook.attach({required String path}) {
    if (File(path).existsSync()) {
      var excel = Excel.decodeBytes(File(path).readAsBytesSync());
      return ExcelWorkbook._(path, excel, _ExcelMode.edit);
    } else {
      var excel = Excel.createExcel();
      return ExcelWorkbook._(path, excel, _ExcelMode.create);
    }
  }

  factory ExcelWorkbook.attachAs({required String templatePath, required String outPath}) { 
    Excel excel = Excel.decodeBytes(File(templatePath).readAsBytesSync());
    return ExcelWorkbook._(outPath, excel, _ExcelMode.edit);
  }

  void alterSheetName({required String oldName, required String newName}) {
    if (_excel.sheets.containsKey(oldName)) {
    _excel.rename(oldName, newName);
    }
  }

  void createNamedTable({required String sheetName, required String tableName}) {
    final sheet = _excel[sheetName];
    sheet.addTable(ExcelTable(
      name: tableName, 
      from: CellIndex.indexByString("A1"), 
      to: CellIndex.indexByColumnRow(columnIndex: sheet.maxColumns - 1, rowIndex: sheet.maxRows - 1),
      style: TableStyle.medium9));
  }


  void createSheet({required String sheetName, required Iterable<({String name, String ty})> columns}) {
    // In create mode, `Sheet1` is auto-created, the first sheet needs to rename it
    if (_excel.sheets.length == 1 && _mode == _ExcelMode.create && _excel.sheets.containsKey('Sheet1')) {
      print("createSheet renaming Sheet1...");
      _excel.rename('Sheet1', sheetName);
    }
    final sheet = _excel[sheetName];
    List<TextCellValue> cells = columns.map((col) => TextCellValue(col.name)).toList();
    sheet.appendRow(cells);
    _sheetInfo.addAll({sheetName: columns});
  }

  void dropSheetIfExists({required String sheetName}) {
    if (_excel.sheets.containsKey(sheetName)) {
      if(_excel.sheets.length > 1) {
        _excel.delete(sheetName);
      } else {
        if(sheetName == 'Sheet1') {
          Sheet _ = _excel["SheetNew"];
          _excel.delete('Sheet1');
          _excel.rename('SheetNew', 'Sheet1');
        } else {
          Sheet _ = _excel["Sheet1"];
          _excel.delete(sheetName);
        }
      } 
    }
  }

  void insertInto({required String sheetName, required ResultSet resultset}) {
    Sheet? sheet = _excel.sheets[sheetName];
    Iterable<({String name, String ty})>? cols = _sheetInfo[sheetName];
    if (sheet != null && cols != null) {
      for (final Row row in resultset) {
        final List<CellValue> cells = [];
        for (final ({String name, String ty}) record in cols) {
          var value = row[record.name];
          cells.add(_makeCell(record.ty, value));
        }
        sheet.appendRow(cells.toList());
      }
    }
  }

  void detach() {
    File(_outputPath).writeAsBytesSync(_excel.save()!);
  }

}



