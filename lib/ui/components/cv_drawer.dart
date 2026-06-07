import 'package:flutter/material.dart';
import 'package:mobile_app/controllers/language_controller.dart';
import 'package:mobile_app/gen_l10n/app_localizations.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:get/get.dart';
import 'package:mobile_app/cv_theme.dart';
import 'package:mobile_app/ui/views/authentication/login_view.dart';
import 'package:mobile_app/ui/views/ib/ib_landing_view.dart';
import 'package:mobile_app/ui/views/simulator/simulator_view.dart';
import 'package:mobile_app/utils/snackbar_utils.dart';
import 'package:mobile_app/viewmodels/cv_landing_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

class CVDrawer extends StatelessWidget {
  const CVDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final _model = context.read<CVLandingViewModel>();
    final langController = Get.find<LanguageController>();

    return NavigationDrawer(
      selectedIndex: _model.selectedIndex > 8 ? null : _model.selectedIndex,
      onDestinationSelected: (index) {
        // We handle selection manually via onTap to support non-sequential indices and ExpansionTiles
      },
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/images/landing/cv_full_logo.png',
                width: 90,
              ),
              IconButton.filledTonal(
                icon:
                    Theme.of(context).brightness == Brightness.dark
                        ? const Icon(Icons.brightness_low)
                        : const Icon(Icons.brightness_high),
                onPressed: () => ThemeProvider.controllerOf(context).nextTheme(),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
          child: Divider(),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home),
          label: Text(AppLocalizations.of(context)!.cv_home),
        ),
        
        ExpansionTile(
          maintainState: true,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(28))),
          leading: const Icon(Icons.explore),
          title: Text(AppLocalizations.of(context)!.cv_explore),
          children: <Widget>[
            ListTile(
              contentPadding: const EdgeInsets.only(left: 72),
              leading: const Icon(Icons.star),
              title: Text(AppLocalizations.of(context)!.featured_circuits),
              selected: _model.selectedIndex == 1,
              onTap: () {
                _model.setSelectedIndexTo(1);
                Navigator.pop(context);
              },
            ),
          ],
        ),

        // Language Selection
        Obx(() {
          final currentLocale = langController.currentLocale.value;
          final localizations = AppLocalizations.of(context)!;

          return ExpansionTile(
            key: ValueKey(currentLocale),
            initiallyExpanded: langController.isLanguageExpanded.value,
            onExpansionChanged: (expanded) {
              langController.isLanguageExpanded.value = expanded;
            },
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(28))),
            leading: const Icon(Icons.translate),
            title: Text(localizations.cv_language),
            children: [
              const Locale('en'), const Locale('hi'), const Locale('ar')
            ].map((locale) {
              final isSelected = currentLocale == locale;
              final label = locale.languageCode == 'en' ? 'English' : locale.languageCode == 'hi' ? 'हिंदी' : 'العربية';
              return ListTile(
                contentPadding: const EdgeInsets.only(left: 72),
                leading: Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off),
                title: Text(label),
                onTap: () {
                  langController.changeLanguage(locale);
                  langController.isLanguageExpanded.value = false;
                },
              );
            }).toList(),
          );
        }),

        const Padding(
          padding: EdgeInsets.fromLTRB(28, 8, 28, 8),
          child: Divider(),
        ),

        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 28),
          leading: const Icon(Icons.chrome_reader_mode),
          title: Text(AppLocalizations.of(context)!.cv_interactive_book),
          onTap: () {
            Navigator.pop(context);
            Get.toNamed(IbLandingView.id);
          },
        ),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 28),
          leading: const Icon(FontAwesome5.atom),
          title: Text(AppLocalizations.of(context)!.cv_simulator),
          onTap: () async {
            Navigator.pop(context);
            final url = await Get.toNamed(SimulatorView.id);
            await Future.delayed(const Duration(seconds: 1));
            if (url is String) {
              if (url.contains('sign_out')) {
                _model.onLogoutPressed();
              } else if (url.contains('edit')) {
                SnackBarUtils.showDark(
                  'New project created',
                  'Please check your profile to edit..',
                );
              } else if (url.contains('groups')) {
                _model.setSelectedIndexTo(6);
              } else if (url.contains('users')) {
                _model.setSelectedIndexTo(5);
              }
            }
          },
        ),

        const Padding(
          padding: EdgeInsets.fromLTRB(28, 8, 28, 8),
          child: Divider(),
        ),
        
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 28),
          leading: const Icon(FontAwesome5.address_card),
          title: Text(AppLocalizations.of(context)!.cv_about),
          selected: _model.selectedIndex == 2,
          onTap: () {
            _model.setSelectedIndexTo(2);
            Navigator.pop(context);
          },
        ),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 28),
          leading: const Icon(Icons.add),
          title: Text(AppLocalizations.of(context)!.cv_contribute),
          selected: _model.selectedIndex == 3,
          onTap: () {
            _model.setSelectedIndexTo(3);
            Navigator.pop(context);
          },
        ),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 28),
          leading: const Icon(Icons.account_balance),
          title: Text(AppLocalizations.of(context)!.cv_teachers),
          selected: _model.selectedIndex == 4,
          onTap: () {
            _model.setSelectedIndexTo(4);
            Navigator.pop(context);
          },
        ),

        if (_model.isLoggedIn) ...[
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 28),
            leading: Badge(
              isLabelVisible: _model.hasPendingNotif,
              child: const Icon(FontAwesome.bell),
            ),
            title: Text(AppLocalizations.of(context)!.cv_notifications),
            selected: _model.selectedIndex == 8,
            onTap: () {
              _model.setSelectedIndexTo(8);
              Navigator.pop(context);
            },
          ),
          ExpansionTile(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(28))),
            title: Text(_model.currentUser?.data.attributes.name ?? ''),
            leading: const Icon(FontAwesome5.user),
            children: [
              ListTile(
                contentPadding: const EdgeInsets.only(left: 72),
                leading: const Icon(FontAwesome5.user),
                title: Text(AppLocalizations.of(context)!.cv_profile),
                selected: _model.selectedIndex == 5,
                onTap: () {
                  _model.setSelectedIndexTo(5);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 72),
                leading: const Icon(FontAwesome5.object_group),
                title: Text(AppLocalizations.of(context)!.cv_my_groups),
                selected: _model.selectedIndex == 6,
                onTap: () {
                  _model.setSelectedIndexTo(6);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 72),
                leading: const Icon(FontAwesome.logout, color: Colors.red),
                title: Text(AppLocalizations.of(context)!.cv_logout, style: const TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _model.onLogoutPressed();
                },
              ),
            ],
          ),
        ] else
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 28),
            leading: const Icon(FontAwesome.login),
            title: Text(AppLocalizations.of(context)!.cv_login),
            onTap: () {
              Navigator.pop(context);
              Get.offAndToNamed(LoginView.id);
            },
          ),
        
        const SizedBox(height: 28),
      ],
    );
  }
}
