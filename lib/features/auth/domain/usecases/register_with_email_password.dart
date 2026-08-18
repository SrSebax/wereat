import 'package:dartz/dartz.dart';
import 'package:wereat/core/error/failures.dart';
import 'package:wereat/core/usecases/usecase.dart';
import 'package:wereat/features/auth/domain/entities/app_user.dart';
import 'package:wereat/features/auth/domain/repositories/auth_repository.dart';

class RegisterWithEmailPasswordParams {
  const RegisterWithEmailPasswordParams({
    required this.name,
    required this.email,
    required this.password,
  });

  final String name;
  final String email;
  final String password;
}

class RegisterWithEmailPassword
    implements UseCase<AppUser, RegisterWithEmailPasswordParams> {
  const RegisterWithEmailPassword(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, AppUser>> call(
    RegisterWithEmailPasswordParams params,
  ) {
    return repository.registerWithEmailAndPassword(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}
