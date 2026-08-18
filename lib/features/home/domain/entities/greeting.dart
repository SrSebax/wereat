import 'package:equatable/equatable.dart';

class Greeting extends Equatable {
  const Greeting({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
