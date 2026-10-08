class AppConfig {
  // Android emulator: 10.0.2.2 | real phone: laptop IP
  // Override: flutter run --dart-define=API_BASE_URL=http://192.168.1.5:3000/api
  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3000/api',
  );
}