const String usersPath = 'users';
const String coursesPath = 'courses';
const String departmentsPath = 'departments';

String lecturesPath(String courseId) => '$coursesPath/$courseId/lectures';
