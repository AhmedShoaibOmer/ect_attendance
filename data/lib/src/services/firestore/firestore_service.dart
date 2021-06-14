import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domain/domain.dart';
import 'package:meta/meta.dart';

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

  Future<String> addCourse({
    @required String courseName,
    @required String semester,
    @required String teacherId,
  }) async {
    String courseId;
    await _coursesCollection.add(
      {"name": courseName, "semester": semester, "teacherId": teacherId},
    ).then((courseRef) async {
      courseId = courseRef.id;
    });
    return courseId;
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

  Future<void> updateCourse({
    @required String courseId,
    @required String name,
    @required String semester,
  }) async {
    if (name != null)
      await _coursesCollection
          .doc(
        courseId,
      )
          .update(
        {"name": name},
      );

    if (semester != null)
      await _coursesCollection
          .doc(
        courseId,
      )
          .update(
        {"semester": semester},
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
    @required String studentId,
    @required String courseId,
    @required String lectureId,
  }) async {
    Lecture lecture;
    await _lecturesCollection(courseId).doc(lectureId).update({
      "attendeesIds": FieldValue.arrayUnion([studentId]),
      "absentIds": FieldValue.arrayRemove([studentId]),
      "excusedAbsenteesIds": FieldValue.arrayRemove([studentId]),
    }).then((_) async {
      await _lecturesCollection(courseId).doc(lectureId).get().then((value) {
        lecture = Lecture.fromJson(value.toJson);
      });
    });
    return lecture;
  }

  Future<Lecture> submitAbsence({
    @required String studentId,
    @required String courseId,
    @required String lectureId,
  }) async {
    Lecture lecture;
    await _lecturesCollection(courseId).doc(lectureId).update({
      "attendeesIds": FieldValue.arrayRemove([studentId]),
      "absentIds": FieldValue.arrayUnion([studentId]),
      "excusedAbsenteesIds": FieldValue.arrayRemove([studentId]),
    }).then((_) async {
      await _lecturesCollection(courseId).doc(lectureId).get().then((value) {
        lecture = Lecture.fromJson(value.toJson);
      });
    });
    return lecture;
  }

  Future<Lecture> submitExcusedAbsence({
    @required String studentId,
    @required String courseId,
    @required String lectureId,
  }) async {
    Lecture lecture;
    await _lecturesCollection(courseId).doc(lectureId).update({
      "attendeesIds": FieldValue.arrayRemove([studentId]),
      "absentIds": FieldValue.arrayRemove([studentId]),
      "excusedAbsenteesIds": FieldValue.arrayUnion([studentId]),
    }).then((_) async {
      await _lecturesCollection(courseId).doc(lectureId).get().then((value) {
        lecture = Lecture.fromJson(value.toJson);
      });
    });
    return lecture;
  }

  Query lecturesForCourse({
    String courseId,
  }) {
    return _lecturesCollection(courseId).orderBy("date");
  }

  // **************************************************************************
  // Lecture related: END
  // **************************************************************************

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
