import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app_theme.dart';
import 'package:mobile_app/models/groups.dart';
import 'package:mobile_app/ui/views/groups/components/group_card_button.dart';
import 'package:mobile_app/ui/views/groups/group_details_view.dart';

class GroupMemberCard extends StatelessWidget {
  final Group group;

  const GroupMemberCard({Key key, this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            width: 10,
            color: AppTheme.primaryColor,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.grey,
            offset: Offset(0, 3),
            blurRadius: 2,
          ),
        ],
        color: AppTheme.bgCard,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Text(
                  group.attributes.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    'Total Members: ${group.attributes.memberCount}',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ],
            ),
          ),
          CardButton(
            onPressed: () => Get.toNamed(GroupDetailsView.id, arguments: group),
            color: AppTheme.primaryColor,
            title: 'View',
          )
        ],
      ),
    );
  }
}
