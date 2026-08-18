import 'package:dartz/dartz.dart';
import 'package:wereat/core/error/exceptions.dart';
import 'package:wereat/core/error/failures.dart';
import 'package:wereat/features/home/data/datasources/home_local_datasource.dart';
import 'package:wereat/features/home/domain/entities/greeting.dart';
import 'package:wereat/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(this.localDataSource);

  final HomeLocalDataSource localDataSource;

  @override
  Future<Either<Failure, Greeting>> getGreeting() async {
    try {
      final result = await localDataSource.getGreeting();
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
