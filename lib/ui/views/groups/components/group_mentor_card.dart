import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/cv_theme.dart';
import 'package:mobile_app/models/groups.dart';
import 'package:mobile_app/ui/views/groups/components/group_card_button.dart';
import 'package:mobile_app/ui/views/groups/group_details_view.dart';

class GroupMentorCard extends StatefulWidget {
  const GroupMentorCard({
    Key? key,
    required this.group,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  final Group group;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

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
        border: const Border(
          top: BorderSide(
            width: 10,
            color: CVTheme.primaryColor,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: CVTheme.boxShadow(context),
            offset: const Offset(0, 3),
            blurRadius: 2,
          )
        ],
        color: CVTheme.boxBg(context),
      ),
      child: Column(
        children: <Widget>[
          Text(
            widget.group.attributes.name,
            style: Theme.of(context).textTheme.headline5?.copyWith(
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Flexible(
                child: CardButton(
                  onPressed: () =>
                      Get.toNamed(GroupDetailsView.id, arguments: widget.group),
                  color: CVTheme.primaryColor,
                  title: 'View',
                ),
              ),
              Flexible(
                child: CardButton(
                  onPressed: widget.onEdit,
                  color: CVTheme.blue,
                  title: 'Edit',
                ),
              ),
              Flexible(
                child: CardButton(
                  onPressed: widget.onDelete,
                  color: CVTheme.red,
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
