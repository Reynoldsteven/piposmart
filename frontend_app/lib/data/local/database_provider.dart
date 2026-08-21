import 'app_database.dart';

class DatabaseProvider {
  DatabaseProvider._();

  static AppDatabase? _instance;

  static AppDatabase get instance => _instance ??= AppDatabase();

  static Future<void> close() async {
    await _instance?.close();
    _instance = null;
  }
}
