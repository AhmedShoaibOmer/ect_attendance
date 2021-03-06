import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class LectureEntity extends Equatable {
  final String id;
  final String name;
  final DateTime date;
  final List<String> attendeesIds;
  final List<String> absentIds;
  final List<String> excusedAbsenteesIds;

  LectureEntity({
    @required this.id,
    @required this.name,
    @required this.date,
    @required this.attendeesIds,
    @required this.absentIds,
    @required this.excusedAbsenteesIds,
  }) : assert(id != null && name != null);

  @override
  List<Object> get props => [
        id,
        name,
        date,
        attendeesIds,
        absentIds,
        excusedAbsenteesIds,
      ];
}
