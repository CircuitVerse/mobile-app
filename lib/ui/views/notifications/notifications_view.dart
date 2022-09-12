import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/cv_theme.dart';
import 'package:mobile_app/enums/notification_type.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/viewmodels/cv_landing_viewmodel.dart';
import 'package:mobile_app/viewmodels/notifications/notifications_viewmodel.dart';
import 'package:provider/provider.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<NotificationsViewModel>(
      onModelReady: (model) => model.fetchNotifications(),
      builder: (context, model, _) {
        Future.delayed(const Duration(seconds: 1), () {
          context.read<CVLandingViewModel>().hasPendingNotif = model.hasUnread;
        });

        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: SizedBox(
                      width: 110,
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        value: model.value,
                        items: const [
                          DropdownMenuItem(
                            value: 'All',
                            child: Text('All'),
                          ),
                          DropdownMenuItem(
                            value: 'Unread',
                            child: Text('Unread'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }

                          model.value = value;
                        },
                      ),
                    ),
                  ),
                ),
                ...model.notifications.map((notification) {
                  if (model.value == 'Unread' &&
                      !notification.attributes.unread) {
                    return const SizedBox();
                  }

                  NotificationType type = notification.attributes.type
                          .toLowerCase()
                          .contains('star')
                      ? NotificationType.Star
                      : NotificationType.Fork;

                  return Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(8.0),
                      onTap: () {
                        model.markAsRead(notification.id);
                      },
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        child: Icon(
                          type == NotificationType.Star
                              ? FontAwesome.star
                              : FontAwesome.fork,
                          color: CVTheme.primaryColor,
                        ),
                      ),
                      title: Text(
                        '${notification.attributes.params.user.data.attributes.name} '
                        'forked your project '
                        '${notification.attributes.params.project.name}',
                        style: TextStyle(
                          fontWeight: notification.attributes.unread
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      subtitle: Text(
                        DateFormat.yMMMMd()
                            .add_jm()
                            .format(notification.attributes.updatedAt),
                        style: TextStyle(
                          fontWeight: notification.attributes.unread
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }
}
