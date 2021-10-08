import 'package:flutter/material.dart';
import 'package:mobile_app/cv_theme.dart';
import 'package:mobile_app/models/group_members.dart';

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
        border: Border.all(color: CVTheme.primaryColorLight),
        boxShadow: [
          BoxShadow(
            color: CVTheme.boxShadow(context),
            offset: Offset(0, 3),
            blurRadius: 2,
          )
        ],
        color: CVTheme.boxBg(context),
      ),
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
          if (hasMentorAccess)
            IconButton(
              icon: Icon(Icons.delete_outline),
              color: CVTheme.red,
              onPressed: onDeletePressed,
            )
          else
            Container()
        ],
      ),
    );
  }
}
