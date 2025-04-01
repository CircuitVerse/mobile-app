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
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<NotificationsViewModel>(
      onModelReady: (model) => model.fetchNotifications(),
      builder: (context, model, _) {
        Future.delayed(const Duration(seconds: 1), () {
          context.read<CVLandingViewModel>().hasPendingNotif = model.hasUnread;
        });

        final filteredNotifications =
            model.notifications.where((notification) {
              return model.value != 'Unread' || notification.attributes.unread;
            }).toList();

        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: SizedBox(
                        width: 130, // Fixed width to prevent overflow
                        child: DropdownButtonFormField<String>(
                          isDense: true,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                          value: model.value,
                          items: const [
                            DropdownMenuItem(value: 'All', child: Text('All')),
                            DropdownMenuItem(
                              value: 'Unread',
                              child: Text('Unread'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value == null) return;
                            model.value = value;
                          },
                        ),
                      ),
                    ),
                  ),
                  if (filteredNotifications.isEmpty)
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Center(
                        child: Text(
                          'No notifications found',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: Colors.grey.shade600),
                        ),
                      ),
                    )
                  else
                    ...filteredNotifications.map((notification) {
                      NotificationType type =
                          notification.attributes.type.toLowerCase().contains(
                                'star',
                              )
                              ? NotificationType.Star
                              : NotificationType.Fork;

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          onTap: () => model.markAsRead(notification.id),
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.withAlpha(50),
                            ),
                            child: Icon(
                              type == NotificationType.Star
                                  ? FontAwesome.star
                                  : FontAwesome.fork,
                              color: CVTheme.primaryColor,
                              size: 20, // Fixed icon size
                            ),
                          ),
                          title: Text(
                            '${notification.attributes.params.user.data.attributes.name} '
                            '${type == NotificationType.Fork ? 'forked' : 'starred'} your project '
                            '${notification.attributes.params.project.name}',
                            style: TextStyle(
                              fontWeight:
                                  notification.attributes.unread
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                            overflow:
                                TextOverflow.ellipsis, // Prevents overflow
                            maxLines: 2, // Limits to 2 lines
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
                            overflow:
                                TextOverflow.ellipsis, // Prevents overflow
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
