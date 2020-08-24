class EnvironmentConfig {
  static const String CV_API_BASE_URL = String.fromEnvironment(
    'CV_API_BASE_URL',
    defaultValue: 'https://circuitverse.org/api/v1',
  );

  // GITHUB OAUTH ENV VARIABLES
  static const String GITHUB_OAUTH_CLIENT_ID = String.fromEnvironment(
    'GITHUB_OAUTH_CLIENT_ID',
    defaultValue: '06fa6b965ba7e4a4175c',
  );
  static const String GITHUB_OAUTH_CLIENT_SECRET = String.fromEnvironment(
    'GITHUB_OAUTH_CLIENT_SECRET',
    defaultValue: 'd3a8a95bd1691b557ca347b14ae6507b89f92e47',
  );
  static const String GITHUB_OAUTH_REDIRECT_URI = String.fromEnvironment(
    'GITHUB_OAUTH_REDIRECT_URI',
    defaultValue: 'circuitverse://auth/callback/github',
  );
}
