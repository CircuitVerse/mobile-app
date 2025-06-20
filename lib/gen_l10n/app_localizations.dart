import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
  ];

  /// No description provided for @home_header_title.
  ///
  /// In en, this message translates to:
  /// **'Dive into the world of Logic Circuits for free!'**
  String get home_header_title;

  /// No description provided for @home_header_subtitle.
  ///
  /// In en, this message translates to:
  /// **'From Simple gates to complex sequential circuits, plot timing diagrams, automatic circuit generation, explore standard ICs, and much more'**
  String get home_header_subtitle;

  /// No description provided for @teachers_button.
  ///
  /// In en, this message translates to:
  /// **'For Teachers'**
  String get teachers_button;

  /// No description provided for @contributors_button.
  ///
  /// In en, this message translates to:
  /// **'For Contributors'**
  String get contributors_button;

  /// No description provided for @features_title.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get features_title;

  /// No description provided for @features_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Design circuits quickly and easily with a modern and intuitive user interface with drag-and-drop, copy/paste, zoom and more.'**
  String get features_subtitle;

  /// No description provided for @feature1_title.
  ///
  /// In en, this message translates to:
  /// **'Explore High Resolution Images'**
  String get feature1_title;

  /// No description provided for @feature1_description.
  ///
  /// In en, this message translates to:
  /// **'CircuitVerse can export high resolution images in multiple formats including SVG.'**
  String get feature1_description;

  /// No description provided for @feature2_title.
  ///
  /// In en, this message translates to:
  /// **'Combinational Analysis'**
  String get feature2_title;

  /// No description provided for @feature2_description.
  ///
  /// In en, this message translates to:
  /// **'Automatically generate circuit based on truth table data. This is great to create complex logic circuits and can be easily be made into a subcircuit.'**
  String get feature2_description;

  /// No description provided for @feature3_title.
  ///
  /// In en, this message translates to:
  /// **'Embed in Blogs'**
  String get feature3_title;

  /// No description provided for @feature3_description.
  ///
  /// In en, this message translates to:
  /// **'Since CircuitVerse is built in HTML5, an iFrame can be generated for each project allowing the user to embed it almost anywhere.'**
  String get feature3_description;

  /// No description provided for @feature4_title.
  ///
  /// In en, this message translates to:
  /// **'Use Sub circuits'**
  String get feature4_title;

  /// No description provided for @feature4_description.
  ///
  /// In en, this message translates to:
  /// **'Create subcircuits once and use them repeatedly. This allows easier and more structured design.'**
  String get feature4_description;

  /// No description provided for @feature5_title.
  ///
  /// In en, this message translates to:
  /// **'Multi Bit Buses and components'**
  String get feature5_title;

  /// No description provided for @feature5_description.
  ///
  /// In en, this message translates to:
  /// **'CircuitVerse supports multi bit wires, this means circuit design is easier, faster and uncluttered.'**
  String get feature5_description;

  /// No description provided for @editor_picks_title.
  ///
  /// In en, this message translates to:
  /// **'Editor Picks'**
  String get editor_picks_title;

  /// No description provided for @editor_picks_subtitle.
  ///
  /// In en, this message translates to:
  /// **'These circuits have been hand-picked by our authors for their awesomeness'**
  String get editor_picks_subtitle;

  /// No description provided for @explore_more_button.
  ///
  /// In en, this message translates to:
  /// **'Explore More'**
  String get explore_more_button;

  /// No description provided for @teachers_title.
  ///
  /// In en, this message translates to:
  /// **'TEACHERS'**
  String get teachers_title;

  /// No description provided for @teachers_description.
  ///
  /// In en, this message translates to:
  /// **'CircuitVerse has been designed to be very easy to use in class. The platform has features to assist teachers in class and assignments.'**
  String get teachers_description;

  /// No description provided for @benefits_title.
  ///
  /// In en, this message translates to:
  /// **'Benefits'**
  String get benefits_title;

  /// No description provided for @teachers_feature1_title.
  ///
  /// In en, this message translates to:
  /// **'Create Groups and add your students'**
  String get teachers_feature1_title;

  /// No description provided for @teachers_feature1_description.
  ///
  /// In en, this message translates to:
  /// **'You can create groups and add your students to them! If students are already registered with CircuitVerse they will be added automatically. If they are not registered with CircuitVerse yet, an invitation will be sent to register. Once they register, they will be added automatically.'**
  String get teachers_feature1_description;

  /// No description provided for @teachers_feature2_title.
  ///
  /// In en, this message translates to:
  /// **'Post Assignments'**
  String get teachers_feature2_title;

  /// No description provided for @teachers_feature2_description.
  ///
  /// In en, this message translates to:
  /// **'To create an assignment, simply click an add new assignment button. Give the details of the assignment and the deadline. The assignment will automatically close at deadline. Students cannot continue their assignment unless the teacher reopens the assignment again.'**
  String get teachers_feature2_description;

  /// No description provided for @teachers_feature3_title.
  ///
  /// In en, this message translates to:
  /// **'Grading assignments'**
  String get teachers_feature3_title;

  /// No description provided for @teachers_feature3_description.
  ///
  /// In en, this message translates to:
  /// **'Grade assignments very easily with the in build preview. Simply select the student, to his/her assignment work.'**
  String get teachers_feature3_description;

  /// No description provided for @teachers_feature4_title.
  ///
  /// In en, this message translates to:
  /// **'Use Interactive Circuits in your Blogs, Study Materials or PowerPoint presentations'**
  String get teachers_feature4_title;

  /// No description provided for @teachers_feature4_description.
  ///
  /// In en, this message translates to:
  /// **'Make sure the project is public. Click on embed, to get the embed HTML5 code, then simply embed the circuit. You may need to use a PowerPoint plugin like Live Slides to embed the live Circuit.'**
  String get teachers_feature4_description;

  /// No description provided for @contribute_title.
  ///
  /// In en, this message translates to:
  /// **'CONTRIBUTE'**
  String get contribute_title;

  /// No description provided for @contribute_description.
  ///
  /// In en, this message translates to:
  /// **'CircuitVerse aims to be free forever and we promise that we won\'t run any ads! The project is open source and to ensure its continued development and maintenance we need your support.'**
  String get contribute_description;

  /// No description provided for @email_us_title.
  ///
  /// In en, this message translates to:
  /// **'Email us at'**
  String get email_us_title;

  /// No description provided for @join_chat_title.
  ///
  /// In en, this message translates to:
  /// **'Join and chat with us at'**
  String get join_chat_title;

  /// No description provided for @slack_channel.
  ///
  /// In en, this message translates to:
  /// **'Slack channel'**
  String get slack_channel;

  /// No description provided for @open_source_title.
  ///
  /// In en, this message translates to:
  /// **'Contribute to open source'**
  String get open_source_title;

  /// No description provided for @how_to_support.
  ///
  /// In en, this message translates to:
  /// **'How to Support?'**
  String get how_to_support;

  /// No description provided for @student_role.
  ///
  /// In en, this message translates to:
  /// **'I am a Student'**
  String get student_role;

  /// No description provided for @student_support1.
  ///
  /// In en, this message translates to:
  /// **'Create amazing circuits and share on the platform'**
  String get student_support1;

  /// No description provided for @student_support2.
  ///
  /// In en, this message translates to:
  /// **'Find and report bugs. Become a bug hunter'**
  String get student_support2;

  /// No description provided for @student_support3.
  ///
  /// In en, this message translates to:
  /// **'Introduce the platform to your buddies'**
  String get student_support3;

  /// No description provided for @teacher_role.
  ///
  /// In en, this message translates to:
  /// **'I am a Teacher'**
  String get teacher_role;

  /// No description provided for @teacher_support1.
  ///
  /// In en, this message translates to:
  /// **'Introduce the platform to your students'**
  String get teacher_support1;

  /// No description provided for @teacher_support2.
  ///
  /// In en, this message translates to:
  /// **'Promote the platform within your circles'**
  String get teacher_support2;

  /// No description provided for @teacher_support3.
  ///
  /// In en, this message translates to:
  /// **'Create exciting educational content using CircuitVerse'**
  String get teacher_support3;

  /// No description provided for @developer_role.
  ///
  /// In en, this message translates to:
  /// **'I am a Developer'**
  String get developer_role;

  /// No description provided for @developer_support1.
  ///
  /// In en, this message translates to:
  /// **'Contribute to the OpenSource projects'**
  String get developer_support1;

  /// No description provided for @developer_support2.
  ///
  /// In en, this message translates to:
  /// **'Add and propose new features to the projects'**
  String get developer_support2;

  /// No description provided for @developer_support3.
  ///
  /// In en, this message translates to:
  /// **'Find and fix bugs in the CircuitVerse projects'**
  String get developer_support3;

  /// No description provided for @become_patreon.
  ///
  /// In en, this message translates to:
  /// **'Become a Patreon'**
  String get become_patreon;

  /// No description provided for @donate_paypal.
  ///
  /// In en, this message translates to:
  /// **'Donate through PayPal'**
  String get donate_paypal;

  /// No description provided for @profile_update_title.
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get profile_update_title;

  /// No description provided for @profile_picture.
  ///
  /// In en, this message translates to:
  /// **'Profile Picture'**
  String get profile_picture;

  /// No description provided for @profile_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get profile_name;

  /// No description provided for @profile_name_empty_error.
  ///
  /// In en, this message translates to:
  /// **'Name can\'t be empty'**
  String get profile_name_empty_error;

  /// No description provided for @profile_country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get profile_country;

  /// No description provided for @profile_educational_institute.
  ///
  /// In en, this message translates to:
  /// **'Educational Institute'**
  String get profile_educational_institute;

  /// No description provided for @profile_subscribe_mails.
  ///
  /// In en, this message translates to:
  /// **'Subscribe to mails?'**
  String get profile_subscribe_mails;

  /// No description provided for @profile_save_details.
  ///
  /// In en, this message translates to:
  /// **'Save Details'**
  String get profile_save_details;

  /// No description provided for @profile_updating.
  ///
  /// In en, this message translates to:
  /// **'Updating...'**
  String get profile_updating;

  /// No description provided for @profile_updated.
  ///
  /// In en, this message translates to:
  /// **'Profile Updated'**
  String get profile_updated;

  /// No description provided for @profile_update_success.
  ///
  /// In en, this message translates to:
  /// **'Your profile was successfully updated.'**
  String get profile_update_success;

  /// No description provided for @profile_update_error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while updating your profile.'**
  String get profile_update_error;

  /// No description provided for @no_favorites_title.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet!'**
  String get no_favorites_title;

  /// No description provided for @no_favorites_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Explore projects and add them to your favorites list'**
  String get no_favorites_subtitle;

  /// No description provided for @no_projects_title.
  ///
  /// In en, this message translates to:
  /// **'No Projects Yet!'**
  String get no_projects_title;

  /// No description provided for @no_projects_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Start fresh with a new design or fork existing templates'**
  String get no_projects_subtitle;

  /// No description provided for @forgot_password_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get forgot_password_email;

  /// No description provided for @forgot_password_email_validation_error.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get forgot_password_email_validation_error;

  /// No description provided for @forgot_password_send_instructions.
  ///
  /// In en, this message translates to:
  /// **'Send Instructions'**
  String get forgot_password_send_instructions;

  /// No description provided for @forgot_password_sending.
  ///
  /// In en, this message translates to:
  /// **'Sending..'**
  String get forgot_password_sending;

  /// No description provided for @forgot_password_new_user.
  ///
  /// In en, this message translates to:
  /// **'New User?'**
  String get forgot_password_new_user;

  /// No description provided for @forgot_password_sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get forgot_password_sign_up;

  /// No description provided for @forgot_password_sending_instructions.
  ///
  /// In en, this message translates to:
  /// **'Sending Instructions'**
  String get forgot_password_sending_instructions;

  /// No description provided for @forgot_password_instructions_sent_title.
  ///
  /// In en, this message translates to:
  /// **'Instructions Sent'**
  String get forgot_password_instructions_sent_title;

  /// No description provided for @forgot_password_instructions_sent_message.
  ///
  /// In en, this message translates to:
  /// **'Password reset instructions have been sent to your email'**
  String get forgot_password_instructions_sent_message;

  /// No description provided for @forgot_password_error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get forgot_password_error;

  /// No description provided for @forgot_password_link.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgot_password_link;

  /// No description provided for @login_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get login_email;

  /// No description provided for @login_email_validation_error.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get login_email_validation_error;

  /// No description provided for @login_password_validation_error.
  ///
  /// In en, this message translates to:
  /// **'Password can\'t be empty'**
  String get login_password_validation_error;

  /// No description provided for @login_forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get login_forgot_password;

  /// No description provided for @login_authenticating.
  ///
  /// In en, this message translates to:
  /// **'Authenticating...'**
  String get login_authenticating;

  /// No description provided for @login_button.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login_button;

  /// No description provided for @login_new_user.
  ///
  /// In en, this message translates to:
  /// **'New User?'**
  String get login_new_user;

  /// No description provided for @login_sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get login_sign_up;

  /// No description provided for @login_success_title.
  ///
  /// In en, this message translates to:
  /// **'Login Successful'**
  String get login_success_title;

  /// No description provided for @login_success_message.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get login_success_message;

  /// No description provided for @login_error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get login_error;

  /// No description provided for @signup_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get signup_name;

  /// No description provided for @signup_name_validation_error.
  ///
  /// In en, this message translates to:
  /// **'Name can\'t be empty'**
  String get signup_name_validation_error;

  /// No description provided for @signup_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get signup_email;

  /// No description provided for @signup_email_validation_error.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get signup_email_validation_error;

  /// No description provided for @signup_password_validation_error.
  ///
  /// In en, this message translates to:
  /// **'Password can\'t be empty'**
  String get signup_password_validation_error;

  /// No description provided for @signup_password_length_error.
  ///
  /// In en, this message translates to:
  /// **'Password length should be at least 6'**
  String get signup_password_length_error;

  /// No description provided for @signup_authenticating.
  ///
  /// In en, this message translates to:
  /// **'Authenticating...'**
  String get signup_authenticating;

  /// No description provided for @signup_register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get signup_register;

  /// No description provided for @signup_already_registered.
  ///
  /// In en, this message translates to:
  /// **'Already Registered?'**
  String get signup_already_registered;

  /// No description provided for @signup_login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get signup_login;

  /// No description provided for @signup_success_title.
  ///
  /// In en, this message translates to:
  /// **'Signup Successful'**
  String get signup_success_title;

  /// No description provided for @signup_success_message.
  ///
  /// In en, this message translates to:
  /// **'Welcome to CircuitVerse!'**
  String get signup_success_message;

  /// No description provided for @signup_error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get signup_error;

  /// No description provided for @assignment_letter_grade.
  ///
  /// In en, this message translates to:
  /// **'Letter Grade'**
  String get assignment_letter_grade;

  /// No description provided for @assignment_percent.
  ///
  /// In en, this message translates to:
  /// **'Percent'**
  String get assignment_percent;

  /// No description provided for @assignment_custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get assignment_custom;

  /// No description provided for @assignment_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get assignment_name;

  /// No description provided for @assignment_name_validation_error.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid name'**
  String get assignment_name_validation_error;

  /// No description provided for @assignment_deadline.
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get assignment_deadline;

  /// No description provided for @assignment_grading_scale.
  ///
  /// In en, this message translates to:
  /// **'Grading Scale'**
  String get assignment_grading_scale;

  /// No description provided for @assignment_elements_restriction.
  ///
  /// In en, this message translates to:
  /// **'Elements Restriction'**
  String get assignment_elements_restriction;

  /// No description provided for @assignment_enable_elements_restriction.
  ///
  /// In en, this message translates to:
  /// **'Enable elements restriction'**
  String get assignment_enable_elements_restriction;

  /// No description provided for @assignment_create.
  ///
  /// In en, this message translates to:
  /// **'Create Assignment'**
  String get assignment_create;

  /// No description provided for @assignment_adding.
  ///
  /// In en, this message translates to:
  /// **'Adding Assignment'**
  String get assignment_adding;

  /// No description provided for @assignment_added.
  ///
  /// In en, this message translates to:
  /// **'Assignment Added'**
  String get assignment_added;

  /// No description provided for @assignment_add_success.
  ///
  /// In en, this message translates to:
  /// **'New assignment was successfully added'**
  String get assignment_add_success;

  /// No description provided for @assignment_add_error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get assignment_add_error;

  /// No description provided for @assignment_add_title.
  ///
  /// In en, this message translates to:
  /// **'Add Assignment'**
  String get assignment_add_title;

  /// No description provided for @assignment_no_scale.
  ///
  /// In en, this message translates to:
  /// **'No Scale'**
  String get assignment_no_scale;

  /// No description provided for @assignment_details_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get assignment_details_edit;

  /// No description provided for @assignment_details_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get assignment_details_name;

  /// No description provided for @assignment_details_not_applicable.
  ///
  /// In en, this message translates to:
  /// **'N.A'**
  String get assignment_details_not_applicable;

  /// No description provided for @assignment_details_description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get assignment_details_description;

  /// No description provided for @assignment_details_submissions.
  ///
  /// In en, this message translates to:
  /// **'Submissions'**
  String get assignment_details_submissions;

  /// No description provided for @assignment_details_no_submissions_yet.
  ///
  /// In en, this message translates to:
  /// **'No Submissions yet!'**
  String get assignment_details_no_submissions_yet;

  /// No description provided for @assignment_details_adding_grades.
  ///
  /// In en, this message translates to:
  /// **'Adding Grades...'**
  String get assignment_details_adding_grades;

  /// No description provided for @assignment_details_project_graded_successfully.
  ///
  /// In en, this message translates to:
  /// **'Project Graded Successfully'**
  String get assignment_details_project_graded_successfully;

  /// No description provided for @assignment_details_project_graded_message.
  ///
  /// In en, this message translates to:
  /// **'You have graded the project'**
  String get assignment_details_project_graded_message;

  /// No description provided for @assignment_details_error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get assignment_details_error;

  /// No description provided for @assignment_details_updating_grade.
  ///
  /// In en, this message translates to:
  /// **'Updating Grade...'**
  String get assignment_details_updating_grade;

  /// No description provided for @assignment_details_grade_updated_successfully.
  ///
  /// In en, this message translates to:
  /// **'Grade updated Successfully'**
  String get assignment_details_grade_updated_successfully;

  /// No description provided for @assignment_details_grade_updated_message.
  ///
  /// In en, this message translates to:
  /// **'Grade has been updated successfully'**
  String get assignment_details_grade_updated_message;

  /// No description provided for @assignment_details_delete_grade.
  ///
  /// In en, this message translates to:
  /// **'Delete Grade'**
  String get assignment_details_delete_grade;

  /// No description provided for @assignment_details_delete_grade_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the grade?'**
  String get assignment_details_delete_grade_confirmation;

  /// No description provided for @assignment_details_delete.
  ///
  /// In en, this message translates to:
  /// **'DELETE'**
  String get assignment_details_delete;

  /// No description provided for @assignment_details_deleting_grade.
  ///
  /// In en, this message translates to:
  /// **'Deleting Grade...'**
  String get assignment_details_deleting_grade;

  /// No description provided for @assignment_details_grade_deleted.
  ///
  /// In en, this message translates to:
  /// **'Grade Deleted'**
  String get assignment_details_grade_deleted;

  /// No description provided for @assignment_details_grade_deleted_message.
  ///
  /// In en, this message translates to:
  /// **'Grade has been removed successfully'**
  String get assignment_details_grade_deleted_message;

  /// No description provided for @assignment_details_grades_and_remarks.
  ///
  /// In en, this message translates to:
  /// **'Grades & Remarks'**
  String get assignment_details_grades_and_remarks;

  /// No description provided for @assignment_details_grade.
  ///
  /// In en, this message translates to:
  /// **'Grade'**
  String get assignment_details_grade;

  /// No description provided for @assignment_details_grade_validation_error.
  ///
  /// In en, this message translates to:
  /// **'Grade can\'t be empty'**
  String get assignment_details_grade_validation_error;

  /// No description provided for @assignment_details_remarks.
  ///
  /// In en, this message translates to:
  /// **'Remarks'**
  String get assignment_details_remarks;

  /// No description provided for @assignment_details_update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get assignment_details_update;

  /// No description provided for @assignment_details_submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get assignment_details_submit;

  /// No description provided for @assignment_details_title.
  ///
  /// In en, this message translates to:
  /// **'Assignment Details'**
  String get assignment_details_title;

  /// No description provided for @assignment_details_deadline.
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get assignment_details_deadline;

  /// No description provided for @assignment_details_time_remaining.
  ///
  /// In en, this message translates to:
  /// **'Time Remaining'**
  String get assignment_details_time_remaining;

  /// No description provided for @assignment_details_days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get assignment_details_days;

  /// No description provided for @assignment_details_hours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get assignment_details_hours;

  /// No description provided for @assignment_details_minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get assignment_details_minutes;

  /// No description provided for @assignment_details_restricted_elements.
  ///
  /// In en, this message translates to:
  /// **'Restricted Elements'**
  String get assignment_details_restricted_elements;

  /// No description provided for @edit_group_updating.
  ///
  /// In en, this message translates to:
  /// **'Updating...'**
  String get edit_group_updating;

  /// No description provided for @edit_group_updated.
  ///
  /// In en, this message translates to:
  /// **'Group Updated'**
  String get edit_group_updated;

  /// No description provided for @edit_group_update_success.
  ///
  /// In en, this message translates to:
  /// **'Group has been successfully updated'**
  String get edit_group_update_success;

  /// No description provided for @edit_group_error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get edit_group_error;

  /// No description provided for @edit_group_title.
  ///
  /// In en, this message translates to:
  /// **'Edit Group'**
  String get edit_group_title;

  /// No description provided for @edit_group_description.
  ///
  /// In en, this message translates to:
  /// **'You can update Group details here. Don\'t leave the Group Name blank.'**
  String get edit_group_description;

  /// No description provided for @edit_group_name.
  ///
  /// In en, this message translates to:
  /// **'Group Name'**
  String get edit_group_name;

  /// No description provided for @edit_group_name_validation_error.
  ///
  /// In en, this message translates to:
  /// **'Please enter a Group Name'**
  String get edit_group_name_validation_error;

  /// No description provided for @edit_group_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get edit_group_save;

  /// No description provided for @group_details_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get group_details_edit;

  /// No description provided for @group_details_primary_mentor.
  ///
  /// In en, this message translates to:
  /// **'Primary Mentor'**
  String get group_details_primary_mentor;

  /// No description provided for @group_details_adding.
  ///
  /// In en, this message translates to:
  /// **'Adding...'**
  String get group_details_adding;

  /// No description provided for @group_details_members_added.
  ///
  /// In en, this message translates to:
  /// **'Group Members Added'**
  String get group_details_members_added;

  /// No description provided for @group_details_error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get group_details_error;

  /// No description provided for @group_details_add_members.
  ///
  /// In en, this message translates to:
  /// **'Add Group Members'**
  String get group_details_add_members;

  /// No description provided for @group_details_add_mentors.
  ///
  /// In en, this message translates to:
  /// **'Add Mentors'**
  String get group_details_add_mentors;

  /// No description provided for @group_details_add_members_description.
  ///
  /// In en, this message translates to:
  /// **'Enter Email IDs separated by commas. If users are not registered, an email ID will be sent requesting them to sign up.'**
  String get group_details_add_members_description;

  /// No description provided for @group_details_email_validation_error.
  ///
  /// In en, this message translates to:
  /// **'Enter emails in valid format'**
  String get group_details_email_validation_error;

  /// No description provided for @group_details_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get group_details_cancel;

  /// No description provided for @group_details_remove_member.
  ///
  /// In en, this message translates to:
  /// **'Remove Group Member'**
  String get group_details_remove_member;

  /// No description provided for @group_details_remove_mentor.
  ///
  /// In en, this message translates to:
  /// **'Remove Mentor'**
  String get group_details_remove_mentor;

  /// No description provided for @group_details_remove_member_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this group member?'**
  String get group_details_remove_member_confirmation;

  /// No description provided for @group_details_remove_mentor_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this mentor?'**
  String get group_details_remove_mentor_confirmation;

  /// No description provided for @group_details_remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get group_details_remove;

  /// No description provided for @group_details_removing.
  ///
  /// In en, this message translates to:
  /// **'Removing...'**
  String get group_details_removing;

  /// No description provided for @group_details_member_removed.
  ///
  /// In en, this message translates to:
  /// **'Group Member Removed'**
  String get group_details_member_removed;

  /// No description provided for @group_details_mentor_removed.
  ///
  /// In en, this message translates to:
  /// **'Mentor Removed'**
  String get group_details_mentor_removed;

  /// No description provided for @group_details_member_removed_success.
  ///
  /// In en, this message translates to:
  /// **'Successfully removed'**
  String get group_details_member_removed_success;

  /// No description provided for @group_details_mentors.
  ///
  /// In en, this message translates to:
  /// **'Mentors'**
  String get group_details_mentors;

  /// No description provided for @group_details_members.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get group_details_members;

  /// No description provided for @group_details_assignments.
  ///
  /// In en, this message translates to:
  /// **'Assignments'**
  String get group_details_assignments;

  /// No description provided for @group_details_add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get group_details_add;

  /// No description provided for @group_details_delete_assignment.
  ///
  /// In en, this message translates to:
  /// **'Delete Assignment'**
  String get group_details_delete_assignment;

  /// No description provided for @group_details_delete_assignment_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this assignment?'**
  String get group_details_delete_assignment_confirmation;

  /// No description provided for @group_details_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get group_details_delete;

  /// No description provided for @group_details_deleting_assignment.
  ///
  /// In en, this message translates to:
  /// **'Deleting Assignment...'**
  String get group_details_deleting_assignment;

  /// No description provided for @group_details_assignment_deleted.
  ///
  /// In en, this message translates to:
  /// **'Assignment Deleted'**
  String get group_details_assignment_deleted;

  /// No description provided for @group_details_assignment_deleted_success.
  ///
  /// In en, this message translates to:
  /// **'The assignment was successfully deleted'**
  String get group_details_assignment_deleted_success;

  /// No description provided for @group_details_reopen_assignment.
  ///
  /// In en, this message translates to:
  /// **'Reopen Assignment'**
  String get group_details_reopen_assignment;

  /// No description provided for @group_details_reopen_assignment_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reopen this assignment?'**
  String get group_details_reopen_assignment_confirmation;

  /// No description provided for @group_details_reopen.
  ///
  /// In en, this message translates to:
  /// **'Reopen'**
  String get group_details_reopen;

  /// No description provided for @group_details_reopening_assignment.
  ///
  /// In en, this message translates to:
  /// **'Reopening Assignment...'**
  String get group_details_reopening_assignment;

  /// No description provided for @group_details_assignment_reopened.
  ///
  /// In en, this message translates to:
  /// **'Assignment Reopened'**
  String get group_details_assignment_reopened;

  /// No description provided for @group_details_assignment_reopened_success.
  ///
  /// In en, this message translates to:
  /// **'The assignment is reopened now'**
  String get group_details_assignment_reopened_success;

  /// No description provided for @group_details_start_assignment.
  ///
  /// In en, this message translates to:
  /// **'Start Assignment'**
  String get group_details_start_assignment;

  /// No description provided for @group_details_start_assignment_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to start working on this assignment?'**
  String get group_details_start_assignment_confirmation;

  /// No description provided for @group_details_start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get group_details_start;

  /// No description provided for @group_details_starting_assignment.
  ///
  /// In en, this message translates to:
  /// **'Starting Assignment...'**
  String get group_details_starting_assignment;

  /// No description provided for @group_details_project_created.
  ///
  /// In en, this message translates to:
  /// **'Project Created'**
  String get group_details_project_created;

  /// No description provided for @group_details_project_created_success.
  ///
  /// In en, this message translates to:
  /// **'Project is successfully created'**
  String get group_details_project_created_success;

  /// No description provided for @group_details_member.
  ///
  /// In en, this message translates to:
  /// **'member'**
  String get group_details_member;

  /// No description provided for @group_details_mentor.
  ///
  /// In en, this message translates to:
  /// **'mentor'**
  String get group_details_mentor;

  /// No description provided for @group_details_make.
  ///
  /// In en, this message translates to:
  /// **'Make'**
  String get group_details_make;

  /// No description provided for @group_details_are_you_sure_you_want_to.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to'**
  String get group_details_are_you_sure_you_want_to;

  /// No description provided for @group_details_promote.
  ///
  /// In en, this message translates to:
  /// **'promote'**
  String get group_details_promote;

  /// No description provided for @group_details_demote.
  ///
  /// In en, this message translates to:
  /// **'demote'**
  String get group_details_demote;

  /// No description provided for @group_details_this_group.
  ///
  /// In en, this message translates to:
  /// **'this group'**
  String get group_details_this_group;

  /// No description provided for @group_details_to_a.
  ///
  /// In en, this message translates to:
  /// **'to a'**
  String get group_details_to_a;

  /// No description provided for @group_details_yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get group_details_yes;

  /// No description provided for @group_details_promoting.
  ///
  /// In en, this message translates to:
  /// **'Promoting...'**
  String get group_details_promoting;

  /// No description provided for @group_details_demoting.
  ///
  /// In en, this message translates to:
  /// **'Demoting...'**
  String get group_details_demoting;

  /// No description provided for @group_details_promoted.
  ///
  /// In en, this message translates to:
  /// **'Promoted'**
  String get group_details_promoted;

  /// No description provided for @group_details_demoted.
  ///
  /// In en, this message translates to:
  /// **'Demoted'**
  String get group_details_demoted;

  /// No description provided for @group_details_member_updated_success.
  ///
  /// In en, this message translates to:
  /// **'Group member was successfully updated'**
  String get group_details_member_updated_success;

  /// No description provided for @group_details_title.
  ///
  /// In en, this message translates to:
  /// **'Group Details'**
  String get group_details_title;

  /// No description provided for @my_groups_explore_message.
  ///
  /// In en, this message translates to:
  /// **'Explore and join groups of your school and friends!'**
  String get my_groups_explore_message;

  /// No description provided for @my_groups_delete_group.
  ///
  /// In en, this message translates to:
  /// **'Delete Group'**
  String get my_groups_delete_group;

  /// No description provided for @my_groups_delete_group_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this group?'**
  String get my_groups_delete_group_confirmation;

  /// No description provided for @my_groups_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get my_groups_delete;

  /// No description provided for @my_groups_deleting_group.
  ///
  /// In en, this message translates to:
  /// **'Deleting Group...'**
  String get my_groups_deleting_group;

  /// No description provided for @my_groups_group_deleted.
  ///
  /// In en, this message translates to:
  /// **'Group Deleted'**
  String get my_groups_group_deleted;

  /// No description provided for @my_groups_group_deleted_success.
  ///
  /// In en, this message translates to:
  /// **'Group was successfully deleted'**
  String get my_groups_group_deleted_success;

  /// No description provided for @my_groups_error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get my_groups_error;

  /// No description provided for @my_groups_owned.
  ///
  /// In en, this message translates to:
  /// **'Owned'**
  String get my_groups_owned;

  /// No description provided for @my_groups_view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get my_groups_view;

  /// No description provided for @my_groups_joined.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get my_groups_joined;

  /// No description provided for @my_groups_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get my_groups_edit;

  /// No description provided for @new_group_creating.
  ///
  /// In en, this message translates to:
  /// **'Creating...'**
  String get new_group_creating;

  /// No description provided for @new_group_created.
  ///
  /// In en, this message translates to:
  /// **'Group Created'**
  String get new_group_created;

  /// No description provided for @new_group_created_success.
  ///
  /// In en, this message translates to:
  /// **'New group was created successfully'**
  String get new_group_created_success;

  /// No description provided for @new_group_error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get new_group_error;

  /// No description provided for @new_group_title.
  ///
  /// In en, this message translates to:
  /// **'New Group'**
  String get new_group_title;

  /// No description provided for @new_group_description.
  ///
  /// In en, this message translates to:
  /// **'Groups can be used by mentors to set projects for and give grades to students'**
  String get new_group_description;

  /// No description provided for @new_group_name.
  ///
  /// In en, this message translates to:
  /// **'Group Name'**
  String get new_group_name;

  /// No description provided for @new_group_name_validation_error.
  ///
  /// In en, this message translates to:
  /// **'Please enter a Group Name'**
  String get new_group_name_validation_error;

  /// No description provided for @new_group_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get new_group_save;

  /// No description provided for @update_assignment_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get update_assignment_name;

  /// No description provided for @update_assignment_name_validation_error.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid name'**
  String get update_assignment_name_validation_error;

  /// No description provided for @update_assignment_description_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter assignment description...'**
  String get update_assignment_description_hint;

  /// No description provided for @update_assignment_deadline.
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get update_assignment_deadline;

  /// No description provided for @update_assignment_elements_restriction.
  ///
  /// In en, this message translates to:
  /// **'Elements restriction'**
  String get update_assignment_elements_restriction;

  /// No description provided for @update_assignment_enable_elements_restriction.
  ///
  /// In en, this message translates to:
  /// **'Enable elements restriction'**
  String get update_assignment_enable_elements_restriction;

  /// No description provided for @update_assignment_title.
  ///
  /// In en, this message translates to:
  /// **'Update Assignment'**
  String get update_assignment_title;

  /// No description provided for @update_assignment_updating.
  ///
  /// In en, this message translates to:
  /// **'Updating...'**
  String get update_assignment_updating;

  /// No description provided for @update_assignment_description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get update_assignment_description;

  /// No description provided for @update_assignment_updated.
  ///
  /// In en, this message translates to:
  /// **'Assignment Updated'**
  String get update_assignment_updated;

  /// No description provided for @update_assignment_update_success.
  ///
  /// In en, this message translates to:
  /// **'Assignment was updated successfully'**
  String get update_assignment_update_success;

  /// No description provided for @update_assignment_error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get update_assignment_error;

  /// No description provided for @ib_search_circuitverse.
  ///
  /// In en, this message translates to:
  /// **'Search CircuitVerse'**
  String get ib_search_circuitverse;

  /// No description provided for @ib_navigate_chapters.
  ///
  /// In en, this message translates to:
  /// **'Navigate to different chapters'**
  String get ib_navigate_chapters;

  /// No description provided for @ib_circuitverse.
  ///
  /// In en, this message translates to:
  /// **'CircuitVerse'**
  String get ib_circuitverse;

  /// No description provided for @ib_interactive_book.
  ///
  /// In en, this message translates to:
  /// **'Interactive Book'**
  String get ib_interactive_book;

  /// No description provided for @ib_return_home.
  ///
  /// In en, this message translates to:
  /// **'Return to Home'**
  String get ib_return_home;

  /// No description provided for @ib_home.
  ///
  /// In en, this message translates to:
  /// **'Interactive Book Home'**
  String get ib_home;

  /// No description provided for @ib_loading_chapters.
  ///
  /// In en, this message translates to:
  /// **'Loading Chapters...'**
  String get ib_loading_chapters;

  /// No description provided for @ib_show_toc.
  ///
  /// In en, this message translates to:
  /// **'Show Table of Contents'**
  String get ib_show_toc;

  /// No description provided for @ib_page_copyright_notice.
  ///
  /// In en, this message translates to:
  /// **'Copyright © 2021 Contributors to CircuitVerse. Distributed under a [CC-by-sa] license.'**
  String get ib_page_copyright_notice;

  /// No description provided for @ib_page_table_of_contents.
  ///
  /// In en, this message translates to:
  /// **'Table of Contents'**
  String get ib_page_table_of_contents;

  /// No description provided for @ib_page_navigate_previous.
  ///
  /// In en, this message translates to:
  /// **'Tap to navigate to previous page'**
  String get ib_page_navigate_previous;

  /// No description provided for @ib_page_navigate_next.
  ///
  /// In en, this message translates to:
  /// **'Tap to navigate to next page'**
  String get ib_page_navigate_next;

  /// No description provided for @ib_page_loading_image.
  ///
  /// In en, this message translates to:
  /// **'Loading image...'**
  String get ib_page_loading_image;

  /// No description provided for @ib_page_image_load_error.
  ///
  /// In en, this message translates to:
  /// **'Failed to load image'**
  String get ib_page_image_load_error;

  /// No description provided for @ib_page_no_image_source.
  ///
  /// In en, this message translates to:
  /// **'No image source provided'**
  String get ib_page_no_image_source;

  /// No description provided for @notifications_no_notifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get notifications_no_notifications;

  /// No description provided for @notifications_will_appear.
  ///
  /// In en, this message translates to:
  /// **'Your notifications will appear here'**
  String get notifications_will_appear;

  /// No description provided for @notifications_no_unread.
  ///
  /// In en, this message translates to:
  /// **'No unread notifications'**
  String get notifications_no_unread;

  /// No description provided for @notifications_no_unread_desc.
  ///
  /// In en, this message translates to:
  /// **'You have no unread notifications'**
  String get notifications_no_unread_desc;

  /// No description provided for @notifications_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get notifications_all;

  /// No description provided for @notifications_unread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get notifications_unread;

  /// No description provided for @notifications_starred.
  ///
  /// In en, this message translates to:
  /// **'starred'**
  String get notifications_starred;

  /// No description provided for @notifications_forked.
  ///
  /// In en, this message translates to:
  /// **'forked'**
  String get notifications_forked;

  /// No description provided for @notifications_your_project.
  ///
  /// In en, this message translates to:
  /// **'your project'**
  String get notifications_your_project;

  /// No description provided for @profile_view_not_available.
  ///
  /// In en, this message translates to:
  /// **'N.A'**
  String get profile_view_not_available;

  /// No description provided for @profile_view_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profile_view_edit;

  /// No description provided for @profile_view_joined.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get profile_view_joined;

  /// No description provided for @profile_view_country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get profile_view_country;

  /// No description provided for @profile_view_educational_institute.
  ///
  /// In en, this message translates to:
  /// **'Educational Institute'**
  String get profile_view_educational_institute;

  /// No description provided for @profile_view_subscribed_to_mails.
  ///
  /// In en, this message translates to:
  /// **'Subscribed to mails'**
  String get profile_view_subscribed_to_mails;

  /// No description provided for @profile_view_yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get profile_view_yes;

  /// No description provided for @profile_view_no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get profile_view_no;

  /// No description provided for @profile_view_title.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile_view_title;

  /// No description provided for @profile_view_circuits.
  ///
  /// In en, this message translates to:
  /// **'Circuits'**
  String get profile_view_circuits;

  /// No description provided for @profile_view_favourites.
  ///
  /// In en, this message translates to:
  /// **'Favourites'**
  String get profile_view_favourites;

  /// No description provided for @edit_project_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get edit_project_name;

  /// No description provided for @edit_project_name_validation_error.
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty'**
  String get edit_project_name_validation_error;

  /// No description provided for @edit_project_tags_list.
  ///
  /// In en, this message translates to:
  /// **'Tags List'**
  String get edit_project_tags_list;

  /// No description provided for @edit_project_access_type.
  ///
  /// In en, this message translates to:
  /// **'Project Access Type'**
  String get edit_project_access_type;

  /// No description provided for @edit_project_access_type_validation_error.
  ///
  /// In en, this message translates to:
  /// **'Please select project access type'**
  String get edit_project_access_type_validation_error;

  /// No description provided for @edit_project_public.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get edit_project_public;

  /// No description provided for @edit_project_private.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get edit_project_private;

  /// No description provided for @edit_project_limited_access.
  ///
  /// In en, this message translates to:
  /// **'Limited Access'**
  String get edit_project_limited_access;

  /// No description provided for @edit_project_updating.
  ///
  /// In en, this message translates to:
  /// **'Updating project...'**
  String get edit_project_updating;

  /// No description provided for @edit_project_updated.
  ///
  /// In en, this message translates to:
  /// **'Project updated'**
  String get edit_project_updated;

  /// No description provided for @edit_project_update_success.
  ///
  /// In en, this message translates to:
  /// **'Project updated successfully'**
  String get edit_project_update_success;

  /// No description provided for @edit_project_error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get edit_project_error;

  /// No description provided for @edit_project_title.
  ///
  /// In en, this message translates to:
  /// **'Update Project'**
  String get edit_project_title;

  /// No description provided for @edit_project_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit_project_edit;

  /// No description provided for @edit_project_details.
  ///
  /// In en, this message translates to:
  /// **'Project Details'**
  String get edit_project_details;

  /// No description provided for @edit_project_share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get edit_project_share;

  /// No description provided for @edit_project_fork.
  ///
  /// In en, this message translates to:
  /// **'Fork'**
  String get edit_project_fork;

  /// No description provided for @edit_project_stars.
  ///
  /// In en, this message translates to:
  /// **'Stars'**
  String get edit_project_stars;

  /// No description provided for @edit_project_views.
  ///
  /// In en, this message translates to:
  /// **'Views'**
  String get edit_project_views;

  /// No description provided for @edit_project_author.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get edit_project_author;

  /// No description provided for @edit_project_description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get edit_project_description;

  /// No description provided for @edit_project_add_collaborator.
  ///
  /// In en, this message translates to:
  /// **'Add Collaborator'**
  String get edit_project_add_collaborator;

  /// No description provided for @edit_project_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get edit_project_delete;

  /// No description provided for @edit_project_collaborators.
  ///
  /// In en, this message translates to:
  /// **'Collaborators'**
  String get edit_project_collaborators;

  /// No description provided for @edit_project_fork_project.
  ///
  /// In en, this message translates to:
  /// **'Fork Project'**
  String get edit_project_fork_project;

  /// No description provided for @edit_project_fork_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to fork this project?'**
  String get edit_project_fork_confirmation;

  /// No description provided for @edit_project_forking.
  ///
  /// In en, this message translates to:
  /// **'Forking'**
  String get edit_project_forking;

  /// No description provided for @edit_project_starred.
  ///
  /// In en, this message translates to:
  /// **'Project starred'**
  String get edit_project_starred;

  /// No description provided for @edit_project_unstarred.
  ///
  /// In en, this message translates to:
  /// **'Project unstarred'**
  String get edit_project_unstarred;

  /// No description provided for @edit_project_starred_success.
  ///
  /// In en, this message translates to:
  /// **'You have successfully starred the project'**
  String get edit_project_starred_success;

  /// No description provided for @edit_project_unstarred_success.
  ///
  /// In en, this message translates to:
  /// **'You have successfully unstarred the project'**
  String get edit_project_unstarred_success;

  /// No description provided for @edit_project_add_collaborators.
  ///
  /// In en, this message translates to:
  /// **'Add Collaborators'**
  String get edit_project_add_collaborators;

  /// No description provided for @edit_project_email_ids.
  ///
  /// In en, this message translates to:
  /// **'Email IDs'**
  String get edit_project_email_ids;

  /// No description provided for @edit_project_email_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter email IDs separated by comma'**
  String get edit_project_email_hint;

  /// No description provided for @edit_project_adding.
  ///
  /// In en, this message translates to:
  /// **'Adding'**
  String get edit_project_adding;

  /// No description provided for @edit_project_collaborators_added.
  ///
  /// In en, this message translates to:
  /// **'Collaborators added'**
  String get edit_project_collaborators_added;

  /// No description provided for @edit_project_delete_project.
  ///
  /// In en, this message translates to:
  /// **'Delete Project'**
  String get edit_project_delete_project;

  /// No description provided for @edit_project_delete_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this project?'**
  String get edit_project_delete_confirmation;

  /// No description provided for @edit_project_deleting.
  ///
  /// In en, this message translates to:
  /// **'Deleting'**
  String get edit_project_deleting;

  /// No description provided for @edit_project_deleted.
  ///
  /// In en, this message translates to:
  /// **'Project deleted'**
  String get edit_project_deleted;

  /// No description provided for @edit_project_delete_success.
  ///
  /// In en, this message translates to:
  /// **'Project deleted successfully'**
  String get edit_project_delete_success;

  /// No description provided for @edit_project_delete_collaborator.
  ///
  /// In en, this message translates to:
  /// **'Remove Collaborator'**
  String get edit_project_delete_collaborator;

  /// No description provided for @edit_project_delete_collaborator_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this collaborator?'**
  String get edit_project_delete_collaborator_confirmation;

  /// No description provided for @edit_project_collaborator_deleted.
  ///
  /// In en, this message translates to:
  /// **'Collaborator removed'**
  String get edit_project_collaborator_deleted;

  /// No description provided for @edit_project_collaborator_delete_success.
  ///
  /// In en, this message translates to:
  /// **'Collaborator removed successfully'**
  String get edit_project_collaborator_delete_success;

  /// No description provided for @edit_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get edit_cancel;

  /// No description provided for @edit_add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get edit_add;

  /// No description provided for @featured_no_result_found.
  ///
  /// In en, this message translates to:
  /// **'No result found'**
  String get featured_no_result_found;

  /// No description provided for @featured_editor_picks.
  ///
  /// In en, this message translates to:
  /// **'Editor\'s Picks'**
  String get featured_editor_picks;

  /// No description provided for @featured_editor_picks_description.
  ///
  /// In en, this message translates to:
  /// **'Curated list of the best projects'**
  String get featured_editor_picks_description;

  /// No description provided for @featured_search_for_circuits.
  ///
  /// In en, this message translates to:
  /// **'Search for circuits'**
  String get featured_search_for_circuits;

  /// No description provided for @featured_circuits.
  ///
  /// In en, this message translates to:
  /// **'Featured Circuits'**
  String get featured_circuits;

  /// No description provided for @cv_title.
  ///
  /// In en, this message translates to:
  /// **'CircuitVerse'**
  String get cv_title;

  /// No description provided for @cv_groups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get cv_groups;

  /// No description provided for @cv_profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get cv_profile;

  /// No description provided for @cv_featured_circuits.
  ///
  /// In en, this message translates to:
  /// **'Featured Circuits'**
  String get cv_featured_circuits;

  /// No description provided for @cv_logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get cv_logout;

  /// No description provided for @cv_logout_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get cv_logout_confirmation;

  /// No description provided for @cv_logout_confirmation_button.
  ///
  /// In en, this message translates to:
  /// **'LOGOUT'**
  String get cv_logout_confirmation_button;

  /// No description provided for @cv_logout_success.
  ///
  /// In en, this message translates to:
  /// **'Logged Out Successfully'**
  String get cv_logout_success;

  /// No description provided for @cv_logout_success_acknowledgement.
  ///
  /// In en, this message translates to:
  /// **'You have been signed out.'**
  String get cv_logout_success_acknowledgement;

  /// No description provided for @cv_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get cv_home;

  /// No description provided for @cv_explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get cv_explore;

  /// No description provided for @cv_simulator.
  ///
  /// In en, this message translates to:
  /// **'Simulator'**
  String get cv_simulator;

  /// No description provided for @cv_interactive_book.
  ///
  /// In en, this message translates to:
  /// **'Interactive Book'**
  String get cv_interactive_book;

  /// No description provided for @cv_about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get cv_about;

  /// No description provided for @cv_contribute.
  ///
  /// In en, this message translates to:
  /// **'Contribute'**
  String get cv_contribute;

  /// No description provided for @cv_teachers.
  ///
  /// In en, this message translates to:
  /// **'Teachers'**
  String get cv_teachers;

  /// No description provided for @cv_my_groups.
  ///
  /// In en, this message translates to:
  /// **'My Groups'**
  String get cv_my_groups;

  /// No description provided for @cv_login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get cv_login;

  /// No description provided for @cv_notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get cv_notifications;

  /// No description provided for @cv_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get cv_language;

  /// No description provided for @terms_of_service.
  ///
  /// In en, this message translates to:
  /// **'Terms Of Service'**
  String get terms_of_service;

  /// No description provided for @privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy_policy;

  /// No description provided for @loading_contributors.
  ///
  /// In en, this message translates to:
  /// **'Loading Contributors ...'**
  String get loading_contributors;

  /// No description provided for @about_title.
  ///
  /// In en, this message translates to:
  /// **'ABOUT'**
  String get about_title;

  /// No description provided for @about_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Learn about the Awesome people behind CircuitVerse'**
  String get about_subtitle;

  /// No description provided for @about_description.
  ///
  /// In en, this message translates to:
  /// **'CircuitVerse is a product developed by students at IIIT-Bangalore. It aims to provide a platform where circuits can be designed and simulated using a graphical user interface. While users can design complete CPU implementations within the simulator, the software is designed primarily for educational use. CircuitVerse is an opensource project with an active community. Checkout the contribute page for more detail.'**
  String get about_description;

  /// No description provided for @email_us_at.
  ///
  /// In en, this message translates to:
  /// **'Email us at'**
  String get email_us_at;

  /// No description provided for @join_slack.
  ///
  /// In en, this message translates to:
  /// **'Join and chat with us at'**
  String get join_slack;

  /// No description provided for @about_slack_channel.
  ///
  /// In en, this message translates to:
  /// **'Slack channel'**
  String get about_slack_channel;

  /// No description provided for @contributors.
  ///
  /// In en, this message translates to:
  /// **'Contributors'**
  String get contributors;

  /// No description provided for @contributors_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Meet the awesome people of CircuitVerse community that\'ve made this platform what it is now.'**
  String get contributors_subtitle;

  /// No description provided for @tos_section1_title.
  ///
  /// In en, this message translates to:
  /// **'1. User Agreement'**
  String get tos_section1_title;

  /// No description provided for @tos_section1_text1_string1.
  ///
  /// In en, this message translates to:
  /// **'1.1 These Terms of Use constitute an agreement between you and the CircuitVerse Team that governs your use of '**
  String get tos_section1_text1_string1;

  /// No description provided for @tos_section1_text1_string2.
  ///
  /// In en, this message translates to:
  /// **'. The CircuitVerse Team comprises of faculty and students of International Institute of Information Technology, Bangalore (\"IIIT-Bangalore\"). Please read the Terms of Use carefully. By using CircuitVerse you affirm that you have read, understood, and accepted the terms and conditions in the Terms of Use. If you do not agree with any of these conditions, please do not use CircuitVerse.\n\n'**
  String get tos_section1_text1_string2;

  /// No description provided for @tos_section1_text2.
  ///
  /// In en, this message translates to:
  /// **'1.2 Your privacy is important to us. Please read our Privacy Policy, which identifies how the CircuitVerse Team uses, collects, and stores information it collects through the Services. By using CircuitVerse, you additionally agree that you are comfortable with CircuitVerse\'s Privacy Policy.\n\n'**
  String get tos_section1_text2;

  /// No description provided for @tos_section1_text3.
  ///
  /// In en, this message translates to:
  /// **'1.3 CircuitVerse is open to children and adults of all ages, and we ask that you keep this in mind when using the CircuitVerse services.\n\n'**
  String get tos_section1_text3;

  /// No description provided for @tos_section1_text4_string1.
  ///
  /// In en, this message translates to:
  /// **'1.4 The CircuitVerse Team may change the Terms of Use from time to time. You can always find the latest version of the Terms of Use at '**
  String get tos_section1_text4_string1;

  /// No description provided for @tos_section1_text4_string2.
  ///
  /// In en, this message translates to:
  /// **'. Your continued use of the Services constitutes your acceptance of any changes to or revisions of the Terms of Use.\n'**
  String get tos_section1_text4_string2;

  /// No description provided for @tos_section2_title.
  ///
  /// In en, this message translates to:
  /// **'2. Account Creation and Maintenance'**
  String get tos_section2_title;

  /// No description provided for @tos_section2_text1_string1.
  ///
  /// In en, this message translates to:
  /// **'2.1 In order to use some features of the Services, you will need to register with CircuitVerse and create an account. Creating an account is optional, but without an account, you will not be able to save or publish projects or comments on CircuitVerse. When registering for a personal account, you will be asked to provide certain personal information, such as your email address, gender, birth month and year, and country. Please see CircuitVerse\'s '**
  String get tos_section2_text1_string1;

  /// No description provided for @tos_section2_text1_string2.
  ///
  /// In en, this message translates to:
  /// **' for CircuitVerse\'s data retention and usage policies.\n\n'**
  String get tos_section2_text1_string2;

  /// No description provided for @tos_section2_text2.
  ///
  /// In en, this message translates to:
  /// **'2.2 You are responsible for keeping your password secret and your account secure. You are solely responsible for any use of your account, even if your account is used by another person. If any use of your account violates the Terms of Service, your account may be suspended or deleted.\n\n'**
  String get tos_section2_text2;

  /// No description provided for @tos_section2_text3.
  ///
  /// In en, this message translates to:
  /// **'2.3 You may not use another person\'s CircuitVerse account without permission.\n\n'**
  String get tos_section2_text3;

  /// No description provided for @tos_section2_text4.
  ///
  /// In en, this message translates to:
  /// **'2.4 If you have reason to believe that your account is no longer secure (for example, in the event of a loss, theft, or unauthorized disclosure of your password), promptly change your password. If you cannot access your account to change your password, notify us at '**
  String get tos_section2_text4;

  /// No description provided for @full_stop.
  ///
  /// In en, this message translates to:
  /// **'.\n'**
  String get full_stop;

  /// No description provided for @tos_section3_title.
  ///
  /// In en, this message translates to:
  /// **'3. Rules of Usage'**
  String get tos_section3_title;

  /// No description provided for @tos_section3_text1.
  ///
  /// In en, this message translates to:
  /// **'3.1 The CircuitVerse Team supports freedom of expression. However, CircuitVerse is intended for a wide audience, and some content is inappropriate for the CircuitVerse community. You may not use the CircuitVerse service in any way, that:\n\n'**
  String get tos_section3_text1;

  /// No description provided for @tos_section3_item1.
  ///
  /// In en, this message translates to:
  /// **'\t1. Posting content deliberately designed to crash the CircuitVerse website or editor;\n\n'**
  String get tos_section3_item1;

  /// No description provided for @tos_section3_item2.
  ///
  /// In en, this message translates to:
  /// **'\t2. Linking to pages containing viruses or malware;\n\n'**
  String get tos_section3_item2;

  /// No description provided for @tos_section3_item3.
  ///
  /// In en, this message translates to:
  /// **'\t3. Using administrator passwords or pretending to be an administrator;\n\n'**
  String get tos_section3_item3;

  /// No description provided for @tos_section3_item4.
  ///
  /// In en, this message translates to:
  /// **'\t4. Repeatedly posting the same material, or \"spamming\";\n\n'**
  String get tos_section3_item4;

  /// No description provided for @tos_section3_item5.
  ///
  /// In en, this message translates to:
  /// **'\t5. Using alternate accounts or organizing voting groups to manipulate site statistics, such as purposely trying to get on the \"What the Community is Loving/Remixing\" rows of the front page.\n\n'**
  String get tos_section3_item5;

  /// No description provided for @tos_section4_title.
  ///
  /// In en, this message translates to:
  /// **'4. User-Generated Content and Licensing'**
  String get tos_section4_title;

  /// No description provided for @tos_section4_text1.
  ///
  /// In en, this message translates to:
  /// **'4.1 For the purposes of the Terms of Use, \"user-generated content\" includes any projects, comments, forum posts, or links to third party websites that a user submits to CircuitVerse.\n\n'**
  String get tos_section4_text1;

  /// No description provided for @tos_section4_text2.
  ///
  /// In en, this message translates to:
  /// **'4.2 The CircuitVerse Team encourages everyone to foster creativity by freely sharing knowledge in any form. However, we also understand the need for individuals and companies to protect their intellectual property rights. You are responsible for making sure you have the necessary rights, licenses, or permission for any user-generated content you submit to CircuitVerse.\n\n'**
  String get tos_section4_text2;

  /// No description provided for @tos_section4_text3_string1.
  ///
  /// In en, this message translates to:
  /// **'4.3 All user-generated content you submit to CircuitVerse is licensed to and through CircuitVerse under the '**
  String get tos_section4_text3_string1;

  /// No description provided for @tos_section4_text3_link.
  ///
  /// In en, this message translates to:
  /// **'Creative Commons Attribution-ShareAlike 2.0 license'**
  String get tos_section4_text3_link;

  /// No description provided for @tos_section4_text3_string2.
  ///
  /// In en, this message translates to:
  /// **'. This allows others to view and fork your content. This license also allows the CircuitVerse Team to display, distribute, and reproduce your content on the CircuitVerse website, through social media channels, and elsewhere. If you do not want to license your content under this license, then do not share it on CircuitVerse.\n\n'**
  String get tos_section4_text3_string2;

  /// No description provided for @tos_section4_text4.
  ///
  /// In en, this message translates to:
  /// **'4.4 In addition to reviewing reported user-generated content, the CircuitVerse Team reserves the right, but is not obligated, to monitor all uses of the CircuitVerse service. The CircuitVerse Team may edit, move, or delete any content that violates the Terms of Use or Community Guidelines, without notice.\n\n'**
  String get tos_section4_text4;

  /// No description provided for @tos_section4_text5.
  ///
  /// In en, this message translates to:
  /// **'4.5 All user-generated content is provided as-is. The CircuitVerse Team makes no warranties about the accuracy or reliability of any user-generated content available through CircuitVerse and does not endorse CircuitVerse Day events or vet or verify information posted in connection with said events. The CircuitVerse Team does not endorse any views, opinions, or advice expressed in user-generated content. You agree to relieve the CircuitVerse Team of any and all liability arising from your user-generated content and from CircuitVerse Day events you may organize or host.\n\n'**
  String get tos_section4_text5;

  /// No description provided for @tos_section5_title.
  ///
  /// In en, this message translates to:
  /// **'5. CircuitVerse Content and Licensing'**
  String get tos_section5_title;

  /// No description provided for @tos_section5_text1.
  ///
  /// In en, this message translates to:
  /// **'5.1 Except for any user-generated content, the CircuitVerse Team owns and retains all rights in and to the CircuitVerse code, the design, functionality, and architecture of CircuitVerse, and any software or content provided through CircuitVerse (collectively \"the CircuitVerse IP\"). If you want to use CircuitVerse in a way that is not allowed by these Terms of Use, you must first contact the CircuitVerse Team. Except for any rights explicitly granted under these Terms of Use, you are not granted any rights in and to any CircuitVerse IP.\n\n'**
  String get tos_section5_text1;

  /// No description provided for @tos_section6_title.
  ///
  /// In en, this message translates to:
  /// **'6. Digital Millennium Copyright Act (DMCA)'**
  String get tos_section6_title;

  /// No description provided for @tos_section6_text1.
  ///
  /// In en, this message translates to:
  /// **'6.1 If you are a copyright holder and believe that content on CircuitVerse violates your rights, you may send a mail to '**
  String get tos_section6_text1;

  /// No description provided for @tos_section6_text2.
  ///
  /// In en, this message translates to:
  /// **'.\n\n6.2 If you are a CircuitVerse user and you believe that your content did not constitute a copyright violation and was taken down in error, you may send a notification to support@CircuitVerse.org. Please include:\n\n'**
  String get tos_section6_text2;

  /// No description provided for @tos_section6_item1.
  ///
  /// In en, this message translates to:
  /// **'\t• Your CircuitVerse username and email address;\n\n'**
  String get tos_section6_item1;

  /// No description provided for @tos_section6_item2.
  ///
  /// In en, this message translates to:
  /// **'\t• The specific content you believe was taken down in error; and\n\n'**
  String get tos_section6_item2;

  /// No description provided for @tos_section6_item3.
  ///
  /// In en, this message translates to:
  /// **'\t• A brief statement of why you believe there was no copyright violation (e.g., the content was not copyrighted, you had permission to use the content, or your use of the content was a \"fair use\").\n\n'**
  String get tos_section6_item3;

  /// No description provided for @tos_section7_title.
  ///
  /// In en, this message translates to:
  /// **'7. Suspension and Termination of Accounts'**
  String get tos_section7_title;

  /// No description provided for @tos_section7_text1.
  ///
  /// In en, this message translates to:
  /// **'7.1 CircuitVerse has the right to suspend your account for violations of the Terms of Use or Community Guidelines. Repeat violators may have their account deleted. The CircuitVerse Team reserves the sole right to determine what constitutes a violation of the Terms of Use or Community Guidelines. The CircuitVerse Team also reserves the right to terminate any account used to circumvent prior enforcement of the Terms of Use.\n\n'**
  String get tos_section7_text1;

  /// No description provided for @tos_section7_text2.
  ///
  /// In en, this message translates to:
  /// **'7.2 If you want to delete or temporarily disable your account, please email '**
  String get tos_section7_text2;

  /// No description provided for @tos_section8_title.
  ///
  /// In en, this message translates to:
  /// **'8. Third Party Websites'**
  String get tos_section8_title;

  /// No description provided for @tos_section8_text1.
  ///
  /// In en, this message translates to:
  /// **'8.1 Content on CircuitVerse, including user-generated content, may include links to third-party websites. The CircuitVerse Team is not capable of reviewing or managing third-party websites, and assumes no responsibility for the privacy practices, content, or functionality of third party websites. You agree to relieve the CircuitVerse Team of any and all liability arising from third party websites.\n\n'**
  String get tos_section8_text1;

  /// No description provided for @tos_section9_title.
  ///
  /// In en, this message translates to:
  /// **'9. Indemnification'**
  String get tos_section9_title;

  /// No description provided for @tos_section9_text1.
  ///
  /// In en, this message translates to:
  /// **'You agree to indemnify IIIT-Bangalore, the CircuitVerse Team, the CircuitVerse Foundation, and all their affiliates, employees, faculty members, fellows, students, agents, representatives, third party service providers, and members of their governing boards (all of which are \"CircuitVerse Entities\"), and to defend and hold each of them harmless, from any and all claims and liabilities (including attorneys\' fees) arising out of or related to your breach of the Terms of Service or your use of CircuitVerse.\n\n'**
  String get tos_section9_text1;

  /// No description provided for @tos_section9_text2.
  ///
  /// In en, this message translates to:
  /// **'For federal government agencies, provisions in the Terms of Use relating to Indemnification shall not apply to your Official Use, except to the extent expressly authorized by federal law. For state and local government agencies in the United States, Terms of Use relating to Indemnification shall apply to your Official Use only to the extent authorized by the laws of your jurisdiction.\n\n'**
  String get tos_section9_text2;

  /// No description provided for @tos_section10_title.
  ///
  /// In en, this message translates to:
  /// **'10. Disclaimer of Warranty'**
  String get tos_section10_title;

  /// No description provided for @tos_section10_text1.
  ///
  /// In en, this message translates to:
  /// **'You acknowledge that you are using CircuitVerse at your own risk. CircuitVerse is provided \"as is,\" and the CircuitVerse Entities hereby expressly disclaim any and all warranties, express and implied, including but not limited to any warranties of accuracy, reliability, title, merchantability, non-infringement, fitness for a particular purpose or any other warranty, condition, guarantee or representation, whether oral, in writing or in electronic form, including but not limited to the accuracy or completeness of any information contained therein or provided by CircuitVerse. Without limiting the foregoing, the CircuitVerse Entities disclaim any and all warranties, express and implied, regarding user-generated content and CircuitVerse Day events. The CircuitVerse Entities and their third party service providers do not represent or warrant that access to CircuitVerse will be uninterrupted or that there will be no failures, errors or omissions or loss of transmitted information, or that no viruses will be transmitted through CircuitVerse services.\n\n'**
  String get tos_section10_text1;

  /// No description provided for @tos_section11_title.
  ///
  /// In en, this message translates to:
  /// **'11. Limitation of Liability'**
  String get tos_section11_title;

  /// No description provided for @tos_section11_text1.
  ///
  /// In en, this message translates to:
  /// **'The CircuitVerse Entities shall not be liable to you or any third parties for any direct, indirect, special, consequential or punitive damages of any kind, regardless of the type of claim or the nature of the cause of action, even if the CircuitVerse Team has been advised of the possibility of such damages. Without limiting the foregoing, the CircuitVerse Entities shall have no liability to you or any third parties for damages or harms arising out of user-generated content or CircuitVerse Day events.\n\n'**
  String get tos_section11_text1;

  /// No description provided for @tos_section12_title.
  ///
  /// In en, this message translates to:
  /// **'12. Choice of Language'**
  String get tos_section12_title;

  /// No description provided for @tos_section12_text1.
  ///
  /// In en, this message translates to:
  /// **'If the CircuitVerse Team provides you with a translation of the English language version of these Terms of Use, the Privacy Policy, or any other policy, then you agree that the translation is provided for informational purposes only and does not modify the English language version. In the event of a conflict between a translation and the English version, the English version will govern.\n\n'**
  String get tos_section12_text1;

  /// No description provided for @tos_section13_title.
  ///
  /// In en, this message translates to:
  /// **'13. No Waiver'**
  String get tos_section13_title;

  /// No description provided for @tos_section13_text1.
  ///
  /// In en, this message translates to:
  /// **'No waiver of any term of these Terms of Use shall be deemed a further or continuing waiver of such term or any other term, and the CircuitVerse Team\'s failure to assert any right or provision under these Terms of Use shall not constitute a waiver of such right or provision.\n\n'**
  String get tos_section13_text1;

  /// No description provided for @privacy_section1_text.
  ///
  /// In en, this message translates to:
  /// **'\nWe recognize that your privacy is very important and take it seriously. Our CircuitVerse Privacy Policy (“Privacy Policy”) describes our policies and procedures on the collection, use, disclosure, and sharing of your information when you use our Platform. We will not use or share your information with anyone except as described in this Privacy Policy. Capitalized terms that are not defined in this Privacy Policy have the meaning given them in our '**
  String get privacy_section1_text;

  /// No description provided for @privacy_section_2_title.
  ///
  /// In en, this message translates to:
  /// **'The Information We Collect'**
  String get privacy_section_2_title;

  /// No description provided for @privacy_section2_text.
  ///
  /// In en, this message translates to:
  /// **'We collect information directly from individuals automatically through the CircuitVerse Platform.\n\n'**
  String get privacy_section2_text;

  /// No description provided for @privacy_section2_item1.
  ///
  /// In en, this message translates to:
  /// **'Account and Profile Information: '**
  String get privacy_section2_item1;

  /// No description provided for @privacy_section2_item1_text.
  ///
  /// In en, this message translates to:
  /// **'When you create an account and profile on the CircuitVerse Platform, we collect your email-id. Your name, photo, and any other information that you choose to add to your public-facing profile will be available for viewing to users of our Platform. Once you activate a profile, other users will be able to see in your profile certain information about your activity.\n\n'**
  String get privacy_section2_item1_text;

  /// No description provided for @privacy_section2_item2.
  ///
  /// In en, this message translates to:
  /// **'Integrated Service Provider and Linked Networks. '**
  String get privacy_section2_item2;

  /// No description provided for @privacy_section2_item2_text.
  ///
  /// In en, this message translates to:
  /// **'If you elect to connect your CircuitVerse account to another online service provider, such as a social networking service (“Integrated Service Provider”), you will be allowing us to pass to and receive from the Integrated Service Provider your log-in information and other user data. You may elect to sign in or sign up to the CircuitVerse Platform through a linked network like Facebook or Google (each a “Linked Network”).The specific information we may collect varies by Integrated Service Provider, but the permissions page for each will describe the relevant information. Integrated Service Providers control how they use and share your information; you should consult their respective privacy policies for information about their practices.\n\n'**
  String get privacy_section2_item2_text;

  /// No description provided for @privacy_section2_item3.
  ///
  /// In en, this message translates to:
  /// **'Automatically Collected Information About Your Activity. '**
  String get privacy_section2_item3;

  /// No description provided for @privacy_section2_item3_text.
  ///
  /// In en, this message translates to:
  /// **'We use cookies, log files, pixel tags, local storage objects, and other tracking technologies to automatically collect information about your activities, such as your searches, page views, date and time of your visit, and other information about your use of the CircuitVerse Platform.\n\n'**
  String get privacy_section2_item3_text;

  /// No description provided for @privacy_section3_title.
  ///
  /// In en, this message translates to:
  /// **'How We Use Your Information'**
  String get privacy_section3_title;

  /// No description provided for @privacy_section3_text.
  ///
  /// In en, this message translates to:
  /// **'We do not sell your personally identifying information – such as your name and contact information – to third parties to use for their own marketing purposes.\n\n'**
  String get privacy_section3_text;

  /// No description provided for @privacy_section3_list_header.
  ///
  /// In en, this message translates to:
  /// **'CircuitVerse uses the information we collect:\n\n'**
  String get privacy_section3_list_header;

  /// No description provided for @privacy_section3_item1.
  ///
  /// In en, this message translates to:
  /// **'\t• To provide you the services we offer on the CircuitVerse Platform, communicate with you about your use of the CircuitVerse Platform, respond to your inquiries, provide troubleshooting, and for other customer service purposes.\n\n'**
  String get privacy_section3_item1;

  /// No description provided for @privacy_section3_item2.
  ///
  /// In en, this message translates to:
  /// **'\t• To tailor the content and information that we may send or display to you in the CircuitVerse Platform.\n\n'**
  String get privacy_section3_item2;

  /// No description provided for @privacy_section3_item3.
  ///
  /// In en, this message translates to:
  /// **'\t• To better understand how users access and use the CircuitVerse Platform both on an aggregated and individualized basis, and for other research and analytical purposes.\n\n'**
  String get privacy_section3_item3;

  /// No description provided for @privacy_section3_item4.
  ///
  /// In en, this message translates to:
  /// **'\t• To evaluate and improve the CircuitVerse Platform and to develop new products and services.\n\n'**
  String get privacy_section3_item4;

  /// No description provided for @privacy_section3_item5.
  ///
  /// In en, this message translates to:
  /// **'\t• To comply with legal obligations, as part of our general business operations, and for other business administration purposes.\n\n'**
  String get privacy_section3_item5;

  /// No description provided for @privacy_section3_item6.
  ///
  /// In en, this message translates to:
  /// **'\t• Where we believe necessary to investigate, prevent or take action regarding illegal activities, suspected fraud, situations involving potential threats to the safety of any person or violations of our Terms of Use or this Privacy Policy.\n\n'**
  String get privacy_section3_item6;

  /// No description provided for @privacy_section3_text2_title.
  ///
  /// In en, this message translates to:
  /// **'Your Content and Activity. '**
  String get privacy_section3_text2_title;

  /// No description provided for @privacy_section3_text2.
  ///
  /// In en, this message translates to:
  /// **'Your Content, including your name, profile picture, profile information, and certain associated activity information is available to other users of the CircuitVerse Platform and may be viewed publicly. Public viewing includes availability to non-registered visitors and can occur when users share Your Content across other sites or services. In addition, Your Content may be indexed by search engines.\n\n'**
  String get privacy_section3_text2;

  /// No description provided for @privacy_section3_text3_title.
  ///
  /// In en, this message translates to:
  /// **'Anonymized and Aggregated Data. '**
  String get privacy_section3_text3_title;

  /// No description provided for @privacy_section3_text3.
  ///
  /// In en, this message translates to:
  /// **'We may share aggregate or de-identified information with third parties for research, marketing, analytics and other purposes, provided such information does not identify a particular individual.\n\n'**
  String get privacy_section3_text3;

  /// No description provided for @privacy_section3_text4_title.
  ///
  /// In en, this message translates to:
  /// **'Tracking. '**
  String get privacy_section3_text4_title;

  /// No description provided for @privacy_section3_text4_string1.
  ///
  /// In en, this message translates to:
  /// **'Analytics Tools -We may use internal and third party analytics tools, including '**
  String get privacy_section3_text4_string1;

  /// No description provided for @google_analytics.
  ///
  /// In en, this message translates to:
  /// **'Google Analytics'**
  String get google_analytics;

  /// No description provided for @privacy_section3_text4_string2.
  ///
  /// In en, this message translates to:
  /// **'. The third party analytics companies we work with may combine the information collected with other information they have independently collected from other websites and/or other online products and services. Their collection and use of information is subject to their own privacy policies.\n\n'**
  String get privacy_section3_text4_string2;

  /// No description provided for @contact_us.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contact_us;

  /// No description provided for @contact_us_text.
  ///
  /// In en, this message translates to:
  /// **'If you have any questions about our practices or this Privacy Policy, please contact us at '**
  String get contact_us_text;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
