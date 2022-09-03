import 'package:flutter/material.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/viewmodels/notifications/notifications_viewmodel.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<NotificationsViewModel>(
      onModelReady: (model) => model.fetchNotifications(),
      builder: (context, model, _) {
        return const Scaffold(
          body: Center(
            child: Text('Notifications Page'),
          ),
        );
      },
    );
  }
}
