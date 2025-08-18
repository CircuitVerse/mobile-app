import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/cv_theme.dart';
import 'package:mobile_app/enums/notification_type.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/viewmodels/cv_landing_viewmodel.dart';
import 'package:mobile_app/viewmodels/notifications/notifications_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/gen_l10n/app_localizations.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  Widget _emptyState(BuildContext context, {required bool hasNoNotifications}) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(32.0),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 100),
          _buildSubHeader(
            context,
            title:
                hasNoNotifications
                    ? AppLocalizations.of(
                      context,
                    )!.notifications_no_notifications
                    : AppLocalizations.of(context)!.notifications_no_unread,
            subtitle:
                hasNoNotifications
                    ? AppLocalizations.of(context)!.notifications_will_appear
                    : AppLocalizations.of(
                      context,
                    )!.notifications_no_unread_desc,
          ),
        ],
      ),
    );
  }

  Widget _buildSubHeader(
    BuildContext context, {
    required String title,
    String? subtitle,
  }) {
    return Column(
      children: [
        Icon(Icons.notifications_none, size: 64, color: Colors.grey[400]),
        const SizedBox(height: 24),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 16),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.grey[600],
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<NotificationsViewModel>(
      onModelReady: (model) => model.fetchNotifications(),
      builder: (context, model, _) {
        Future.delayed(const Duration(seconds: 1), () {
          context.read<CVLandingViewModel>().hasPendingNotif = model.hasUnread;
        });

        if (model.isBusy(model.FETCH_NOTIFICATIONS)) {
          return const Column(
            children: [
              SizedBox(height: 200),
              Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
              ),
            ],
          );
        }

        final hasNoNotifications = model.notifications.isEmpty;
        final hasNoUnread =
            !hasNoNotifications &&
            model.value == AppLocalizations.of(context)!.notifications_unread &&
            model.notifications.every((n) => !n.attributes.unread);

        final String allValue = 'all';
        final String unreadValue = 'unread';

        final String allDisplayText =
            AppLocalizations.of(context)!.notifications_all;
        final String unreadDisplayText =
            AppLocalizations.of(context)!.notifications_unread;

        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.symmetric(
                      vertical: 10,
                    ),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: SizedBox(
                        width: 130,
                        child: DropdownButtonFormField<String>(
                          isDense: true,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsetsDirectional.symmetric(
                              horizontal: 8,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                          // Fix: Use model.value but map it properly
                          initialValue:
                              model.value == allDisplayText
                                  ? allValue
                                  : unreadValue,
                          items: [
                            DropdownMenuItem(
                              value: allValue,
                              child: Text(allDisplayText),
                            ),
                            DropdownMenuItem(
                              value: unreadValue,
                              child: Text(unreadDisplayText),
                            ),
                          ],
                          onChanged: (value) {
                            if (value == null) return;
                            // Fix: Map back to localized string for model
                            model.value =
                                value == allValue
                                    ? allDisplayText
                                    : unreadDisplayText;
                          },
                        ),
                      ),
                    ),
                  ),
                  if (hasNoNotifications || hasNoUnread)
                    _emptyState(
                      context,
                      hasNoNotifications: hasNoNotifications,
                    ),
                  ...model.notifications
                      .where(
                        (notification) =>
                            model.value != unreadDisplayText ||
                            notification.attributes.unread,
                      )
                      .map((notification) {
                        NotificationType type =
                            notification.attributes.type.toLowerCase().contains(
                                  'star',
                                )
                                ? NotificationType.Star
                                : NotificationType.Fork;

                        return Card(
                          margin: const EdgeInsetsDirectional.symmetric(
                            vertical: 6,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsetsDirectional.all(12),
                            onTap: () => model.markAsRead(notification.id),
                            leading: Container(
                              padding: const EdgeInsetsDirectional.all(10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.withAlpha(50),
                              ),
                              child: Icon(
                                type == NotificationType.Star
                                    ? FontAwesome.star
                                    : FontAwesome.fork,
                                color: CVTheme.primaryColor,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              '${notification.attributes.params.user.data.attributes.name} '
                              '${type == NotificationType.Fork ? AppLocalizations.of(context)!.notifications_forked : AppLocalizations.of(context)!.notifications_starred} '
                              '${AppLocalizations.of(context)!.notifications_your_project} '
                              '${notification.attributes.params.project.name}',
                              style: TextStyle(
                                fontWeight:
                                    notification.attributes.unread
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            subtitle: Text(
                              DateFormat.yMMMMd().add_jm().format(
                                notification.attributes.updatedAt,
                              ),
                              style: TextStyle(
                                fontWeight:
                                    notification.attributes.unread
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                      }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
