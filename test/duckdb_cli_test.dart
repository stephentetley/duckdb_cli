import 'package:duckdb_cli/write_xlsx.dart';
import 'package:duckdb_cli/output_xlsx.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:excel_plus/excel_plus.dart';
import 'dart:io';

void main() {
  createXlsx(
    dbPath: "./data/new_simple_equi.sqlite",
    xlsxTemplate: "./data/AIW_Equi_Creation_Template_V1.0.xlsx",
    outPath: "./output/uploader_EQUI_CREATE.xlsx"
  );
  modifyTemplate(
    xlsxTemplate: "./data/AIW_Equi_Creation_Template_V1.0.xlsx",
    outPath: "./output/uploader_EQUI_CREATE_edit1.xlsx"
  );
}


void createXlsx({required String dbPath, required String xlsxTemplate, required String outPath}) {
  if (File(outPath).existsSync()) {
    File(outPath).deleteSync();
  }
  final db = sqlite3.open(dbPath);
  final wb = ExcelWorkbook.attachAs(outPath: outPath, templatePath: xlsxTemplate);
  appendSQLiteTableToExistingSheet('equi_create_equipment_data', db, wb, 'EQ-Equipment Data');
  wb.detach();
  db.close();
}


void modifyTemplate({required String xlsxTemplate, required String outPath}) {
  if (File(outPath).existsSync()) {
    File(outPath).deleteSync();
  }
  final excel = Excel.decodeBytes(File(xlsxTemplate).readAsBytesSync());
  final sheet = excel['Change Request Header'];
  final cell = sheet.cell(CellIndex.indexByString('B5'));
  print("B5 is `${cell.value}`");

  sheet.updateCell(CellIndex.indexByString('B6'), TextCellValue('Outstations (SPT) 14.11.26'));
  
  File(outPath).writeAsBytesSync(excel.save()!);
  
}
