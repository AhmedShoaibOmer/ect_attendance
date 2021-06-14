import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../generated/l10n.dart';

class StudentDetailsForCourse extends StatelessWidget {
  final UserEntity student;
  final List<Lecture> lectures;

  const StudentDetailsForCourse({
    Key key,
    this.student,
    this.lectures,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.all(
            Radius.circular(10),
          ),
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      student.name,
                      style: Theme.of(context).textTheme.subtitle1.apply(
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
            ]..addAll(lectures
                .map(
                  (e) => ListTile(
                    onTap: () {
                      Navigator.pop(context, e);
                    },
                    title: Text(e.name),
                    subtitle: Row(
                      children: [
                        Icon(
                          Icons.circle,
                          color: _statusColor(e, student.id),
                          size: 16,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Expanded(
                          child: Text(
                            _statusText(context, e, student.id),
                            style: Theme.of(context).textTheme.caption.apply(
                                  color: Theme.of(context).primaryColor,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList()),
          ),
        ),
      ),
    );
  }

  String _statusText(BuildContext context, Lecture lecture, String id) {
    if (lecture.absentIds.contains(id))
      return S.of(context).absent;
    else if (lecture.excusedAbsenteesIds.contains(id))
      return S.of(context).absent_with_excuse;
    else
      return S.of(context).present;
  }

  Color _statusColor(Lecture lecture, String id) {
    if (lecture.absentIds.contains(id))
      return Colors.red;
    else if (lecture.excusedAbsenteesIds.contains(id))
      return Colors.orange;
    else
      return Colors.green;
  }

  static Route<Object> route({UserEntity student, List<Lecture> lectures}) {
    return MaterialPageRoute(
      builder: (context) => StudentDetailsForCourse(
        lectures: lectures,
        student: student,
      ),
    );
  }
}
