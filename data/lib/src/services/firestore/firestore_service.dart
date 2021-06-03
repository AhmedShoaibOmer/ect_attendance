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
  final _controller = StreamController<User>();

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
        preferences.setCurrentUserId(null);
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

  // **************************************************************************
  // Course related: BEGIN
  // **************************************************************************
  CollectionReference _coursesCollection =
      FirebaseFirestore.instance.collection(coursesPath);

  Future<String> addCourse({
    String courseName,
    String semester,
  }) async {
    String courseId;
    await _coursesCollection.add(
      {
        "name": courseName,
        "semester": semester,
      },
    ).then((courseRef) async {
      courseId = courseRef.id;
    });
    return courseId;
  }

  Future<List<Course>> getCourses(List<String> coursesIds) async {
    List<Course> courses = [];
    if (coursesIds == null || coursesIds.isEmpty) return null;
    for (var element in coursesIds) {
      await _coursesCollection.doc(element).get().then((value) {
        print('courses fetched from firestore ${value.toJson}');
        courses.add(
          Course.fromJson(value.toJson),
        );
      });
    }
    return courses;
  }

  Future<void> updateCourse({
    String courseId,
    String name,
    String semester,
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

  Future<void> deleteCourse({
    String courseId,
  }) async {
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

  Future<void> addNewLectureToCourse(
    String courseId,
    Lecture lecture,
  ) async {
    String lectureId;

    await _lecturesCollection(courseId)
        .add(
          lecture.toJson(),
        )
        .then((value) => lectureId = value.id);

    await _coursesCollection.doc(courseId).update(
      {
        "lecturesIds": FieldValue.arrayUnion([lectureId]),
      },
    );
  }

  Future<void> removeLectureFromCourse(
      String courseId, String lectureId) async {
    await _coursesCollection.doc(courseId).update(
      {
        "lecturesIds": FieldValue.arrayRemove([lectureId]),
      },
    );
  }

  Future<void> deleteLectureFromCourse(
    String courseId,
    String lectureId,
  ) async {
    await _lecturesCollection(courseId)
        .doc(lectureId)
        .delete()
        .then((value) async {
      await _coursesCollection.doc(courseId).update({
        "lecturesIds": FieldValue.arrayRemove([lectureId]),
      });
    });
  }

  Future<void> submitAttendance({
    @required String studentId,
    @required String courseId,
    @required String lectureId,
  }) async {
    await _lecturesCollection(courseId).doc(lectureId).update({
      "attendeesIds": FieldValue.arrayUnion([studentId]),
      "absentIds": FieldValue.arrayRemove([studentId]),
      "excusedAbsenteesIds": FieldValue.arrayRemove([studentId]),
    });
  }

  Future<void> submitAbsence({
    @required String studentId,
    @required String courseId,
    @required String lectureId,
  }) async {
    await _lecturesCollection(courseId).doc(lectureId).update({
      "attendeesIds": FieldValue.arrayRemove([studentId]),
      "absentIds": FieldValue.arrayUnion([studentId]),
      "excusedAbsenteesIds": FieldValue.arrayRemove([studentId]),
    });
  }

  Future<void> submitExcusedAbsence({
    @required String studentId,
    @required String courseId,
    @required String lectureId,
  }) async {
    await _lecturesCollection(courseId).doc(lectureId).update({
      "attendeesIds": FieldValue.arrayRemove([studentId]),
      "absentIds": FieldValue.arrayRemove([studentId]),
      "excusedAbsenteesIds": FieldValue.arrayUnion([studentId]),
    });
  }

  Query lecturesForCourse({
    String courseId,
  }) {
    return _lecturesCollection(courseId);
  }

  // **************************************************************************
  // Study Material related: END
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
    jsonData.addAll({"universityId": id});
    return jsonData;
  }
}
