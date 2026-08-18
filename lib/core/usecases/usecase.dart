import 'package:dartz/dartz.dart';
import 'package:wereat/core/error/failures.dart';

abstract class UseCase<ReturnType, Params> {
  Future<Either<Failure, ReturnType>> call(Params params);
}

class NoParams {
  const NoParams();
}
