import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class DepartmentEntity extends Equatable {
  final String id;
  final String name;

  const DepartmentEntity({
    @required this.id,
    @required this.name,
  }) : assert(id != null && name != null);

  static const empty = DepartmentEntity(
    id: '',
    name: '',
  );

  @override
  List<Object> get props => [
        id,
        name,
      ];
}
