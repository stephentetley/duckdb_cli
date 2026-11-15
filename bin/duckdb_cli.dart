import 'package:duckdb_cli/xlsx_cli.dart';

void main(List<String> arguments) async {
  print("> dart test");

  tableToJson(
    path: './output/telemetry2.xlsx',
    sheetName: 'Telemetry Outstations',
    tableName: 'Outstations',
    outPath: './output/telemetry2_outstations_table.json',
  );
}

