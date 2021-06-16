import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domain/domain.dart';
import 'package:meta/meta.dart';

import '../../../data.dart';
import '../../course/course.dart';
import '../../lecture/lecture.dart';
import '../../user/user.dart';
import '../preferences/shared_preferences_service.dart';
import 'collections_paths.dart';

class FirestoreService {
  static FirestoreService _instance;
  static FirebaseFirestore _firestore;

  FirestoreService._internal();

  static FirestoreService get instance {
    if (_instance == null) {
      _instance = FirestoreService._internal();
    }

    if (_firestore == null) {
      _firestore = FirebaseFirestore.instance;
    }

    return _instance;
  }

  CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection(usersPath);
  final _controller = StreamController<UserEntity>();

  /// This stream is directly linked to the authentication state when it send
  /// an empty user it means no user authenticated.
  /// and it emits every change in the user, a new user entity well be
  /// emitted every time [FirestoreService.getUser()] invoked to get
  /// the current user.
  Stream<UserEntity> get userChanges async* {
    final preferences = await SharedPreferencesService.instance;
    yield* _controller.stream.map((event) {
      currentUser = event;

      if (event != null && event != UserEntity.empty) {
        preferences.setCurrentUserId(event.id);
      } else {
        preferences.setCurrentUserId('');
      }
      return event;
    });
  }

  void userLoggedOut() {
    _controller.add(UserEntity.empty);
  }

  UserEntity currentUser;

  Future<void> addNewUser(User newUser) async {
    await _usersCollection
        .doc(
          /* The document id should be the same as user id;
      * allowing easier referencing.
      * */
          newUser.id,
        )
        .set(
          /* pass the user info .*/
          newUser.toJson(),
        )
        .then((value) async => await getUser());
  }

  /// Gets user info from cloud firestore.
  ///
  /// [userId] - the id for the required user info , if null the current
  /// authenticated user info well be retrieved.
  Future<void> getUser({String userId}) async {
    print('fetching from firestore....');

    final preferences = await SharedPreferencesService.instance;

    final DocumentSnapshot userDoc = await _usersCollection
        .doc(
          userId ?? preferences.currentUserId,
        )
        .get();

    if (userDoc == null) {
      throw UserNotFoundException(
        userId: userId ?? preferences.currentUserId,
      );
    }

    print('User document fetched from firestore');
    final user = User.fromJson(userDoc.toJson);
    print('all User properties mapped into an object.');
    _controller.add(user);
    print('User Entity emitted : ${user.name}');
  }

  Future<List<User>> getUsers(List<String> ids) async {
    List<User> users = [];
    for (String id in ids) {
      final doc = await _usersCollection.doc(id).get();
      users.add(User.fromJson(doc.toJson));
    }
    return users;
  }

  Query getUsersWithRole(String role) {
    assert(
      role == 'teacher' || role == 'student',
    );
    return _usersCollection.where('role', isEqualTo: role).orderBy('name');
  }

  Future<void> deleteUser(String userId) async {
    await _usersCollection.doc(userId).delete();
  }

  Future<void> addEditUser(User user) async {
    await _usersCollection.doc(user.id).set(
          user.toJson(),
          SetOptions(merge: true),
        );
  }

  Future<void> addUsers(List<User> users) async {
    final batch = _firestore.batch();

    for (User user in users) {
      batch.set(
        _usersCollection.doc(user.id),
        user.toJson(),
        SetOptions(merge: true),
      );
    }

    await batch.commit();
  }

  // **************************************************************************
  // Course related: BEGIN
  // **************************************************************************
  CollectionReference _coursesCollection =
      FirebaseFirestore.instance.collection(coursesPath);

  Stream<Course> course(String courseId) {
    return _coursesCollection
        .doc(
          courseId,
        )
        .snapshots()
        .map(
          (event) => Course.fromJson(event.toJson),
        );
  }

  Query getCoursesForTeacher(String teacherId) {
    return _coursesCollection.where(
      'teacherId',
      isEqualTo: teacherId,
    );
  }

  Query getCourses() {
    return _coursesCollection;
  }

  Future<List<User>> getUsersForCourse(CourseEntity courseEntity) async {
    List<User> users = [];
    await _usersCollection
        .where(
          'departmentId',
          isEqualTo: courseEntity.departmentId,
        )
        .where(
          'semester',
          isEqualTo: courseEntity.semester,
        )
        .get()
        .then((value) {
      value.docs.forEach((element) {
        users.add(User.fromJson(element.toJson));
      });
    });
    return users;
  }

  Future<void> addEditCourse({@required Course course}) async {
    await _coursesCollection
        .doc(
          course.id.isEmpty ? null : course.id,
        )
        .set(
          course.toJson(),
          SetOptions(merge: true),
        );
  }

  Future<void> deleteCourse(
    String courseId,
  ) async {
    await _coursesCollection
        .doc(
          courseId,
        )
        .delete();
  }

  // **************************************************************************
  // Course related: END
  // **************************************************************************

  // **************************************************************************
  // Lecture related: BEGIN
  // **************************************************************************
  CollectionReference _lecturesCollection(String courseId) {
    return FirebaseFirestore.instance.collection(
      lecturesPath(courseId),
    );
  }

  Stream<Lecture> lecture(String lectureId, String courseId) {
    return _lecturesCollection(courseId)
        .doc(
          lectureId,
        )
        .snapshots()
        .map(
          (event) => Lecture.fromJson(event.toJson),
        );
  }

  Future<String> addNewLectureToCourse({
    String courseId,
    String name,
    DateTime dateTime,
    List<String> studentsIds,
  }) async {
    String lectureId;
    print('adding new lecture firestore');

    await _lecturesCollection(courseId).add(
      {
        "name": name,
        "date": dateTime,
        'attendeesIds': [],
        'absentIds': studentsIds,
        'excusedAbsenteesIds': [],
      },
    ).then((value) => lectureId = value.id);
    return lectureId;
  }

  Future<void> deleteLectureFromCourse(
    String courseId,
    String lectureId,
  ) async {
    await _lecturesCollection(courseId).doc(lectureId).delete();
  }

  Future<void> updateLecture({
    Lecture lecture,
    String courseId,
  }) async {
    await _lecturesCollection(courseId)
        .doc(
          lecture.id,
        )
        .update(
          lecture.toJson(),
        );
  }

  Future<Lecture> submitAttendance({
    @required UserEntity student,
    @required String courseId,
    @required String lectureId,
  }) async {
    Course course;

    await _coursesCollection
        .doc(
          courseId,
        )
        .get()
        .then(
          (event) => course = Course.fromJson(event.toJson),
        );

    if (course.semester == student.semester &&
        course.departmentId == student.departmentId) {
      Lecture lecture;

      await _lecturesCollection(courseId).doc(lectureId).get().then((value) {
        lecture = Lecture.fromJson(value.toJson);
      });

      List<String> absentIds = lecture.absentIds;
      List<String> excusedAbsenteesIds = lecture.excusedAbsenteesIds;
      List<String> attendeesIds = lecture.attendeesIds;

      absentIds.removeWhere((element) {
        return element == student.id;
      });

      excusedAbsenteesIds.removeWhere((element) {
        return element == student.id;
      });

      attendeesIds.removeWhere((element) {
        return element == student.id;
      });

      attendeesIds.add(student.id);

      final newLecture = lecture.copyWith(
        absentIds: absentIds,
        attendeesIds: attendeesIds,
        excusedAbsenteesIds: excusedAbsenteesIds,
      );

      await updateLecture(lecture: newLecture, courseId: courseId);

      return lecture;
    } else {
      throw StudentNotAuthorizedException();
    }
  }

  Query lecturesForCourse({
    String courseId,
  }) {
    return _lecturesCollection(courseId).orderBy("date");
  }

  // **************************************************************************
  // Lecture related: END
  // **************************************************************************

  CollectionReference _departmentsCollection =
      FirebaseFirestore.instance.collection(departmentsPath);

  Query getDepartments() {
    return _departmentsCollection;
  }

  Future<void> addEditDepartment({@required Department department}) async {
    await _departmentsCollection
        .doc(
          department.id.isEmpty ? null : department.id,
        )
        .set(
          department.toJson(),
          SetOptions(merge: true),
        );
  }

  Future<void> deleteDepartment(
    String departmentId,
  ) async {
    await _departmentsCollection
        .doc(
          departmentId,
        )
        .delete();
  }

  void dispose() {
    _controller.close();
    _instance = null;
    _firestore = null;
  }
}

/// Creates json type from all document fields including the document id.
extension DocumentSnapshotExtensions on DocumentSnapshot {
  Map<String, dynamic> get toJson {
    final jsonData = data();
    jsonData.addAll({"id": id});
    return jsonData;
  }
}
