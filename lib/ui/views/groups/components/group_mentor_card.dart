import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app_theme.dart';
import 'package:mobile_app/models/groups.dart';
import 'package:mobile_app/ui/views/groups/components/group_card_button.dart';
import 'package:mobile_app/ui/views/groups/group_details_view.dart';

class GroupMentorCard extends StatefulWidget {
  final Group group;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const GroupMentorCard({Key key, this.group, this.onEdit, this.onDelete})
      : super(key: key);

  @override
  _GroupMentorCardState createState() => _GroupMentorCardState();
}

class _GroupMentorCardState extends State<GroupMentorCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 10,
            color: AppTheme.primaryColor,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.grey,
            offset: Offset(0, 3),
            blurRadius: 2,
          )
        ],
        color: AppTheme.bgCard,
      ),
      child: Column(
        children: <Widget>[
          Text(
            widget.group.attributes.name,
            style: Theme.of(context).textTheme.headline5.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Total Members: ${widget.group.attributes.memberCount}',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Flexible(
                child: CardButton(
                  onPressed: () =>
                      Get.toNamed(GroupDetailsView.id, arguments: widget.group),
                  color: AppTheme.primaryColor,
                  title: 'View',
                ),
              ),
              Flexible(
                child: CardButton(
                  onPressed: widget.onEdit,
                  color: AppTheme.blue,
                  title: 'Edit',
                ),
              ),
              Flexible(
                child: CardButton(
                  onPressed: widget.onDelete,
                  color: AppTheme.red,
                  title: 'Delete',
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
