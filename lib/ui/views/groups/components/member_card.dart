import 'package:flutter/material.dart';
import 'package:mobile_app/app_theme.dart';
import 'package:mobile_app/models/group_members.dart';
import 'package:theme_provider/theme_provider.dart';

class MemberCard extends StatelessWidget {
  final GroupMember member;
  final bool hasMentorAccess;
  final VoidCallback onDeletePressed;

  const MemberCard({
    Key key,
    this.member,
    this.hasMentorAccess = false,
    this.onDeletePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          border: Border.all(color: PrimaryAppTheme.primaryColorLight),
          boxShadow: [
            BoxShadow(
              color: PrimaryAppTheme.boxShadow(context),
              offset: Offset(0, 3),
              blurRadius: 2,
            )
          ],
          color: PrimaryAppTheme.boxBg(context)),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Text(
                  member.attributes.name ?? 'No Name',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  member.attributes.email ?? 'No Email',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
          hasMentorAccess
              ? IconButton(
                  icon: Icon(Icons.delete_outline),
                  color: PrimaryAppTheme.red,
                  onPressed: onDeletePressed,
                )
              : Container()
        ],
      ),
    );
  }
}
