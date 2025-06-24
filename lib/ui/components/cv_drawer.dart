import 'package:flutter/material.dart';
import 'package:mobile_app/controllers/language_controller.dart';
import 'package:mobile_app/gen_l10n/app_localizations.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:get/get.dart';
import 'package:mobile_app/cv_theme.dart';
import 'package:mobile_app/ui/components/cv_drawer_tile.dart';
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

    return Drawer(
      child: Stack(
        children: [
          ListView(
            children: <Widget>[
              Container(
                padding: const EdgeInsetsDirectional.symmetric(
                  vertical: 32,
                  horizontal: 10,
                ),
                child: Image.asset(
                  'assets/images/landing/cv_full_logo.png',
                  width: 90,
                ),
              ),
              InkWell(
                onTap: () => _model.setSelectedIndexTo(0),
                child: CVDrawerTile(
                  title: AppLocalizations.of(context)!.cv_home,
                  iconData: Icons.home,
                ),
              ),
              Theme(
                data: CVTheme.themeData(context),
                child: ExpansionTile(
                  maintainState: true,
                  tilePadding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 16.0,
                  ),
                  childrenPadding: EdgeInsetsDirectional.zero,
                  leading: Icon(
                    Icons.explore,
                    color: CVTheme.drawerIcon(context),
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.cv_explore,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  iconColor: CVTheme.textColor(context),
                  children: <Widget>[
                    InkWell(
                      onTap: () => _model.setSelectedIndexTo(1),
                      child: CVDrawerTile(
                        title: AppLocalizations.of(context)!.featured_circuits,
                        iconData: Icons.star,
                      ),
                    ),
                  ],
                ),
              ),

              // Language Selection Tile
              Obx(() {
                final currentLocale = langController.currentLocale.value;
                final localizations = AppLocalizations.of(context)!;

                final languages = {
                  const Locale('en'): 'English',
                  const Locale('hi'): 'हिंदी',
                  const Locale('ar'): 'العربية',
                };

                return Theme(
                  data: CVTheme.themeData(context),
                  child: ExpansionTile(
                    key: ValueKey(currentLocale),
                    initiallyExpanded: langController.isLanguageExpanded.value,
                    onExpansionChanged: (expanded) {
                      langController.isLanguageExpanded.value = expanded;
                    },
                    maintainState: true,
                    tilePadding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 16.0,
                    ),
                    childrenPadding: EdgeInsetsDirectional.zero,
                    leading: Icon(
                      Icons.translate,
                      color: CVTheme.drawerIcon(context),
                    ),
                    title: Text(
                      localizations.cv_language,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    iconColor: CVTheme.textColor(context),
                    children:
                        languages.entries.map((entry) {
                          final isSelected = currentLocale == entry.key;
                          return InkWell(
                            onTap: () {
                              langController.changeLanguage(entry.key);
                              langController.isLanguageExpanded.value = false;
                            },
                            child: CVDrawerTile(
                              title: entry.value,
                              iconData:
                                  isSelected
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_off,
                            ),
                          );
                        }).toList(),
                  ),
                );
              }),

              InkWell(
                onTap: () => Get.toNamed(IbLandingView.id),
                child: CVDrawerTile(
                  title: AppLocalizations.of(context)!.cv_interactive_book,
                  iconData: Icons.chrome_reader_mode,
                ),
              ),
              InkWell(
                onTap: () async {
                  final url = await Get.toNamed(SimulatorView.id);
                  await Future.delayed(const Duration(seconds: 1));
                  if (url is String) {
                    if (url.contains('sign_out')) {
                      _model.onLogoutPressed();
                    } else if (url.contains('edit')) {
                      Get.back();
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
                child: CVDrawerTile(
                  title: AppLocalizations.of(context)!.cv_simulator,
                  iconData: FontAwesome5.atom,
                ),
              ),
              InkWell(
                onTap: () => _model.setSelectedIndexTo(2),
                child: CVDrawerTile(
                  title: AppLocalizations.of(context)!.cv_about,
                  iconData: FontAwesome5.address_card,
                ),
              ),
              InkWell(
                onTap: () => _model.setSelectedIndexTo(3),
                child: CVDrawerTile(
                  title: AppLocalizations.of(context)!.cv_contribute,
                  iconData: Icons.add,
                ),
              ),
              InkWell(
                onTap: () => _model.setSelectedIndexTo(4),
                child: CVDrawerTile(
                  title: AppLocalizations.of(context)!.cv_teachers,
                  iconData: Icons.account_balance,
                ),
              ),
              if (_model.isLoggedIn) ...[
                InkWell(
                  onTap: () => _model.setSelectedIndexTo(8),
                  child: CVDrawerTile(
                    title: AppLocalizations.of(context)!.cv_notifications,
                    iconData: FontAwesome.bell,
                    pending: _model.hasPendingNotif,
                  ),
                ),
                Theme(
                  data: CVTheme.themeData(context),
                  child: ExpansionTile(
                    maintainState: true,
                    tilePadding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 16.0,
                    ),
                    childrenPadding: EdgeInsetsDirectional.zero,
                    iconColor: CVTheme.textColor(context),
                    title: Text(
                      _model.currentUser?.data.attributes.name ?? '',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: <Widget>[
                      InkWell(
                        onTap: () => _model.setSelectedIndexTo(5),
                        child: CVDrawerTile(
                          title: AppLocalizations.of(context)!.cv_profile,
                          iconData: FontAwesome5.user,
                        ),
                      ),
                      InkWell(
                        onTap: () => _model.setSelectedIndexTo(6),
                        child: CVDrawerTile(
                          title: AppLocalizations.of(context)!.cv_my_groups,
                          iconData: FontAwesome5.object_group,
                        ),
                      ),
                      InkWell(
                        onTap: _model.onLogoutPressed,
                        child: CVDrawerTile(
                          title: AppLocalizations.of(context)!.cv_logout,
                          iconData: FontAwesome.logout,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else
                InkWell(
                  onTap: () => Get.offAndToNamed(LoginView.id),
                  child: CVDrawerTile(
                    title: AppLocalizations.of(context)!.cv_login,
                    iconData: FontAwesome.login,
                  ),
                ),
            ],
          ),
          Positioned(
            right: 5,
            top: 35,
            child: IconButton(
              icon:
                  Theme.of(context).brightness == Brightness.dark
                      ? const Icon(Icons.brightness_low)
                      : const Icon(Icons.brightness_high),
              iconSize: 28.0,
              onPressed: () => ThemeProvider.controllerOf(context).nextTheme(),
            ),
          ),
        ],
      ),
    );
  }
}
