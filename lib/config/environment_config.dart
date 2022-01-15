class EnvironmentConfig {
  static const String cvAPIBASEURL = String.fromEnvironment(
    'CV_API_BASE_URL',
    defaultValue: 'https://circuitverse.org/api/v1',
  );

  static const String ibAPIBASEURL = String.fromEnvironment(
    'IB_API_BASE_URL',
    defaultValue: 'https://learn.circuitverse.org/_api/pages',
  );

  static const String ibBASEURL = String.fromEnvironment(
    'IB_BASE_URL',
    defaultValue: 'https://learn.circuitverse.org',
  );

  // GITHUB OAUTH ENV VARIABLES
  static const String githubOAUTHCLIENTID = String.fromEnvironment(
    'GITHUB_OAUTH_CLIENT_ID',
  );
  static const String githubOAUTHCLIENTSECRET = String.fromEnvironment(
    'GITHUB_OAUTH_CLIENT_SECRET',
  );
  static const String githubOAUTHREDIRECTURI = String.fromEnvironment(
    'GITHUB_OAUTH_REDIRECT_URI',
    defaultValue: 'circuitverse://auth/callback/github',
  );

  // FB OAUTH ENV VARIABLES
  static const String fbAPPNAME = String.fromEnvironment('FB_APP_NAME');
  static const String fbAPPID = String.fromEnvironment('FB_APP_ID');
}
