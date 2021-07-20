class EnvironmentConfig {
  static const String CV_API_BASE_URL = String.fromEnvironment(
    'CV_API_BASE_URL',
    defaultValue: 'https://circuitverse.org/api/v1',
  );

  static const String IB_API_BASE_URL = String.fromEnvironment(
    'IB_API_BASE_URL',
    defaultValue: 'https://learn.circuitverse.org/_api/pages',
  );

  static const String IB_BASE_URL = String.fromEnvironment(
    'IB_BASE_URL',
    defaultValue: 'https://learn.circuitverse.org',
  );

  // GITHUB OAUTH ENV VARIABLES
  static const String GITHUB_OAUTH_CLIENT_ID = String.fromEnvironment(
    'GITHUB_OAUTH_CLIENT_ID',
  );
  static const String GITHUB_OAUTH_CLIENT_SECRET = String.fromEnvironment(
    'GITHUB_OAUTH_CLIENT_SECRET',
  );
  static const String GITHUB_OAUTH_REDIRECT_URI = String.fromEnvironment(
    'GITHUB_OAUTH_REDIRECT_URI',
    defaultValue: 'circuitverse://auth/callback/github',
  );

  // FB OAUTH ENV VARIABLES
  static const String FB_APP_NAME = String.fromEnvironment('FB_APP_NAME');
  static const String FB_APP_ID = String.fromEnvironment('FB_APP_ID');
}
