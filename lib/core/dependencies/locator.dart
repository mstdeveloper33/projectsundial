import 'package:get_it/get_it.dart';
import 'package:sundialproject/core/services/api_service.dart';

import '../services/sqlite_service.dart';

final locator = GetIt.instance;
Future<void> setupLocator() async {
  locator.registerLazySingleton<ApiService>(() => ApiService());
  // SQLite servisini kaydetme
  locator.registerLazySingleton<SQLiteService>(() => SQLiteService());
}