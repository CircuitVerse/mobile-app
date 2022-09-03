import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
  const CVDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _model = context.read<CVLandingViewModel>();
    return Drawer(
      child: Stack(
        children: [
          ListView(
            children: <Widget>[
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 32, horizontal: 10),
                child: Image.asset(
                  'assets/images/landing/cv_full_logo.png',
                  width: 90,
                ),
              ),
              InkWell(
                onTap: () => _model.setSelectedIndexTo(0),
                child: CVDrawerTile(
                  title: AppLocalizations.of(context)!.home,
                  iconData: Icons.home,
                ),
              ),
              Theme(
                data: CVTheme.themeData(context),
                child: ExpansionTile(
                  maintainState: true,
                  title: ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    leading: Icon(
                      Icons.explore,
                      color: CVTheme.drawerIcon(context),
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.explore,
                      style: Theme.of(context).textTheme.headline6,
                    ),
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
              InkWell(
                onTap: () => Get.toNamed(IbLandingView.id),
                child: CVDrawerTile(
                  title: AppLocalizations.of(context)!.interactive_book,
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
                      // close the drawer
                      Get.back();
                      // show the snackbar
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
                  title: AppLocalizations.of(context)!.simulator,
                  iconData: FontAwesome5.atom,
                ),
              ),
              InkWell(
                onTap: () => _model.setSelectedIndexTo(2),
                child: CVDrawerTile(
                  title: AppLocalizations.of(context)!.about,
                  iconData: FontAwesome5.address_card,
                ),
              ),
              InkWell(
                onTap: () => _model.setSelectedIndexTo(3),
                child: CVDrawerTile(
                  title: AppLocalizations.of(context)!.contribute,
                  iconData: Icons.add,
                ),
              ),
              InkWell(
                onTap: () => _model.setSelectedIndexTo(4),
                child: CVDrawerTile(
                  title: AppLocalizations.of(context)!.teachers,
                  iconData: Icons.account_balance,
                ),
              ),
              if (_model.isLoggedIn) ...[
                InkWell(
                  onTap: () => _model.setSelectedIndexTo(8),
                  child: CVDrawerTile(
                    title: AppLocalizations.of(context)!.notifications,
                    iconData: FontAwesome.bell,
                    pending: _model.hasPendingNotif,
                  ),
                ),
                Theme(
                  data: CVTheme.themeData(context),
                  child: ExpansionTile(
                    maintainState: true,
                    iconColor: CVTheme.textColor(context),
                    title: Text(
                      _model.currentUser?.data.attributes.name ?? '',
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    children: <Widget>[
                      InkWell(
                        onTap: () => _model.setSelectedIndexTo(5),
                        child: CVDrawerTile(
                          title: AppLocalizations.of(context)!.profile,
                          iconData: FontAwesome5.user,
                        ),
                      ),
                      InkWell(
                        onTap: () => _model.setSelectedIndexTo(6),
                        child: CVDrawerTile(
                          title: AppLocalizations.of(context)!.my_groups,
                          iconData: FontAwesome5.object_group,
                        ),
                      ),
                      InkWell(
                        onTap: _model.onLogoutPressed,
                        child: CVDrawerTile(
                          title: AppLocalizations.of(context)!.logout,
                          iconData: FontAwesome.logout,
                        ),
                      ),
                    ],
                  ),
                )
              ] else
                InkWell(
                  onTap: () => Get.offAndToNamed(LoginView.id),
                  child: CVDrawerTile(
                    title: AppLocalizations.of(context)!.login,
                    iconData: FontAwesome.login,
                  ),
                )
            ],
          ),
          Positioned(
            right: 5,
            top: 35,
            child: IconButton(
              icon: Theme.of(context).brightness == Brightness.dark
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
