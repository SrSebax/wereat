import 'package:dartz/dartz.dart';
import 'package:wereat/core/error/failures.dart';
import 'package:wereat/features/home/domain/entities/greeting.dart';

abstract class HomeRepository {
  Future<Either<Failure, Greeting>> getGreeting();
}
