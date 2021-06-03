import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final List<dynamic> properties;

  Failure([this.properties]) : super();

  @override
  List<Object> get props => properties;
}

class NoConnectionFailure extends Failure {}
