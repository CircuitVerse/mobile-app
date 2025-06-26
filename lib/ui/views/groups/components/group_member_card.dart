import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/cv_theme.dart';
import 'package:mobile_app/gen_l10n/app_localizations.dart';
import 'package:mobile_app/models/groups.dart';
import 'package:mobile_app/ui/views/groups/components/group_card_button.dart';
import 'package:mobile_app/ui/views/groups/group_details_view.dart';

class GroupMemberCard extends StatelessWidget {
  const GroupMemberCard({super.key, required this.group});

  static const String id = 'group_member_card_view';

  final Group group;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.all(16),
      margin: const EdgeInsetsDirectional.all(8),
      decoration: BoxDecoration(
        border: BorderDirectional(
          start: BorderSide(width: 10, color: CVTheme.primaryColor),
        ),
        boxShadow: [
          BoxShadow(
            color: CVTheme.boxShadow(context),
            offset: const Offset(0, 3),
            blurRadius: 2,
          ),
        ],
        color: CVTheme.boxBg(context),
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
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(vertical: 4),
                  child: Text(
                    '${AppLocalizations.of(context)!.group_member_count}: ${group.attributes.memberCount}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
          ),
          CardButton(
            onPressed: () => Get.toNamed(GroupDetailsView.id, arguments: group),
            color: CVTheme.primaryColor,
            title: AppLocalizations.of(context)!.group_member_card_view,
          ),
        ],
      ),
    );
  }
}
