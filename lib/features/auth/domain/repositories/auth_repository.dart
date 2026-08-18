import 'package:dartz/dartz.dart';
import 'package:wereat/core/error/failures.dart';
import 'package:wereat/features/auth/domain/entities/app_user.dart';

abstract class AuthRepository {
  Future<Either<Failure, AppUser>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, AppUser>> signInWithGoogle();

  Future<Either<Failure, AppUser>> registerWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> sendPasswordResetEmail({required String email});

  Future<Either<Failure, void>> signOut();
}
