import 'package:flutter/material.dart';
import 'package:mobile_app/cv_theme.dart';
import 'package:mobile_app/models/group_members.dart';

class MemberCard extends StatelessWidget {
  const MemberCard({
    Key? key,
    required this.member,
    this.hasMentorAccess = false,
    required this.onDeletePressed,
    required this.onEditPressed,
  }) : super(key: key);

  final GroupMember member;
  final bool hasMentorAccess;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

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
            offset: const Offset(0, 3),
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
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  member.attributes.email ?? 'No Email',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          if (hasMentorAccess)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: onEditPressed,
                  child: const Icon(
                    Icons.edit_outlined,
                    color: CVTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: onDeletePressed,
                  child: const Icon(
                    Icons.delete_outline,
                    color: CVTheme.red,
                  ),
                ),
              ],
            )
          else
            Container()
        ],
      ),
    );
  }
}
