import 'package:dartz/dartz.dart';
import 'package:wereat/core/error/failures.dart';
import 'package:wereat/core/usecases/usecase.dart';
import 'package:wereat/features/auth/domain/repositories/auth_repository.dart';

class SendPasswordResetEmailParams {
  const SendPasswordResetEmailParams({required this.email});

  final String email;
}

class SendPasswordResetEmail
    implements UseCase<void, SendPasswordResetEmailParams> {
  const SendPasswordResetEmail(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, void>> call(SendPasswordResetEmailParams params) {
    return repository.sendPasswordResetEmail(email: params.email);
  }
}
