import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/cv_theme.dart';
import 'package:mobile_app/models/groups.dart';
import 'package:mobile_app/ui/views/groups/components/group_card_button.dart';
import 'package:mobile_app/ui/views/groups/group_details_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            color: CVTheme.primaryColor,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: CVTheme.boxShadow(context),
            offset: Offset(0, 3),
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
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    AppLocalizations.of(context).total_members(group.attributes.memberCount),
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ],
            ),
          ),
          CardButton(
            onPressed: () => Get.toNamed(GroupDetailsView.id, arguments: group),
            color: CVTheme.primaryColor,
            title: AppLocalizations.of(context).view,
          )
        ],
      ),
    );
  }
}
