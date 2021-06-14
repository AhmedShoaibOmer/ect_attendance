import 'dart:io';

import 'package:domain/domain.dart';
import 'package:excel/excel.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';

import '../../../data.dart';

class ExcelService {
  static Future<ExcelFileEntity> createAttendanceExcelFile({
    @required String fileName,
    @required List<UserEntity> students,
    @required List<LectureEntity> lectures,
    @required String directoryPath,
    String nameColumnLabel = 'Name',
    String studentIdColumnLabel = 'Student ID',
    String lectureColumnLabel = 'Lecture',
    String attendancePercentColumnLabel = 'Attendance percent',
    String excusedAbsencePercentColumnLabel = 'Excused absence percent',
    String absencePercentColumnLabel = 'Absence percent',
    String presentTextValue = 'Present',
    String absentTextValue = 'Absent',
    String excusedAbsentTextValue = 'Absent with excuse',
  }) async {
    final List<List<String>> fileRows = [];

    final List<String> fileColumns = [];

    final Excel excel = Excel.createExcel();

    final Sheet sheetObject = excel[fileName];

    excel.setDefaultSheet(fileName);

    List<String> columns = [nameColumnLabel, studentIdColumnLabel]
      ..addAll(
        List.generate(
          lectures.length,
          (index) => ' ${lectureColumnLabel + ' ' + (index + 1).toString()}',
        ),
      )
      ..addAll([
        '$attendancePercentColumnLabel (%)',
        '$excusedAbsencePercentColumnLabel (%)',
        '$absencePercentColumnLabel (%)',
      ]);

    fileColumns.addAll(columns);

    sheetObject.insertRowIterables(columns, 0);

    for (int index = 0; index < students.length; index++) {
      UserEntity student = students[index];

      int absence = 0;
      int excusedAbsence = 0;
      int attendance = 0;

      List<String> row = [
        student.name,
        student.id,
      ]..addAll(
          lectures.map((e) {
            if (e.attendeesIds.contains(student.id)) {
              attendance++;
              return presentTextValue;
            } else if (e.excusedAbsenteesIds.contains(student.id)) {
              excusedAbsence++;
              return excusedAbsentTextValue;
            } else {
              absence++;
              return absentTextValue;
            }
          }).toList(),
        );

      double absencePercent = (absence / lectures.length) * 100;
      double excusedAbsencePercent = (excusedAbsence / lectures.length) * 100;
      double attendancePercent = (attendance / lectures.length) * 100;
      row.addAll([
        attendancePercent.round().toString(),
        excusedAbsencePercent.round().toString(),
        absencePercent.round().toString(),
      ]);

      fileRows.add(row);

      sheetObject.insertRowIterables(
        row,
        index + 1,
      );
    }

    // Save the Changes in file

    var bytes = await excel.encode();

    var file = await File(join("$directoryPath/$fileName.xlsx"))
        .create(recursive: true);

    await file.writeAsBytes(bytes);

    return ExcelFileEntity(
      file.path,
      fileRows,
      fileColumns,
    );
  }

  static List<User> readUsersFromExcelFile(String filePath, bool teachersFile) {
    var bytes = File(filePath).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);

    List<User> users = [];

    for (var sheetName in excel.tables.keys) {
      print(sheetName); //sheet Name

      final sheet = excel.tables[sheetName];

      print(sheet.maxCols);
      print(sheet.maxRows);

      int nameColumnIndex = sheet.row(0).indexWhere((element) =>
          (element.value as String).toLowerCase() == 'student name' ||
          (element.value as String).toLowerCase() == 'teacher name' ||
          (element.value as String).toLowerCase() == 'name' ||
          element.value == 'الاسم' ||
          element.value == 'إسم الطالب' ||
          element.value == 'اسم الطالب' ||
          element.value == 'إسم المعلم' ||
          element.value == 'اسم المعلم' ||
          element.value == 'الإسم');

      int idColumnIndex = sheet.row(0).indexWhere((element) =>
          (element.value as String).toLowerCase() == 'student id' ||
          (element.value as String).toLowerCase() == 'teacher id' ||
          (element.value as String).toLowerCase() == 'id' ||
          element.value == 'رقم الطالب' ||
          element.value == 'الرقم الجامعي' ||
          element.value == 'الرقم' ||
          element.value == 'الرمز');

      final rows = excel.tables[sheetName].rows;
      rows.removeAt(0);

      for (var row in rows) {
        print("$row");

        users.add(
          User(
            name: row[nameColumnIndex],
            id: row[idColumnIndex].toString(),
            role: teachersFile ? 'teacher' : 'student',
          ),
        );
      }
    }

    return users;
  }
}
