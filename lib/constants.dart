class Constants {
  /// USER CONSTANTS
  static const String USER_AUTH_WRONG_CREDENTIALS =
      'Invalid credentials, please check';
  static const String USER_AUTH_USER_NOT_FOUND =
      'User not found, try signing up';
  static const String USER_AUTH_USER_ALREADY_EXISTS =
      'User already exists, try login';
  static const String USER_NOT_AUTHORIZED_TO_FETCH_USER =
      'You are not authorized to fetch this user';
  static const String USER_NOT_FOUND = 'User not found';

  /// PROJECT CONSTANTS
  static const String PROJECT_NOT_FOUND = 'No project was found';
  static const String PROJECT_FORK_CONFLICT = 'Cannot fork your own project';

  /// COLLABORATOR CONSTANTS
  static const String COLLABORATOR_NOT_FOUND =
      'The requested collaborator does not exists';

  /// GROUP RELATED CONSTANTS
  static const String GROUP_NOT_FOUND = 'The requested group does not exists';

  /// GROUP MEMBERS CONSTANTS
  static const String GROUP_MEMBER_NOT_FOUND =
      'The requested group member does not exists';

  /// ASSIGNMENTS CONSTANTS
  static const String ASSIGNMENT_ALREADY_OPENED =
      'The assignment is already opened';
  static const String ASSIGNMENT_NOT_FOUND =
      'The requested assignment does not exists';

  /// GRADE CONSTANTS
  static const String GRADE_NOT_FOUND = 'Grade not found';

  /// GENERIC FAILURE CONSTANTS
  static const String BAD_RESPONSE_FORMAT = 'Bad response format';
  static const String INVALID_PARAMETERS = 'Invalid parameters, retry!';
  static const String GENERIC_FAILURE =
      'Something wrong occurred! please try again';
  static const String NO_INTERNET_CONNECTION = 'No internet connection';
  static const String HTTP_EXCEPTION = 'Unable to fetch response';
  static const String UNAUTHENTICATED =
      'Unauthenticated to perform this action';
  static const String UNAUTHORIZED = 'Unauthorized to perform this action';
}
