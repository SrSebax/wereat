import 'package:wereat/features/home/data/models/greeting_model.dart';

abstract class HomeLocalDataSource {
  Future<GreetingModel> getGreeting();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  const HomeLocalDataSourceImpl();

  @override
  Future<GreetingModel> getGreeting() async {
    return const GreetingModel(message: 'Bienvenido a Wereat');
  }
}
