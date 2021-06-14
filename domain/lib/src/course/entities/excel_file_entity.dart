import 'package:equatable/equatable.dart';

class ExcelFileEntity extends Equatable {
  final String filePath;
  final List<dynamic> columns;
  final List<List<dynamic>> rows;

  ExcelFileEntity(this.filePath, this.rows, this.columns);

  @override
  List<Object> get props => [
        filePath,
        rows,
        columns,
      ];
}
