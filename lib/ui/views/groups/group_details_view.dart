import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/cv_theme.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/assignments.dart';
import 'package:mobile_app/models/groups.dart';
import 'package:mobile_app/services/dialog_service.dart';
import 'package:mobile_app/ui/components/cv_primary_button.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/ui/views/groups/add_assignment_view.dart';
import 'package:mobile_app/ui/views/groups/components/assignment_card.dart';
import 'package:mobile_app/ui/views/groups/components/member_card.dart';
import 'package:mobile_app/ui/views/groups/edit_group_view.dart';
import 'package:mobile_app/ui/views/groups/update_assignment_view.dart';
import 'package:mobile_app/utils/snackbar_utils.dart';
import 'package:mobile_app/utils/validators.dart';
import 'package:mobile_app/ui/components/cv_flat_button.dart';
import 'package:mobile_app/viewmodels/groups/group_details_viewmodel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GroupDetailsView extends StatefulWidget {
  static const String id = 'group_details_view';
  final Group group;

  const GroupDetailsView({Key key, this.group}) : super(key: key);

  @override
  _GroupDetailsViewState createState() => _GroupDetailsViewState();
}

class _GroupDetailsViewState extends State<GroupDetailsView> {
  final DialogService _dialogService = locator<DialogService>();
  GroupDetailsViewModel _model;
  final _formKey = GlobalKey<FormState>();
  String _emails;
  Group _recievedGroup;
  final GlobalKey<CVFlatButtonState> addButtonGlobalKey =
      GlobalKey<CVFlatButtonState>();

  @override
  void initState() {
    super.initState();
    _recievedGroup = widget.group;
  }

  Widget _buildEditGroupButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        primary: CVTheme.primaryColor,
      ),
      onPressed: () async {
        var _updatedGroup = await Get.toNamed(
          EditGroupView.id,
          arguments: _recievedGroup,
        );
        if (_updatedGroup is Group) {
          setState(() {
            _recievedGroup = _updatedGroup;
          });
        }
      },
      child: Row(
        children: [
          Icon(Icons.edit, color: Colors.white),
          SizedBox(width: 8),
          Text(
            AppLocalizations.of(context).edit,
            style: Theme.of(context).textTheme.headline6.copyWith(
                  color: Colors.white,
                ),
          )
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: Text(
                _recievedGroup.attributes.name,
                style: Theme.of(context).textTheme.headline4.copyWith(
                      color: CVTheme.textColor(context),
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            if (_recievedGroup.isMentor) ...[
              SizedBox(width: 12),
              _buildEditGroupButton(),
            ]
          ],
        ),
        RichText(
          text: TextSpan(
            text: AppLocalizations.of(context).mentor,
            style: Theme.of(context).textTheme.headline6.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            children: <TextSpan>[
              TextSpan(
                text: _recievedGroup.attributes.mentorName,
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
        )
      ],
    );
  }

  Future<void> onAddGroupMemberPressed(BuildContext context) async {
    if (Validators.validateAndSaveForm(_formKey)) {
      FocusScope.of(context).requestFocus(FocusNode());
      Navigator.pop(context);

      _dialogService.showCustomProgressDialog(title: AppLocalizations.of(context).adding);

      await _model.addMembers(_recievedGroup.id, _emails);

      _dialogService.popDialog();

      if (_model.isSuccess(_model.ADD_GROUP_MEMBERS) &&
          _model.addedMembersSuccessMessage.isNotEmpty) {
        SnackBarUtils.showDark(
          AppLocalizations.of(context).group_member_added,
          _model.addedMembersSuccessMessage,
        );
      } else if (_model.isError(_model.ADD_GROUP_MEMBERS)) {
        SnackBarUtils.showDark(
          AppLocalizations.of(context).error,
          _model.errorMessageFor(_model.ADD_GROUP_MEMBERS),
        );
      }
    }
    setState(() => _emails = null);
  }

  void showAddGroupMemberDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).add_group_members,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  AppLocalizations.of(context).enter_members_email_ids,
                  style: Theme.of(context).textTheme.bodyText1,
                )
              ],
            ),
            content: Form(
              key: _formKey,
              child: TextFormField(
                maxLines: 5,
                autofocus: true,
                decoration: CVTheme.textFieldDecoration.copyWith(
                  hintText: AppLocalizations.of(context).email_ids,
                ),
                validator: (emails) => Validators.areEmailsValid(emails)
                    ? null
                    : AppLocalizations.of(context).enter_valid_email,
                onSaved: (emails) =>
                    _emails = emails.replaceAll(' ', '').trim(),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.of(context).cancel_btn),
              ),
              CVFlatButton(
                key: addButtonGlobalKey,
                triggerFunction: onAddGroupMemberPressed,
                context: context,
                buttonText: AppLocalizations.of(context).add_btn,
              ),
            ],
          );
        });
  }

  Future<void> onDeleteGroupMemberPressed(String groupMemberId) async {
    var _dialogResponse = await _dialogService.showConfirmationDialog(
      title: AppLocalizations.of(context).remove_group_member,
      description: AppLocalizations.of(context).remove_group_member_confirmation,
      confirmationTitle: AppLocalizations.of(context).remove_btn,
    );

    if (_dialogResponse.confirmed) {
      _dialogService.showCustomProgressDialog(title: AppLocalizations.of(context).removing);

      await _model.deleteGroupMember(groupMemberId);

      _dialogService.popDialog();

      if (_model.isSuccess(_model.DELETE_GROUP_MEMBER)) {
        SnackBarUtils.showDark(
          AppLocalizations.of(context).group_member_removed,
          AppLocalizations.of(context).group_member_removed_acknowledgement,
        );
      } else if (_model.isError(_model.DELETE_GROUP_MEMBER)) {
        SnackBarUtils.showDark(
          AppLocalizations.of(context).error,
          _model.errorMessageFor(_model.DELETE_GROUP_MEMBER),
        );
      }
    }
  }

  Widget _buildSubHeader({String title, VoidCallback onAddPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.headline5.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          if (_recievedGroup.isMentor)
            CVPrimaryButton(
              title: AppLocalizations.of(context).add_btn_primary,
              onPressed: onAddPressed,
              padding: const EdgeInsets.symmetric(horizontal: 10),
            )
        ],
      ),
    );
  }

  Future<void> onAddAssignmentPressed() async {
    var _result = await Get.toNamed(
      AddAssignmentView.id,
      arguments: _recievedGroup.id,
    );

    if (_result is Assignment) _model.onAssignmentAdded(_result);
  }

  Future<void> onDeleteAssignmentPressed(String assignmentId) async {
    var _dialogResponse = await _dialogService.showConfirmationDialog(
      title: AppLocalizations.of(context).delete_assignment,
      description: AppLocalizations.of(context).delete_assignment_confirmation,
      confirmationTitle: AppLocalizations.of(context).delete_btn,
    );

    if (_dialogResponse.confirmed) {
      _dialogService.showCustomProgressDialog(title: AppLocalizations.of(context).deleting_assignment);

      await _model.deleteAssignment(assignmentId);

      _dialogService.popDialog();

      if (_model.isSuccess(_model.DELETE_ASSIGNMENT)) {
        SnackBarUtils.showDark(
          AppLocalizations.of(context).assignment_deleted,
          AppLocalizations.of(context).assignment_deleted_acknowledgement,
        );
      } else if (_model.isError(_model.DELETE_ASSIGNMENT)) {
        SnackBarUtils.showDark(
          AppLocalizations.of(context).error,
          _model.errorMessageFor(_model.DELETE_ASSIGNMENT),
        );
      }
    }
  }

  Future<void> onEditAssignmentPressed(Assignment assignment) async {
    var _result = await Get.toNamed(
      UpdateAssignmentView.id,
      arguments: assignment,
    );

    if (_result is Assignment) _model.onAssignmentUpdated(_result);
  }

  Future<void> onReopenAssignmentPressed(String assignmentId) async {
    var _dialogResponse = await _dialogService.showConfirmationDialog(
      title: AppLocalizations.of(context).reopen_assignment,
      description: AppLocalizations.of(context).reopen_assignment_confirmation,
      confirmationTitle: AppLocalizations.of(context).reopen_btn,
    );

    if (_dialogResponse.confirmed) {
      _dialogService.showCustomProgressDialog(title: AppLocalizations.of(context).reopening_assignment);

      await _model.reopenAssignment(assignmentId);

      _dialogService.popDialog();

      if (_model.isSuccess(_model.REOPEN_ASSIGNMENT)) {
        SnackBarUtils.showDark(
          AppLocalizations.of(context).assignment_reopened,
          AppLocalizations.of(context).assignment_reopened_acknowledgement,
        );
      } else if (_model.isError(_model.REOPEN_ASSIGNMENT)) {
        SnackBarUtils.showDark(
          AppLocalizations.of(context).error,
          _model.errorMessageFor(_model.REOPEN_ASSIGNMENT),
        );
      }
    }
  }

  Future<void> onStartAssignmentPressed(String assignmentId) async {
    var _dialogResponse = await _dialogService.showConfirmationDialog(
      title: AppLocalizations.of(context).start_assignment,
      description: AppLocalizations.of(context).start_assignment_confirmation,
      confirmationTitle: AppLocalizations.of(context).start_btn,
    );

    if (_dialogResponse.confirmed) {
      _dialogService.showCustomProgressDialog(title: AppLocalizations.of(context).starting_assignment);

      await _model.startAssignment(assignmentId);

      _dialogService.popDialog();

      if (_model.isSuccess(_model.START_ASSIGNMENT)) {
        SnackBarUtils.showDark(
          AppLocalizations.of(context).project_created,
          AppLocalizations.of(context).project_created_acknowledgement,
        );
      } else {
        SnackBarUtils.showDark(
          AppLocalizations.of(context).error,
          _model.errorMessageFor(_model.START_ASSIGNMENT),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<GroupDetailsViewModel>(
      onModelReady: (model) {
        _model = model;
        _model.fetchGroupDetails(_recievedGroup.id);
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context).group_details)),
        body: Builder(builder: (context) {
          var _items = <Widget>[];

          _items.add(_buildHeader());

          _items.add(SizedBox(height: 36));

          _items.add(
            _buildSubHeader(
              title: AppLocalizations.of(context).members,
              onAddPressed: showAddGroupMemberDialog,
            ),
          );

          if (_model.isSuccess(_model.FETCH_GROUP_DETAILS)) {
            _model.groupMembers.forEach((member) {
              _items.add(
                MemberCard(
                  member: member,
                  hasMentorAccess: _model.group.isMentor,
                  onDeletePressed: () => onDeleteGroupMemberPressed(member.id),
                ),
              );
            });
          }

          _items.add(SizedBox(height: 36));

          _items.add(
            _buildSubHeader(
              title: AppLocalizations.of(context).assignments,
              onAddPressed: onAddAssignmentPressed,
            ),
          );

          if (_model.isSuccess(_model.FETCH_GROUP_DETAILS)) {
            _model.assignments.forEach((assignment) {
              _items.add(
                AssignmentCard(
                  assignment: assignment,
                  onDeletePressed: () =>
                      onDeleteAssignmentPressed(assignment.id),
                  onEditPressed: () => onEditAssignmentPressed(assignment),
                  onReopenPressed: () =>
                      onReopenAssignmentPressed(assignment.id),
                  onStartPressed: () => onStartAssignmentPressed(assignment.id),
                ),
              );
            });
          }

          return ListView(
            padding: const EdgeInsets.all(8),
            children: _items,
          );
        }),
      ),
    );
  }
}
