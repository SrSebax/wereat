import 'package:dartz/dartz.dart';
import 'package:wereat/core/error/failures.dart';
import 'package:wereat/core/usecases/usecase.dart';
import 'package:wereat/features/auth/domain/entities/app_user.dart';
import 'package:wereat/features/auth/domain/repositories/auth_repository.dart';

class SignInWithEmailPasswordParams {
  const SignInWithEmailPasswordParams({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}

class SignInWithEmailPassword
    implements UseCase<AppUser, SignInWithEmailPasswordParams> {
  const SignInWithEmailPassword(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, AppUser>> call(
    SignInWithEmailPasswordParams params,
  ) {
    return repository.signInWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
  }
}
