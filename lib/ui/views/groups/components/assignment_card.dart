import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/cv_theme.dart';
import 'package:mobile_app/models/assignments.dart';
import 'package:mobile_app/ui/views/groups/assignment_details_view.dart';
import 'package:mobile_app/ui/views/groups/components/group_card_button.dart';
import 'package:mobile_app/gen_l10n/app_localizations.dart';

class AssignmentCard extends StatefulWidget {
  const AssignmentCard({
    super.key,
    required this.assignment,
    required this.onDeletePressed,
    required this.onEditPressed,
    required this.onReopenPressed,
    required this.onStartPressed,
  });

  static const String id = 'assignment_card_view';

  final Assignment assignment;
  final VoidCallback onDeletePressed;
  final VoidCallback onEditPressed;
  final VoidCallback onReopenPressed;
  final VoidCallback onStartPressed;

  @override
  _AssignmentCardState createState() => _AssignmentCardState();
}

class _AssignmentCardState extends State<AssignmentCard> {
  Widget _buildAssignmentComponent(String title, String description) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyLarge,
        children: <TextSpan>[
          TextSpan(
            text: '$title : ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentButtons() {
    var _items = <Widget>[];
    var _isMentor = widget.assignment.attributes.hasPrimaryMentorAccess;
    var _isOpen = widget.assignment.attributes.status != 'closed';
    var _isDeadlineOver = widget.assignment.attributes.deadline.isBefore(
      DateTime.now(),
    );
    var _projectId = widget.assignment.attributes.currentUserProjectId;

    /// Adds Show assignment details button..
    /// Will be there irrespective of assignment attributes..
    _items.add(
      Flexible(
        child: CardButton(
          title: AppLocalizations.of(context)!.assignment_card_view,
          onPressed:
              () => Get.toNamed(
                AssignmentDetailsView.id,
                arguments: widget.assignment,
              ),
          color: CVTheme.primaryColor,
        ),
      ),
    );

    if (_isMentor) {
      if (_isOpen) {
        /// Adds Edit Button if _isMentor && _isOpen
        _items.add(
          Flexible(
            child: CardButton(
              title: AppLocalizations.of(context)!.assignment_card_edit,
              onPressed: widget.onEditPressed,
              color: CVTheme.blue,
            ),
          ),
        );
      } else {
        /// Adds Reopen Button id _isMentor && _isNotOpen
        _items.add(
          Flexible(
            child: CardButton(
              title: AppLocalizations.of(context)!.assignment_card_reopen,
              onPressed: widget.onReopenPressed,
              color: CVTheme.blue,
            ),
          ),
        );
      }

      /// Adds Delete button if _isMentor
      _items.add(
        Flexible(
          child: CardButton(
            title: AppLocalizations.of(context)!.assignment_card_delete,
            onPressed: widget.onDeletePressed,
            color: CVTheme.red,
          ),
        ),
      );
    } else {
      if (_isDeadlineOver) {
        if (_projectId != null) {
          /// Add View Submission Button if _isProjectPresent & _isDeadlineOver
          _items.add(
            Flexible(
              child: CardButton(
                title:
                    AppLocalizations.of(
                      context,
                    )!.assignment_card_view_submission,
                onPressed: () {},
                color: CVTheme.blue,
              ),
            ),
          );
        } else {
          /// Add Not Submitted Button if _isProjectNotPresent & _isDeadlineOver
          debugPrint(
            AppLocalizations.of(context)!.assignment_card_not_submitted,
          );
        }
      } else {
        if (_projectId != null) {
          /// Add View Your Work Button if _isProjectPresent & _isDeadlineNotOver
          _items.add(
            Flexible(
              child: CardButton(
                title:
                    AppLocalizations.of(
                      context,
                    )!.assignment_card_view_your_work,
                onPressed: () {},
                color: CVTheme.blue,
              ),
            ),
          );
        } else {
          /// Add Start Working Button if _isProjectNotPresent & _isDeadlineNotOver
          _items.add(
            Flexible(
              child: CardButton(
                title:
                    AppLocalizations.of(context)!.assignment_card_start_working,
                onPressed: widget.onStartPressed,
                color: CVTheme.blue,
              ),
            ),
          );
        }
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _items,
    );
  }

  @override
  Widget build(BuildContext context) {
    var deadlineFormat = DateFormat.yMEd().add_jms();

    return Container(
      padding: const EdgeInsetsDirectional.all(16),
      margin: const EdgeInsetsDirectional.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: CVTheme.primaryColorLight),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            widget.assignment.attributes.name ??
                AppLocalizations.of(context)!.assignment_card_no_name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          _buildAssignmentComponent(
            AppLocalizations.of(context)!.assignment_card_grading,
            widget.assignment.attributes.gradingScale,
          ),
          _buildAssignmentComponent(
            AppLocalizations.of(context)!.assignment_card_deadline,
            deadlineFormat.format(widget.assignment.attributes.deadline),
          ),
          const SizedBox(height: 8),
          _buildAssignmentButtons(),
        ],
      ),
    );
  }
}
