import 'package:duckdb_cli/use_excel_plus.dart';
import 'package:duckdb_cli/write_xlsx.dart';


void main(List<String> arguments) {
  final sheetNames = getSheetNames('./data/functional_langs.xlsx');

  for (final sheetName in sheetNames) {
    print(sheetName);
  }
  print("Writing './data/output1.xlsx'");
  writeSheet('./data/output1.xlsx');
}

