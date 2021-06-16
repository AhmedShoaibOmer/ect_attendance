// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();

  static S current;

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();

      return S.current;
    });
  }

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `ECT Attendance`
  String get app_name {
    return Intl.message(
      'ECT Attendance',
      name: 'app_name',
      desc: '',
      args: [],
    );
  }

  /// `Date & Time`
  String get date_and_time {
    return Intl.message(
      'Date & Time',
      name: 'date_and_time',
      desc: '',
      args: [],
    );
  }

  /// `Pick the date & time for the lecture`
  String get date_and_time_hint {
    return Intl.message(
      'Pick the date & time for the lecture',
      name: 'date_and_time_hint',
      desc: '',
      args: [],
    );
  }

  /// `Admin`
  String get admin {
    return Intl.message(
      'Admin',
      name: 'admin',
      desc: '',
      args: [],
    );
  }

  /// `Teacher`
  String get teacher {
    return Intl.message(
      'Teacher',
      name: 'teacher',
      desc: '',
      args: [],
    );
  }

  /// `Student`
  String get student {
    return Intl.message(
      'Student',
      name: 'student',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get welcome {
    return Intl.message(
      'Welcome',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Scan Lecture Code`
  String get scan_lecture_code {
    return Intl.message(
      'Scan Lecture Code',
      name: 'scan_lecture_code',
      desc: '',
      args: [],
    );
  }

  /// `You need to be connected to the internet to complete this process.`
  String get no_connection_error {
    return Intl.message(
      'You need to be connected to the internet to complete this process.',
      name: 'no_connection_error',
      desc: '',
      args: [],
    );
  }

  /// `Operation Succeeded`
  String get operation_succeeded {
    return Intl.message(
      'Operation Succeeded',
      name: 'operation_succeeded',
      desc: '',
      args: [],
    );
  }

  /// `Operation failed, please try again.`
  String get operation_failed {
    return Intl.message(
      'Operation failed, please try again.',
      name: 'operation_failed',
      desc: '',
      args: [],
    );
  }

  /// `You have successfully registered for the lecture`
  String get lecture_registered {
    return Intl.message(
      'You have successfully registered for the lecture',
      name: 'lecture_registered',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message(
      'Done',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `Failed to register your attendance, please try again.`
  String get lecture_registration_failed {
    return Intl.message(
      'Failed to register your attendance, please try again.',
      name: 'lecture_registration_failed',
      desc: '',
      args: [],
    );
  }

  /// `Try again`
  String get try_again {
    return Intl.message(
      'Try again',
      name: 'try_again',
      desc: '',
      args: [],
    );
  }

  /// `Your courses`
  String get your_courses {
    return Intl.message(
      'Your courses',
      name: 'your_courses',
      desc: '',
      args: [],
    );
  }

  /// `It seems that you are not teaching any courses right now, contact with the admin for more information.`
  String get no_courses_for_teacher {
    return Intl.message(
      'It seems that you are not teaching any courses right now, contact with the admin for more information.',
      name: 'no_courses_for_teacher',
      desc: '',
      args: [],
    );
  }

  /// `Semester`
  String get semester {
    return Intl.message(
      'Semester',
      name: 'semester',
      desc: '',
      args: [],
    );
  }

  /// `Students`
  String get students {
    return Intl.message(
      'Students',
      name: 'students',
      desc: '',
      args: [],
    );
  }

  /// `Lecture name`
  String get lecture_name {
    return Intl.message(
      'Lecture name',
      name: 'lecture_name',
      desc: '',
      args: [],
    );
  }

  /// `e.g., Lecture 1, Lecture 2 or Lecture 3`
  String get lecture_name_hint {
    return Intl.message(
      'e.g., Lecture 1, Lecture 2 or Lecture 3',
      name: 'lecture_name_hint',
      desc: '',
      args: [],
    );
  }

  /// `Lecture saved successfully.`
  String get lecture_saved_successfully {
    return Intl.message(
      'Lecture saved successfully.',
      name: 'lecture_saved_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Edit Lecture`
  String get edit_lecture {
    return Intl.message(
      'Edit Lecture',
      name: 'edit_lecture',
      desc: '',
      args: [],
    );
  }

  /// `Add Lecture`
  String get add_lecture {
    return Intl.message(
      'Add Lecture',
      name: 'add_lecture',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `All fields are required.`
  String get all_fields_are_required {
    return Intl.message(
      'All fields are required.',
      name: 'all_fields_are_required',
      desc: '',
      args: [],
    );
  }

  /// `All lectures stats`
  String get all_lectures_stats {
    return Intl.message(
      'All lectures stats',
      name: 'all_lectures_stats',
      desc: '',
      args: [],
    );
  }

  /// `Lectures`
  String get lectures {
    return Intl.message(
      'Lectures',
      name: 'lectures',
      desc: '',
      args: [],
    );
  }

  /// `Presence, Absence and Excused absence cases`
  String get cases {
    return Intl.message(
      'Presence, Absence and Excused absence cases',
      name: 'cases',
      desc: '',
      args: [],
    );
  }

  /// `Presence`
  String get presence {
    return Intl.message(
      'Presence',
      name: 'presence',
      desc: '',
      args: [],
    );
  }

  /// `Excused absence`
  String get excused_absence {
    return Intl.message(
      'Excused absence',
      name: 'excused_absence',
      desc: '',
      args: [],
    );
  }

  /// `Absence`
  String get absence {
    return Intl.message(
      'Absence',
      name: 'absence',
      desc: '',
      args: [],
    );
  }

  /// `All students stats`
  String get all_students_stats {
    return Intl.message(
      'All students stats',
      name: 'all_students_stats',
      desc: '',
      args: [],
    );
  }

  /// `Share as Excel file (.xlsx)`
  String get share_as_excel {
    return Intl.message(
      'Share as Excel file (.xlsx)',
      name: 'share_as_excel',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong, please try again.`
  String get something_went_wrong {
    return Intl.message(
      'Something went wrong, please try again.',
      name: 'something_went_wrong',
      desc: '',
      args: [],
    );
  }

  /// `Add new lectures by clicking on the + button below`
  String get no_lectures {
    return Intl.message(
      'Add new lectures by clicking on the + button below',
      name: 'no_lectures',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Student ID`
  String get student_id {
    return Intl.message(
      'Student ID',
      name: 'student_id',
      desc: '',
      args: [],
    );
  }

  /// `Lecture`
  String get lecture {
    return Intl.message(
      'Lecture',
      name: 'lecture',
      desc: '',
      args: [],
    );
  }

  /// `Attendance percent`
  String get attendance_percent {
    return Intl.message(
      'Attendance percent',
      name: 'attendance_percent',
      desc: '',
      args: [],
    );
  }

  /// `Excused absence percent`
  String get excused_absence_percent {
    return Intl.message(
      'Excused absence percent',
      name: 'excused_absence_percent',
      desc: '',
      args: [],
    );
  }

  /// `Absence percent`
  String get absence_percent {
    return Intl.message(
      'Absence percent',
      name: 'absence_percent',
      desc: '',
      args: [],
    );
  }

  /// `Present`
  String get present {
    return Intl.message(
      'Present',
      name: 'present',
      desc: '',
      args: [],
    );
  }

  /// `Absent with Excuse`
  String get absent_with_excuse {
    return Intl.message(
      'Absent with Excuse',
      name: 'absent_with_excuse',
      desc: '',
      args: [],
    );
  }

  /// `Absent`
  String get absent {
    return Intl.message(
      'Absent',
      name: 'absent',
      desc: '',
      args: [],
    );
  }

  /// `Delete Lecture`
  String get delete_lecture {
    return Intl.message(
      'Delete Lecture',
      name: 'delete_lecture',
      desc: '',
      args: [],
    );
  }

  /// `Lecture Deleted successfully.`
  String get lectureDeletedSuccessfully {
    return Intl.message(
      'Lecture Deleted successfully.',
      name: 'lectureDeletedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Status updated successfully.`
  String get statusUpdatedSuccessfully {
    return Intl.message(
      'Status updated successfully.',
      name: 'statusUpdatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete`
  String get areYouSureYouWantToDelete {
    return Intl.message(
      'Are you sure you want to delete',
      name: 'areYouSureYouWantToDelete',
      desc: '',
      args: [],
    );
  }

  /// `Students List`
  String get studentsList {
    return Intl.message(
      'Students List',
      name: 'studentsList',
      desc: '',
      args: [],
    );
  }

  /// `There are no students studying this course`
  String get thereAreNoStudentsStudyingThisCourse {
    return Intl.message(
      'There are no students studying this course',
      name: 'thereAreNoStudentsStudyingThisCourse',
      desc: '',
      args: [],
    );
  }

  /// `BACK`
  String get back {
    return Intl.message(
      'BACK',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `SHARE FILE`
  String get shareFile {
    return Intl.message(
      'SHARE FILE',
      name: 'shareFile',
      desc: '',
      args: [],
    );
  }

  /// `Type more than two characters.`
  String get typeMoreThanTwoCharacters {
    return Intl.message(
      'Type more than two characters.',
      name: 'typeMoreThanTwoCharacters',
      desc: '',
      args: [],
    );
  }

  /// `No Data Found.`
  String get noDataFound {
    return Intl.message(
      'No Data Found.',
      name: 'noDataFound',
      desc: '',
      args: [],
    );
  }

  /// `Teachers`
  String get theTeachers {
    return Intl.message(
      'Teachers',
      name: 'theTeachers',
      desc: '',
      args: [],
    );
  }

  /// `Courses`
  String get theCourses {
    return Intl.message(
      'Courses',
      name: 'theCourses',
      desc: '',
      args: [],
    );
  }

  /// `Students`
  String get theStudents {
    return Intl.message(
      'Students',
      name: 'theStudents',
      desc: '',
      args: [],
    );
  }

  /// `Manage`
  String get manage {
    return Intl.message(
      'Manage',
      name: 'manage',
      desc: '',
      args: [],
    );
  }

  /// `User saved successfully.`
  String get userSavedSuccessfully {
    return Intl.message(
      'User saved successfully.',
      name: 'userSavedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Edit User`
  String get editUser {
    return Intl.message(
      'Edit User',
      name: 'editUser',
      desc: '',
      args: [],
    );
  }

  /// `Add User`
  String get addUser {
    return Intl.message(
      'Add User',
      name: 'addUser',
      desc: '',
      args: [],
    );
  }

  /// `User id`
  String get userId {
    return Intl.message(
      'User id',
      name: 'userId',
      desc: '',
      args: [],
    );
  }

  /// `Enter the user id`
  String get enterTheUserId {
    return Intl.message(
      'Enter the user id',
      name: 'enterTheUserId',
      desc: '',
      args: [],
    );
  }

  /// `User name`
  String get userName {
    return Intl.message(
      'User name',
      name: 'userName',
      desc: '',
      args: [],
    );
  }

  /// `Enter the full user name`
  String get enterTheFullUserName {
    return Intl.message(
      'Enter the full user name',
      name: 'enterTheFullUserName',
      desc: '',
      args: [],
    );
  }

  /// `User type`
  String get userType {
    return Intl.message(
      'User type',
      name: 'userType',
      desc: '',
      args: [],
    );
  }

  /// `Users creation failed, please try again.`
  String get usersCreationFailedPleaseTryAgain {
    return Intl.message(
      'Users creation failed, please try again.',
      name: 'usersCreationFailedPleaseTryAgain',
      desc: '',
      args: [],
    );
  }

  /// `Users saved successfully.`
  String get usersSavedSuccessfully {
    return Intl.message(
      'Users saved successfully.',
      name: 'usersSavedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Select Excel file`
  String get selectExcelFile {
    return Intl.message(
      'Select Excel file',
      name: 'selectExcelFile',
      desc: '',
      args: [],
    );
  }

  /// `Click here to select file`
  String get clickHereToSelectFile {
    return Intl.message(
      'Click here to select file',
      name: 'clickHereToSelectFile',
      desc: '',
      args: [],
    );
  }

  /// `Deleted successfully.`
  String get deletedSuccessfully {
    return Intl.message(
      'Deleted successfully.',
      name: 'deletedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `All Students`
  String get allStudents {
    return Intl.message(
      'All Students',
      name: 'allStudents',
      desc: '',
      args: [],
    );
  }

  /// `Add Student`
  String get addStudent {
    return Intl.message(
      'Add Student',
      name: 'addStudent',
      desc: '',
      args: [],
    );
  }

  /// `Add Students`
  String get addStudents {
    return Intl.message(
      'Add Students',
      name: 'addStudents',
      desc: '',
      args: [],
    );
  }

  /// `All Teachers`
  String get allTeachers {
    return Intl.message(
      'All Teachers',
      name: 'allTeachers',
      desc: '',
      args: [],
    );
  }

  /// `Add Teacher`
  String get addTeacher {
    return Intl.message(
      'Add Teacher',
      name: 'addTeacher',
      desc: '',
      args: [],
    );
  }

  /// `Add Teachers`
  String get addTeachers {
    return Intl.message(
      'Add Teachers',
      name: 'addTeachers',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect Information. Please Try again.`
  String get incorrectInformationPleaseTryAgain {
    return Intl.message(
      'Incorrect Information. Please Try again.',
      name: 'incorrectInformationPleaseTryAgain',
      desc: '',
      args: [],
    );
  }

  /// `A problem occurred while logging to your account. Please Try again.`
  String get aProblemOccurredWhileLoggingToYourAccountPleaseTry {
    return Intl.message(
      'A problem occurred while logging to your account. Please Try again.',
      name: 'aProblemOccurredWhileLoggingToYourAccountPleaseTry',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get signIn {
    return Intl.message(
      'Sign In',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `Please enter some text`
  String get pleaseEnterSomeText {
    return Intl.message(
      'Please enter some text',
      name: 'pleaseEnterSomeText',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid User ID`
  String get enterAValidUserId {
    return Intl.message(
      'Enter a valid User ID',
      name: 'enterAValidUserId',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Enter your Password`
  String get enterYourPassword {
    return Intl.message(
      'Enter your Password',
      name: 'enterYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `You need to be connected to the internet to login.`
  String get youNeedToBeConnectedToTheInternetToLogin {
    return Intl.message(
      'You need to be connected to the internet to login.',
      name: 'youNeedToBeConnectedToTheInternetToLogin',
      desc: '',
      args: [],
    );
  }

  /// `عربي`
  String get language {
    return Intl.message(
      'عربي',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `All Courses`
  String get allCourses {
    return Intl.message(
      'All Courses',
      name: 'allCourses',
      desc: '',
      args: [],
    );
  }

  /// `Add Course`
  String get addCourse {
    return Intl.message(
      'Add Course',
      name: 'addCourse',
      desc: '',
      args: [],
    );
  }

  /// `Course`
  String get course {
    return Intl.message(
      'Course',
      name: 'course',
      desc: '',
      args: [],
    );
  }

  /// `Course saved successfully`
  String get courseSavedSuccessfully {
    return Intl.message(
      'Course saved successfully',
      name: 'courseSavedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Edit Course`
  String get editCourse {
    return Intl.message(
      'Edit Course',
      name: 'editCourse',
      desc: '',
      args: [],
    );
  }

  /// `Course name`
  String get courseName {
    return Intl.message(
      'Course name',
      name: 'courseName',
      desc: '',
      args: [],
    );
  }

  /// `You are not allowed to submit attendance to any of this course lectures; since you aren't studying this course.`
  String get youAreNotAllowedToSubmitAttendanceToAnyOf {
    return Intl.message(
      'You are not allowed to submit attendance to any of this course lectures; since you aren\'t studying this course.',
      name: 'youAreNotAllowedToSubmitAttendanceToAnyOf',
      desc: '',
      args: [],
    );
  }

  /// `Departments`
  String get theDepartments {
    return Intl.message(
      'Departments',
      name: 'theDepartments',
      desc: '',
      args: [],
    );
  }

  /// `All departments`
  String get allDepartments {
    return Intl.message(
      'All departments',
      name: 'allDepartments',
      desc: '',
      args: [],
    );
  }

  /// `Department saved successfully`
  String get departmentSavedSuccessfully {
    return Intl.message(
      'Department saved successfully',
      name: 'departmentSavedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Department Name`
  String get departmentName {
    return Intl.message(
      'Department Name',
      name: 'departmentName',
      desc: '',
      args: [],
    );
  }

  /// `Enter the full department name.`
  String get enterTheFullDepartmentName {
    return Intl.message(
      'Enter the full department name.',
      name: 'enterTheFullDepartmentName',
      desc: '',
      args: [],
    );
  }

  /// `Edit department`
  String get editDepartment {
    return Intl.message(
      'Edit department',
      name: 'editDepartment',
      desc: '',
      args: [],
    );
  }

  /// `Add department`
  String get addDepartment {
    return Intl.message(
      'Add department',
      name: 'addDepartment',
      desc: '',
      args: [],
    );
  }

  /// `Department`
  String get department {
    return Intl.message(
      'Department',
      name: 'department',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}
