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

  Widget _buildExpansionTile({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<Widget> children,
    bool isActive = false,
    bool initiallyExpanded = false,
    ValueChanged<bool>? onExpansionChanged,
    Key? key,
  }) {
    return Container(
      margin: const EdgeInsetsDirectional.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? CVTheme.primaryColor.withOpacity(0.08) : null,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Theme(
        data: CVTheme.themeData(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: CVTheme.primaryColor.withOpacity(0.1),
          highlightColor: CVTheme.primaryColor.withOpacity(0.05),
        ),
        child: ExpansionTile(
          key: key,
          initiallyExpanded: initiallyExpanded,
          onExpansionChanged: onExpansionChanged,
          maintainState: true,
          tilePadding: const EdgeInsetsDirectional.only(start: 16, end: 12),
          childrenPadding: const EdgeInsetsDirectional.only(start: 8, top: 4, bottom: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          leading: Icon(
            icon,
            color: isActive
                ? CVTheme.primaryColor
                : CVTheme.drawerIcon(context),
            size: 24,
          ),
          title: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              color: isActive
                  ? CVTheme.primaryColor
                  : CVTheme.textColor(context),
            ),
          ),
          iconColor: CVTheme.textColor(context).withOpacity(0.7),
          collapsedIconColor: CVTheme.textColor(context).withOpacity(0.7),
          children: children,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _model = context.watch<CVLandingViewModel>();
    final langController = Get.find<LanguageController>();
    final selected = _model.selectedIndex;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsetsDirectional.fromSTEB(20, 48, 20, 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: AlignmentDirectional.topStart,
                end: AlignmentDirectional.bottomEnd,
                colors: isDark
                    ? [
                        CVTheme.secondaryColor,
                        CVTheme.secondaryColor.withOpacity(0.95),
                      ]
                    : [
                        CVTheme.primaryColorShadow,
                        CVTheme.primaryColorShadow.withOpacity(0.8),
                      ],
              ),
              boxShadow: [
                BoxShadow(
                  color: CVTheme.primaryColor.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Image.asset(
                    'assets/images/landing/cv_full_logo.png',
                    height: 40,
                    alignment: AlignmentDirectional.centerStart,
                    fit: BoxFit.contain,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: CVTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    tooltip: AppLocalizations.of(context)!.cv_toggle_theme,
                    icon: isDark
                        ? const Icon(Icons.light_mode_outlined)
                        : const Icon(Icons.dark_mode_outlined),
                    iconSize: 22.0,
                    color: CVTheme.primaryColor,
                    onPressed: () =>
                        ThemeProvider.controllerOf(context).nextTheme(),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsetsDirectional.symmetric(vertical: 12),
              children: <Widget>[
                InkWell(
                  onTap: () => _model.setSelectedIndexTo(0),
                  child: CVDrawerTile(
                    title: AppLocalizations.of(context)!.cv_home,
                    iconData: Icons.home_outlined,
                    isActive: selected == 0,
                  ),
                ),
                _buildExpansionTile(
                  context: context,
                  title: AppLocalizations.of(context)!.cv_explore,
                  icon: Icons.explore_outlined,
                  isActive: selected == 1,
                  children: <Widget>[
                    InkWell(
                      onTap: () => _model.setSelectedIndexTo(1),
                      child: CVDrawerTile(
                        title: AppLocalizations.of(context)!.featured_circuits,
                        iconData: Icons.star_outline,
                        isActive: selected == 1,
                        isChild: true,
                      ),
                    ),
                  ],
                ),

                Obx(() {
                  final currentLocale = langController.currentLocale.value;
                  final localizations = AppLocalizations.of(context)!;

                  final languages = {
                    const Locale('en'): 'English',
                    const Locale('hi'): 'हिंदी',
                    const Locale('ar'): 'العربية',
                  };

                  return _buildExpansionTile(
                    context: context,
                    key: ValueKey(currentLocale),
                    title: localizations.cv_language,
                    icon: Icons.translate_outlined,
                    initiallyExpanded: langController.isLanguageExpanded.value,
                    onExpansionChanged: (expanded) {
                      langController.isLanguageExpanded.value = expanded;
                    },
                    children: languages.entries.map((entry) {
                      final isSelected = currentLocale == entry.key;
                      return InkWell(
                        onTap: () {
                          langController.changeLanguage(entry.key);
                          langController.isLanguageExpanded.value = false;
                        },
                        child: CVDrawerTile(
                          title: entry.value,
                          iconData: isSelected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          isActive: isSelected,
                          isChild: true,
                        ),
                      );
                    }).toList(),
                  );
                }),

                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
                  child: Divider(
                    color: CVTheme.textColor(context).withOpacity(0.1),
                    height: 1,
                  ),
                ),
                const SizedBox(height: 4),

                InkWell(
                  onTap: () {
                    Get.back();
                    Get.toNamed(IbLandingView.id);
                  },
                  child: CVDrawerTile(
                    title: AppLocalizations.of(context)!.cv_interactive_book,
                    iconData: Icons.menu_book_outlined,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    Get.back();
                    final url = await Get.toNamed(SimulatorView.id);
                    if (url is String) {
                      if (url.contains('sign_out')) {
                        _model.onLogoutPressed();
                      } else if (url.contains('edit')) {
                        SnackBarUtils.showDark(
                          AppLocalizations.of(context)!.group_details_project_created,
                          AppLocalizations.of(context)!.group_details_project_created_success,
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
                    iconData: Icons.info_outline,
                    isActive: selected == 2,
                  ),
                ),
                InkWell(
                  onTap: () => _model.setSelectedIndexTo(3),
                  child: CVDrawerTile(
                    title: AppLocalizations.of(context)!.cv_contribute,
                    iconData: Icons.volunteer_activism_outlined,
                    isActive: selected == 3,
                  ),
                ),
                InkWell(
                  onTap: () => _model.setSelectedIndexTo(4),
                  child: CVDrawerTile(
                    title: AppLocalizations.of(context)!.cv_teachers,
                    iconData: Icons.school_outlined,
                    isActive: selected == 4,
                  ),
                ),
                if (_model.isLoggedIn) ...[
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
                    child: Divider(
                      color: CVTheme.textColor(context).withOpacity(0.1),
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  InkWell(
                    onTap: () => _model.setSelectedIndexTo(8),
                    child: CVDrawerTile(
                      title: AppLocalizations.of(context)!.cv_notifications,
                      iconData: Icons.notifications_outlined,
                      pending: _model.hasPendingNotif,
                      isActive: selected == 8,
                    ),
                  ),
                  _buildExpansionTile(
                    context: context,
                    title: _model.currentUser?.data.attributes.name ?? 
                           AppLocalizations.of(context)!.cv_profile,
                    icon: Icons.account_circle_outlined,
                    isActive: selected == 5 || selected == 6,
                    children: <Widget>[
                      InkWell(
                        onTap: () => _model.setSelectedIndexTo(5),
                        child: CVDrawerTile(
                          title: AppLocalizations.of(context)!.cv_profile,
                          iconData: Icons.person_outline,
                          isActive: selected == 5,
                          isChild: true,
                        ),
                      ),
                      InkWell(
                        onTap: () => _model.setSelectedIndexTo(6),
                        child: CVDrawerTile(
                          title: AppLocalizations.of(context)!.cv_my_groups,
                          iconData: Icons.group_outlined,
                          isActive: selected == 6,
                          isChild: true,
                        ),
                      ),
                      InkWell(
                        onTap: _model.onLogoutPressed,
                        child: CVDrawerTile(
                          title: AppLocalizations.of(context)!.cv_logout,
                          iconData: Icons.logout_outlined,
                          isChild: true,
                        ),
                      ),
                    ],
                  ),
                ] else
                  InkWell(
                    onTap: () => Get.offAndToNamed(LoginView.id),
                    child: CVDrawerTile(
                      title: AppLocalizations.of(context)!.cv_login,
                      iconData: Icons.login_outlined,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
