import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static const envName = String.fromEnvironment('ENV', defaultValue: 'dev');
  static const envFile = '.env.$envName';

  static String get baseUrl {
    final value = dotenv.env['API_BASE_URL'];
    if (value == null || value.isEmpty) {
      throw StateError('API_BASE_URL missing in $envFile');
    }
    return value;
  }
}