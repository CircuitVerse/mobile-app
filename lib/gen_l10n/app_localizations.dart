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

  /// No description provided for @update_profile.
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get update_profile;

  /// No description provided for @profile_picture.
  ///
  /// In en, this message translates to:
  /// **'Profile Picture'**
  String get profile_picture;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @name_empty_error.
  ///
  /// In en, this message translates to:
  /// **'Name can\'t be empty'**
  String get name_empty_error;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @educational_institute.
  ///
  /// In en, this message translates to:
  /// **'Educational Institute'**
  String get educational_institute;

  /// No description provided for @subscribe_mails.
  ///
  /// In en, this message translates to:
  /// **'Subscribe to mails?'**
  String get subscribe_mails;

  /// No description provided for @save_details.
  ///
  /// In en, this message translates to:
  /// **'Save Details'**
  String get save_details;

  /// No description provided for @updating.
  ///
  /// In en, this message translates to:
  /// **'Updating...'**
  String get updating;

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

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

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

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @email_validation_error.
  ///
  /// In en, this message translates to:
  /// **'Enter emails in valid format'**
  String get email_validation_error;

  /// No description provided for @send_instructions.
  ///
  /// In en, this message translates to:
  /// **'SEND INSTRUCTIONS'**
  String get send_instructions;

  /// No description provided for @sending.
  ///
  /// In en, this message translates to:
  /// **'Sending..'**
  String get sending;

  /// No description provided for @new_user.
  ///
  /// In en, this message translates to:
  /// **'New User?'**
  String get new_user;

  /// No description provided for @sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get sign_up;

  /// No description provided for @sending_instructions.
  ///
  /// In en, this message translates to:
  /// **'Sending Instructions'**
  String get sending_instructions;

  /// No description provided for @instructions_sent_title.
  ///
  /// In en, this message translates to:
  /// **'Instructions Sent'**
  String get instructions_sent_title;

  /// No description provided for @instructions_sent_message.
  ///
  /// In en, this message translates to:
  /// **'Password reset instructions have been sent to your email'**
  String get instructions_sent_message;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgot_password;

  /// No description provided for @password_validation_error.
  ///
  /// In en, this message translates to:
  /// **'Password can\'t be empty'**
  String get password_validation_error;

  /// No description provided for @authenticating.
  ///
  /// In en, this message translates to:
  /// **'Authenticating...'**
  String get authenticating;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

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

  /// No description provided for @name_validation_error.
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty'**
  String get name_validation_error;

  /// No description provided for @password_length_error.
  ///
  /// In en, this message translates to:
  /// **'Password length should be at least 6'**
  String get password_length_error;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @already_registered.
  ///
  /// In en, this message translates to:
  /// **'Already Registered?'**
  String get already_registered;

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

  /// No description provided for @letter_grade.
  ///
  /// In en, this message translates to:
  /// **'Letter Grade'**
  String get letter_grade;

  /// No description provided for @percent.
  ///
  /// In en, this message translates to:
  /// **'Percent'**
  String get percent;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @deadline.
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get deadline;

  /// No description provided for @grading_scale.
  ///
  /// In en, this message translates to:
  /// **'Grading Scale'**
  String get grading_scale;

  /// No description provided for @elements_restriction.
  ///
  /// In en, this message translates to:
  /// **'Elements restriction'**
  String get elements_restriction;

  /// No description provided for @enable_elements_restriction.
  ///
  /// In en, this message translates to:
  /// **'Enable elements restriction'**
  String get enable_elements_restriction;

  /// No description provided for @create_assignment.
  ///
  /// In en, this message translates to:
  /// **'Create Assignment'**
  String get create_assignment;

  /// No description provided for @adding_assignment.
  ///
  /// In en, this message translates to:
  /// **'Adding Assignment'**
  String get adding_assignment;

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

  /// No description provided for @add_assignment.
  ///
  /// In en, this message translates to:
  /// **'Add Assignment'**
  String get add_assignment;

  /// No description provided for @no_scale.
  ///
  /// In en, this message translates to:
  /// **'No Scale'**
  String get no_scale;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @not_applicable.
  ///
  /// In en, this message translates to:
  /// **'N.A'**
  String get not_applicable;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @submissions.
  ///
  /// In en, this message translates to:
  /// **'Submissions'**
  String get submissions;

  /// No description provided for @no_submissions_yet.
  ///
  /// In en, this message translates to:
  /// **'No Submissions yet!'**
  String get no_submissions_yet;

  /// No description provided for @adding_grades.
  ///
  /// In en, this message translates to:
  /// **'Adding Grades...'**
  String get adding_grades;

  /// No description provided for @project_graded_successfully.
  ///
  /// In en, this message translates to:
  /// **'Project Graded Successfully'**
  String get project_graded_successfully;

  /// No description provided for @project_graded_message.
  ///
  /// In en, this message translates to:
  /// **'You have graded the project'**
  String get project_graded_message;

  /// No description provided for @updating_grade.
  ///
  /// In en, this message translates to:
  /// **'Updating Grade...'**
  String get updating_grade;

  /// No description provided for @grade_updated_successfully.
  ///
  /// In en, this message translates to:
  /// **'Grade updated Successfully'**
  String get grade_updated_successfully;

  /// No description provided for @grade_updated_message.
  ///
  /// In en, this message translates to:
  /// **'Grade has been updated successfully'**
  String get grade_updated_message;

  /// No description provided for @delete_grade.
  ///
  /// In en, this message translates to:
  /// **'Delete Grade'**
  String get delete_grade;

  /// No description provided for @delete_grade_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the grade?'**
  String get delete_grade_confirmation;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleting_grade.
  ///
  /// In en, this message translates to:
  /// **'Deleting Grade...'**
  String get deleting_grade;

  /// No description provided for @grade_deleted.
  ///
  /// In en, this message translates to:
  /// **'Grade Deleted'**
  String get grade_deleted;

  /// No description provided for @grade_deleted_message.
  ///
  /// In en, this message translates to:
  /// **'Grade has been removed successfully'**
  String get grade_deleted_message;

  /// No description provided for @grades_and_remarks.
  ///
  /// In en, this message translates to:
  /// **'Grades & Remarks'**
  String get grades_and_remarks;

  /// No description provided for @grade.
  ///
  /// In en, this message translates to:
  /// **'Grade'**
  String get grade;

  /// No description provided for @grade_validation_error.
  ///
  /// In en, this message translates to:
  /// **'Grade can\'t be empty'**
  String get grade_validation_error;

  /// No description provided for @remarks.
  ///
  /// In en, this message translates to:
  /// **'Remarks'**
  String get remarks;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @assignment_details.
  ///
  /// In en, this message translates to:
  /// **'Assignment Details'**
  String get assignment_details;

  /// No description provided for @time_remaining.
  ///
  /// In en, this message translates to:
  /// **'Time Remaining'**
  String get time_remaining;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get hours;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// No description provided for @restricted_elements.
  ///
  /// In en, this message translates to:
  /// **'Restricted Elements'**
  String get restricted_elements;

  /// No description provided for @group_updated.
  ///
  /// In en, this message translates to:
  /// **'Group Updated'**
  String get group_updated;

  /// No description provided for @group_update_success.
  ///
  /// In en, this message translates to:
  /// **'Group has been successfully updated'**
  String get group_update_success;

  /// No description provided for @edit_group.
  ///
  /// In en, this message translates to:
  /// **'Edit Group'**
  String get edit_group;

  /// No description provided for @edit_group_description.
  ///
  /// In en, this message translates to:
  /// **'You can update Group details here. Don\'t leave the Group Name blank.'**
  String get edit_group_description;

  /// No description provided for @group_name.
  ///
  /// In en, this message translates to:
  /// **'Group Name'**
  String get group_name;

  /// No description provided for @group_name_validation_error.
  ///
  /// In en, this message translates to:
  /// **'Please enter a Group Name'**
  String get group_name_validation_error;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @primary_mentor.
  ///
  /// In en, this message translates to:
  /// **'Primary Mentor'**
  String get primary_mentor;

  /// No description provided for @adding.
  ///
  /// In en, this message translates to:
  /// **'Adding'**
  String get adding;

  /// No description provided for @group_members_added.
  ///
  /// In en, this message translates to:
  /// **'Group Members Added'**
  String get group_members_added;

  /// No description provided for @add_group_members.
  ///
  /// In en, this message translates to:
  /// **'Add Group Members'**
  String get add_group_members;

  /// No description provided for @add_mentors.
  ///
  /// In en, this message translates to:
  /// **'Add Mentors'**
  String get add_mentors;

  /// No description provided for @add_members_description.
  ///
  /// In en, this message translates to:
  /// **'Enter Email IDs separated by commas. If users are not registered, an email ID will be sent requesting them to sign up.'**
  String get add_members_description;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @remove_group_member.
  ///
  /// In en, this message translates to:
  /// **'Remove Group Member'**
  String get remove_group_member;

  /// No description provided for @remove_mentor.
  ///
  /// In en, this message translates to:
  /// **'Remove Mentor'**
  String get remove_mentor;

  /// No description provided for @remove_member_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this group member?'**
  String get remove_member_confirmation;

  /// No description provided for @remove_mentor_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this mentor?'**
  String get remove_mentor_confirmation;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @removing.
  ///
  /// In en, this message translates to:
  /// **'Removing...'**
  String get removing;

  /// No description provided for @group_member_removed.
  ///
  /// In en, this message translates to:
  /// **'Group Member Removed'**
  String get group_member_removed;

  /// No description provided for @mentor_removed.
  ///
  /// In en, this message translates to:
  /// **'Mentor Removed'**
  String get mentor_removed;

  /// No description provided for @member_removed_success.
  ///
  /// In en, this message translates to:
  /// **'Successfully removed'**
  String get member_removed_success;

  /// No description provided for @mentors.
  ///
  /// In en, this message translates to:
  /// **'Mentors'**
  String get mentors;

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get members;

  /// No description provided for @assignments.
  ///
  /// In en, this message translates to:
  /// **'Assignments'**
  String get assignments;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @delete_assignment.
  ///
  /// In en, this message translates to:
  /// **'Delete Assignment'**
  String get delete_assignment;

  /// No description provided for @delete_assignment_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this assignment?'**
  String get delete_assignment_confirmation;

  /// No description provided for @deleting_assignment.
  ///
  /// In en, this message translates to:
  /// **'Deleting Assignment...'**
  String get deleting_assignment;

  /// No description provided for @assignment_deleted.
  ///
  /// In en, this message translates to:
  /// **'Assignment Deleted'**
  String get assignment_deleted;

  /// No description provided for @assignment_deleted_success.
  ///
  /// In en, this message translates to:
  /// **'The assignment was successfully deleted'**
  String get assignment_deleted_success;

  /// No description provided for @reopen_assignment.
  ///
  /// In en, this message translates to:
  /// **'Reopen Assignment'**
  String get reopen_assignment;

  /// No description provided for @reopen_assignment_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reopen this assignment?'**
  String get reopen_assignment_confirmation;

  /// No description provided for @reopen.
  ///
  /// In en, this message translates to:
  /// **'Reopen'**
  String get reopen;

  /// No description provided for @reopening_assignment.
  ///
  /// In en, this message translates to:
  /// **'Reopening Assignment...'**
  String get reopening_assignment;

  /// No description provided for @assignment_reopened.
  ///
  /// In en, this message translates to:
  /// **'Assignment Reopened'**
  String get assignment_reopened;

  /// No description provided for @assignment_reopened_success.
  ///
  /// In en, this message translates to:
  /// **'The assignment is reopened now'**
  String get assignment_reopened_success;

  /// No description provided for @start_assignment.
  ///
  /// In en, this message translates to:
  /// **'Start Assignment'**
  String get start_assignment;

  /// No description provided for @start_assignment_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to start working on this assignment?'**
  String get start_assignment_confirmation;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @starting_assignment.
  ///
  /// In en, this message translates to:
  /// **'Starting Assignment...'**
  String get starting_assignment;

  /// No description provided for @project_created.
  ///
  /// In en, this message translates to:
  /// **'Project Created'**
  String get project_created;

  /// No description provided for @project_created_success.
  ///
  /// In en, this message translates to:
  /// **'Project is successfully created'**
  String get project_created_success;

  /// No description provided for @member.
  ///
  /// In en, this message translates to:
  /// **'member'**
  String get member;

  /// No description provided for @mentor.
  ///
  /// In en, this message translates to:
  /// **'mentor'**
  String get mentor;

  /// No description provided for @make.
  ///
  /// In en, this message translates to:
  /// **'Make'**
  String get make;

  /// No description provided for @are_you_sure_you_want_to.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to'**
  String get are_you_sure_you_want_to;

  /// No description provided for @promote.
  ///
  /// In en, this message translates to:
  /// **'promote'**
  String get promote;

  /// No description provided for @demote.
  ///
  /// In en, this message translates to:
  /// **'demote'**
  String get demote;

  /// No description provided for @this_group.
  ///
  /// In en, this message translates to:
  /// **'this group'**
  String get this_group;

  /// No description provided for @to_a.
  ///
  /// In en, this message translates to:
  /// **'to a'**
  String get to_a;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @promoting.
  ///
  /// In en, this message translates to:
  /// **'Promoting...'**
  String get promoting;

  /// No description provided for @demoting.
  ///
  /// In en, this message translates to:
  /// **'Demoting...'**
  String get demoting;

  /// No description provided for @promoted.
  ///
  /// In en, this message translates to:
  /// **'Promoted'**
  String get promoted;

  /// No description provided for @demoted.
  ///
  /// In en, this message translates to:
  /// **'Demoted'**
  String get demoted;

  /// No description provided for @member_updated_success.
  ///
  /// In en, this message translates to:
  /// **'Group member was successfully updated'**
  String get member_updated_success;

  /// No description provided for @group_details.
  ///
  /// In en, this message translates to:
  /// **'Group Details'**
  String get group_details;

  /// No description provided for @explore_groups_message.
  ///
  /// In en, this message translates to:
  /// **'Explore and join groups of your school and friends!'**
  String get explore_groups_message;

  /// No description provided for @delete_group.
  ///
  /// In en, this message translates to:
  /// **'Delete Group'**
  String get delete_group;

  /// No description provided for @delete_group_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this group?'**
  String get delete_group_confirmation;

  /// No description provided for @deleting_group.
  ///
  /// In en, this message translates to:
  /// **'Deleting Group...'**
  String get deleting_group;

  /// No description provided for @group_deleted.
  ///
  /// In en, this message translates to:
  /// **'Group Deleted'**
  String get group_deleted;

  /// No description provided for @group_deleted_success.
  ///
  /// In en, this message translates to:
  /// **'Group was successfully deleted'**
  String get group_deleted_success;

  /// No description provided for @owned.
  ///
  /// In en, this message translates to:
  /// **'Owned'**
  String get owned;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @joined.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get joined;

  /// No description provided for @creating.
  ///
  /// In en, this message translates to:
  /// **'Creating...'**
  String get creating;

  /// No description provided for @group_created.
  ///
  /// In en, this message translates to:
  /// **'Group Created'**
  String get group_created;

  /// No description provided for @group_created_success.
  ///
  /// In en, this message translates to:
  /// **'New group was created successfully'**
  String get group_created_success;

  /// No description provided for @new_group.
  ///
  /// In en, this message translates to:
  /// **'New Group'**
  String get new_group;

  /// No description provided for @group_description.
  ///
  /// In en, this message translates to:
  /// **'Groups can be used by mentors to set projects for and give grades to students'**
  String get group_description;

  /// No description provided for @assignment_description_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter assignment description...'**
  String get assignment_description_hint;

  /// No description provided for @update_assignment.
  ///
  /// In en, this message translates to:
  /// **'Update Assignment'**
  String get update_assignment;

  /// No description provided for @assignment_updated.
  ///
  /// In en, this message translates to:
  /// **'Assignment Updated'**
  String get assignment_updated;

  /// No description provided for @assignment_update_success.
  ///
  /// In en, this message translates to:
  /// **'Assignment was updated successfully'**
  String get assignment_update_success;

  /// No description provided for @search_circuitverse.
  ///
  /// In en, this message translates to:
  /// **'Search CircuitVerse'**
  String get search_circuitverse;

  /// No description provided for @navigate_chapters.
  ///
  /// In en, this message translates to:
  /// **'Navigate to different chapters'**
  String get navigate_chapters;

  /// No description provided for @circuitverse.
  ///
  /// In en, this message translates to:
  /// **'CircuitVerse'**
  String get circuitverse;

  /// No description provided for @interactive_book.
  ///
  /// In en, this message translates to:
  /// **'Interactive Book'**
  String get interactive_book;

  /// No description provided for @return_home.
  ///
  /// In en, this message translates to:
  /// **'Return to Home'**
  String get return_home;

  /// No description provided for @ib_home.
  ///
  /// In en, this message translates to:
  /// **'Interactive Book Home'**
  String get ib_home;

  /// No description provided for @loading_chapters.
  ///
  /// In en, this message translates to:
  /// **'Loading Chapters...'**
  String get loading_chapters;

  /// No description provided for @show_toc.
  ///
  /// In en, this message translates to:
  /// **'Show Table of Contents'**
  String get show_toc;

  /// No description provided for @copyright_notice.
  ///
  /// In en, this message translates to:
  /// **'Copyright © 2021 Contributors to CircuitVerse. Distributed under a [CC-by-sa] license.'**
  String get copyright_notice;

  /// No description provided for @table_of_contents.
  ///
  /// In en, this message translates to:
  /// **'Table of Contents'**
  String get table_of_contents;

  /// No description provided for @navigate_previous_page.
  ///
  /// In en, this message translates to:
  /// **'Tap to navigate to previous page'**
  String get navigate_previous_page;

  /// No description provided for @navigate_next_page.
  ///
  /// In en, this message translates to:
  /// **'Tap to navigate to next page'**
  String get navigate_next_page;

  /// No description provided for @loading_image.
  ///
  /// In en, this message translates to:
  /// **'Loading image...'**
  String get loading_image;

  /// No description provided for @image_load_error.
  ///
  /// In en, this message translates to:
  /// **'Failed to load image'**
  String get image_load_error;

  /// No description provided for @no_image_source.
  ///
  /// In en, this message translates to:
  /// **'No image source provided'**
  String get no_image_source;

  /// No description provided for @no_notifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get no_notifications;

  /// No description provided for @notifications_will_appear.
  ///
  /// In en, this message translates to:
  /// **'Your notifications will appear here'**
  String get notifications_will_appear;

  /// No description provided for @no_unread_notifications.
  ///
  /// In en, this message translates to:
  /// **'No unread notifications'**
  String get no_unread_notifications;

  /// No description provided for @no_unread_notifications_desc.
  ///
  /// In en, this message translates to:
  /// **'You have no unread notifications'**
  String get no_unread_notifications_desc;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @unread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get unread;

  /// No description provided for @starred.
  ///
  /// In en, this message translates to:
  /// **'starred'**
  String get starred;

  /// No description provided for @forked.
  ///
  /// In en, this message translates to:
  /// **'forked'**
  String get forked;

  /// No description provided for @your_project.
  ///
  /// In en, this message translates to:
  /// **'your project'**
  String get your_project;

  /// No description provided for @not_available.
  ///
  /// In en, this message translates to:
  /// **'N.A'**
  String get not_available;

  /// No description provided for @edit_profile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get edit_profile;

  /// No description provided for @subscribed_to_mails.
  ///
  /// In en, this message translates to:
  /// **'Subscribed to mails'**
  String get subscribed_to_mails;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @circuits.
  ///
  /// In en, this message translates to:
  /// **'Circuits'**
  String get circuits;

  /// No description provided for @favourites.
  ///
  /// In en, this message translates to:
  /// **'Favourites'**
  String get favourites;

  /// No description provided for @tags_list.
  ///
  /// In en, this message translates to:
  /// **'Tags List'**
  String get tags_list;

  /// No description provided for @project_access_type.
  ///
  /// In en, this message translates to:
  /// **'Project Access Type'**
  String get project_access_type;

  /// No description provided for @project_access_type_validation_error.
  ///
  /// In en, this message translates to:
  /// **'Please select project access type'**
  String get project_access_type_validation_error;

  /// No description provided for @public.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get public;

  /// No description provided for @private.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get private;

  /// No description provided for @limited_access.
  ///
  /// In en, this message translates to:
  /// **'Limited Access'**
  String get limited_access;

  /// No description provided for @updating_project.
  ///
  /// In en, this message translates to:
  /// **'Updating project...'**
  String get updating_project;

  /// No description provided for @project_updated.
  ///
  /// In en, this message translates to:
  /// **'Project updated'**
  String get project_updated;

  /// No description provided for @project_update_success.
  ///
  /// In en, this message translates to:
  /// **'Project updated successfully'**
  String get project_update_success;

  /// No description provided for @update_project.
  ///
  /// In en, this message translates to:
  /// **'Update Project'**
  String get update_project;

  /// No description provided for @project_details.
  ///
  /// In en, this message translates to:
  /// **'Project Details'**
  String get project_details;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @fork.
  ///
  /// In en, this message translates to:
  /// **'Fork'**
  String get fork;

  /// No description provided for @stars.
  ///
  /// In en, this message translates to:
  /// **'Stars'**
  String get stars;

  /// No description provided for @views.
  ///
  /// In en, this message translates to:
  /// **'Views'**
  String get views;

  /// No description provided for @author.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get author;

  /// No description provided for @add_a_collaborator.
  ///
  /// In en, this message translates to:
  /// **'Add Collaborator'**
  String get add_a_collaborator;

  /// No description provided for @collaborators.
  ///
  /// In en, this message translates to:
  /// **'Collaborators'**
  String get collaborators;

  /// No description provided for @fork_project.
  ///
  /// In en, this message translates to:
  /// **'Fork Project'**
  String get fork_project;

  /// No description provided for @fork_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to fork this project?'**
  String get fork_confirmation;

  /// No description provided for @forking.
  ///
  /// In en, this message translates to:
  /// **'Forking'**
  String get forking;

  /// No description provided for @project_starred.
  ///
  /// In en, this message translates to:
  /// **'Project starred'**
  String get project_starred;

  /// No description provided for @project_unstarred.
  ///
  /// In en, this message translates to:
  /// **'Project unstarred'**
  String get project_unstarred;

  /// No description provided for @starred_success.
  ///
  /// In en, this message translates to:
  /// **'You have successfully starred the project'**
  String get starred_success;

  /// No description provided for @unstarred_success.
  ///
  /// In en, this message translates to:
  /// **'You have successfully unstarred the project'**
  String get unstarred_success;

  /// No description provided for @add_collaborators.
  ///
  /// In en, this message translates to:
  /// **'Add Collaborators'**
  String get add_collaborators;

  /// No description provided for @email_ids.
  ///
  /// In en, this message translates to:
  /// **'Email IDs'**
  String get email_ids;

  /// No description provided for @email_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter email IDs separated by comma'**
  String get email_hint;

  /// No description provided for @collaborators_added.
  ///
  /// In en, this message translates to:
  /// **'Collaborators added'**
  String get collaborators_added;

  /// No description provided for @delete_project.
  ///
  /// In en, this message translates to:
  /// **'Delete Project'**
  String get delete_project;

  /// No description provided for @delete_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this project?'**
  String get delete_confirmation;

  /// No description provided for @deleting.
  ///
  /// In en, this message translates to:
  /// **'Deleting'**
  String get deleting;

  /// No description provided for @project_deleted.
  ///
  /// In en, this message translates to:
  /// **'Project deleted'**
  String get project_deleted;

  /// No description provided for @delete_success.
  ///
  /// In en, this message translates to:
  /// **'Project deleted successfully'**
  String get delete_success;

  /// No description provided for @delete_collaborator.
  ///
  /// In en, this message translates to:
  /// **'Remove Collaborator'**
  String get delete_collaborator;

  /// No description provided for @delete_collaborator_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this collaborator?'**
  String get delete_collaborator_confirmation;

  /// No description provided for @collaborator_deleted.
  ///
  /// In en, this message translates to:
  /// **'Collaborator removed'**
  String get collaborator_deleted;

  /// No description provided for @collaborator_delete_success.
  ///
  /// In en, this message translates to:
  /// **'Collaborator removed successfully'**
  String get collaborator_delete_success;

  /// No description provided for @no_result_found.
  ///
  /// In en, this message translates to:
  /// **'No result found'**
  String get no_result_found;

  /// No description provided for @editor_picks.
  ///
  /// In en, this message translates to:
  /// **'Editor\'s Picks'**
  String get editor_picks;

  /// No description provided for @editor_picks_description.
  ///
  /// In en, this message translates to:
  /// **'Curated list of the best projects'**
  String get editor_picks_description;

  /// No description provided for @search_for_circuits.
  ///
  /// In en, this message translates to:
  /// **'Search for circuits'**
  String get search_for_circuits;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'CircuitVerse'**
  String get title;

  /// No description provided for @groups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get groups;

  /// No description provided for @featured_circuits.
  ///
  /// In en, this message translates to:
  /// **'Featured Circuits'**
  String get featured_circuits;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @logout_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logout_confirmation;

  /// No description provided for @logout_confirmation_button.
  ///
  /// In en, this message translates to:
  /// **'LOGOUT'**
  String get logout_confirmation_button;

  /// No description provided for @logout_success.
  ///
  /// In en, this message translates to:
  /// **'Logged Out Successfully'**
  String get logout_success;

  /// No description provided for @logout_success_acknowledgement.
  ///
  /// In en, this message translates to:
  /// **'You have been signed out.'**
  String get logout_success_acknowledgement;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @simulator.
  ///
  /// In en, this message translates to:
  /// **'Simulator'**
  String get simulator;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @contribute.
  ///
  /// In en, this message translates to:
  /// **'Contribute'**
  String get contribute;

  /// No description provided for @teachers.
  ///
  /// In en, this message translates to:
  /// **'Teachers'**
  String get teachers;

  /// No description provided for @my_groups.
  ///
  /// In en, this message translates to:
  /// **'My Groups'**
  String get my_groups;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

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
