import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wereat/core/usecases/usecase.dart';
import 'package:wereat/features/home/data/datasources/home_local_datasource.dart';
import 'package:wereat/features/home/data/repositories/home_repository_impl.dart';
import 'package:wereat/features/home/domain/entities/greeting.dart';
import 'package:wereat/features/home/domain/repositories/home_repository.dart';
import 'package:wereat/features/home/domain/usecases/get_greeting.dart';

final homeLocalDataSourceProvider = Provider<HomeLocalDataSource>((ref) {
  return const HomeLocalDataSourceImpl();
});

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepositoryImpl(ref.watch(homeLocalDataSourceProvider));
});

final getGreetingProvider = Provider<GetGreeting>((ref) {
  return GetGreeting(ref.watch(homeRepositoryProvider));
});

final greetingProvider = FutureProvider<Greeting>((ref) async {
  final useCase = ref.watch(getGreetingProvider);
  final result = await useCase(const NoParams());
  return result.fold(
    (failure) => throw Exception(failure.message),
    (greeting) => greeting,
  );
});
