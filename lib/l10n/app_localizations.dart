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
/// import 'l10n/app_localizations.dart';
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi')
  ];

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

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

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

  /// No description provided for @interactive_book.
  ///
  /// In en, this message translates to:
  /// **'Interactive Book'**
  String get interactive_book;

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

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

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

  /// No description provided for @slack_channel.
  ///
  /// In en, this message translates to:
  /// **'Slack channel'**
  String get slack_channel;

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

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'hi': return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
