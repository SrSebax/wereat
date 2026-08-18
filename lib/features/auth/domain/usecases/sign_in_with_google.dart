import 'package:dartz/dartz.dart';
import 'package:wereat/core/error/failures.dart';
import 'package:wereat/core/usecases/usecase.dart';
import 'package:wereat/features/auth/domain/entities/app_user.dart';
import 'package:wereat/features/auth/domain/repositories/auth_repository.dart';

class SignInWithGoogle implements UseCase<AppUser, NoParams> {
  const SignInWithGoogle(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, AppUser>> call(NoParams params) {
    return repository.signInWithGoogle();
  }
}
