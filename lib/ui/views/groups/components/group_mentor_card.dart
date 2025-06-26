import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/cv_theme.dart';
import 'package:mobile_app/models/groups.dart';
import 'package:mobile_app/ui/views/groups/components/group_card_button.dart';
import 'package:mobile_app/ui/views/groups/group_details_view.dart';
import 'package:mobile_app/gen_l10n/app_localizations.dart';

class GroupMentorCard extends StatefulWidget {
  const GroupMentorCard({
    super.key,
    required this.group,
    required this.onEdit,
    required this.onDelete,
  });

  static const String id = 'group_mentor_card_view';

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
      padding: const EdgeInsetsDirectional.all(16),
      margin: const EdgeInsetsDirectional.all(8),
      decoration: BoxDecoration(
        border: const Border(
          top: BorderSide(width: 10, color: CVTheme.primaryColor),
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
      child: Column(
        children: <Widget>[
          Text(
            widget.group.attributes.name,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(vertical: 12),
            child: Text(
              '${AppLocalizations.of(context)!.group_mentor_count}: ${widget.group.attributes.memberCount}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Flexible(
                child: CardButton(
                  onPressed:
                      () => Get.toNamed(
                        GroupDetailsView.id,
                        arguments: widget.group,
                      ),
                  color: CVTheme.primaryColor,
                  title: AppLocalizations.of(context)!.group_mentor_card_view,
                ),
              ),
              Flexible(
                child: CardButton(
                  onPressed: widget.onEdit,
                  color: CVTheme.blue,
                  title: AppLocalizations.of(context)!.group_mentor_card_edit,
                ),
              ),
              Flexible(
                child: CardButton(
                  onPressed: widget.onDelete,
                  color: CVTheme.red,
                  title: AppLocalizations.of(context)!.group_mentor_card_delete,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
