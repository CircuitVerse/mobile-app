class Constants {
  /// USER CONSTANTS
  static const String userAUTHWRONGCREDENTIALS =
      'Invalid credentials, please check';
  static const String userAUTHUSERNOTFOUND = 'User not found, try signing up';
  static const String userAUTHUSERALREADYEXISTS =
      'User already exists, try login';
  static const String userNOTAUTHORIZEDTOFETCHUSER =
      'You are not authorized to fetch this user';
  static const String userNOTFOUND = 'User not found';

  /// PROJECT CONSTANTS
  static const String projectNOTFOUND = 'No project was found';
  static const String projectFORKCONFLICT = 'Cannot fork your own project';

  /// COLLABORATOR CONSTANTS
  static const String collaboratorNOTFOUND =
      'The requested collaborator does not exists';

  /// GROUP RELATED CONSTANTS
  static const String groupNOTFOUND = 'The requested group does not exists';

  /// GROUP MEMBERS CONSTANTS
  static const String groupMEMBERNOTFOUND =
      'The requested group member does not exists';

  /// ASSIGNMENTS CONSTANTS
  static const String assignmentALREADYOPENED =
      'The assignment is already opened';
  static const String assignmentNOTFOUND =
      'The requested assignment does not exists';

  /// GRADE CONSTANTS
  static const String gradeNOTFOUND = 'Grade not found';

  /// GENERIC FAILURE CONSTANTS
  static const String badRESPONSEFORMAT = 'Bad response format';
  static const String invalidPARAMETERS = 'Invalid parameters, retry!';
  static const String genericFAILURE =
      'Something wrong occurred! please try again';
  static const String noINTERNETCONNECTION = 'No internet connection';
  static const String httpEXCEPTION = 'Unable to fetch response';
  // ignore: constant_identifier_names
  static const String UNAUTHENTICATED =
      'Unauthenticated to perform this action';
  // ignore: constant_identifier_names
  static const String UNAUTHORIZED = 'Unauthorized to perform this action';
}
