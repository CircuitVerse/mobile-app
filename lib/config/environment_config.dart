class EnvironmentConfig {
  static const String CV_API_BASE_URL = String.fromEnvironment(
    'CV_API_BASE_URL',
    defaultValue: 'https://circuitverse.org/api/v1',
  );
}
