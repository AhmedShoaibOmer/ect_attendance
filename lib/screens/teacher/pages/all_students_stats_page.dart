import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../generated/l10n.dart';

class AllStudentsStatsPage extends StatefulWidget {
  final ExcelFileEntity excelFileEntity;
  final String fileName;

  AllStudentsStatsPage(
      {Key key, @required this.fileName, @required this.excelFileEntity})
      : super(key: key);

  @override
  _AllStudentsStatsPageState createState() => _AllStudentsStatsPageState();

  static route({
    String fileName,
    ExcelFileEntity excelFileEntity,
  }) {
    return MaterialPageRoute(
      builder: (context) {
        return ChangeNotifierProvider(
          create: (c) => StudentDataNotifier(),
          child: AllStudentsStatsPage(
            fileName: fileName,
            excelFileEntity: excelFileEntity,
          ),
        );
      },
    );
  }
}

class _AllStudentsStatsPageState extends State<AllStudentsStatsPage> {
  StudentsDataSource dataSource;

  @override
  void initState() {
    super.initState();
    dataSource = StudentsDataSource(widget.excelFileEntity.rows);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.excelFileEntity.filePath);
    print(widget.fileName);
    final _provider = context.watch<StudentDataNotifier>();
    return Scaffold(
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PaginatedDataTable(
              availableRowsPerPage: [
                dataSource.rows.length,
                PaginatedDataTable.defaultRowsPerPage,
              ],
              onRowsPerPageChanged: (index) => _provider.rowsPerPage = index,
              rowsPerPage:
                  dataSource.rows.length < PaginatedDataTable.defaultRowsPerPage
                      ? dataSource.rows.length
                      : _provider.rowsPerPage,
              columns: List.generate(
                widget.excelFileEntity.columns.length,
                (index) {
                  final columns = widget.excelFileEntity.columns;
                  return DataColumn(
                    label: Text(
                      columns[index],
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  );
                },
              ),
              source: dataSource,
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: BackButton(
        color: Theme.of(context).primaryColor,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      actions: [buildPopupMenuButton(context)],
      title: Text(
        S.of(context).all_students_stats,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  PopupMenuButton<int> buildPopupMenuButton(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(
        Icons.more_vert,
        color: Theme.of(context).primaryColor,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.all(
          Radius.circular(10),
        ),
      ),
      onSelected: (v) => Share.shareFiles([widget.excelFileEntity.filePath]),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        PopupMenuItem<int>(
          value: 0,
          child: Row(
            children: [
              Icon(
                Icons.share,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: Text(
                  S.of(context).share_as_excel,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class StudentsDataSource extends DataTableSource {
  final List<List<String>> rows;

  StudentsDataSource(this.rows);

  @override
  DataRow getRow(int index) {
    if (index >= rows.length) {
      return null;
    }
    final row = rows[index];
    return DataRow.byIndex(
        index: index,
        cells: row
            .map(
              (e) => DataCell(
                Text(e),
              ),
            )
            .toList());
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => rows.length;

  @override
  int get selectedRowCount => 0;
}

class StudentDataNotifier with ChangeNotifier {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  int get rowsPerPage => _rowsPerPage;

  set rowsPerPage(int rowsPerPage) {
    _rowsPerPage = rowsPerPage;
    notifyListeners();
  }
}
