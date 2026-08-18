import 'package:dartz/dartz.dart';
import 'package:wereat/core/error/failures.dart';
import 'package:wereat/core/usecases/usecase.dart';
import 'package:wereat/features/home/domain/entities/greeting.dart';
import 'package:wereat/features/home/domain/repositories/home_repository.dart';

class GetGreeting implements UseCase<Greeting, NoParams> {
  const GetGreeting(this.repository);

  final HomeRepository repository;

  @override
  Future<Either<Failure, Greeting>> call(NoParams params) {
    return repository.getGreeting();
  }
}
