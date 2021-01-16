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
    return RaisedButton(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Icon(Icons.edit, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'Edit',
            style: Theme.of(context).textTheme.headline6.copyWith(
                  color: Colors.white,
                ),
          )
        ],
      ),
      color: CVTheme.primaryColor,
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
            text: 'Mentor : ',
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

      _dialogService.showCustomProgressDialog(title: 'Adding');

      await _model.addMembers(_recievedGroup.id, _emails);

      _dialogService.popDialog();

      if (_model.isSuccess(_model.ADD_GROUP_MEMBERS) &&
          _model.addedMembersSuccessMessage.isNotEmpty) {
        SnackBarUtils.showDark(_model.addedMembersSuccessMessage);
      } else if (_model.isError(_model.ADD_GROUP_MEMBERS)) {
        SnackBarUtils.showDark(
            _model.errorMessageFor(_model.ADD_GROUP_MEMBERS));
      }
    }
    setState(() => _emails = null);
  }

  void showAddGroupMemberDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Add Group Members',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Enter Email IDs separated by commas. If users are not registered, an email ID will be sent requesting them to sign up.',
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
                    hintText: 'Email Ids',
                  ),
                  validator: (emails) => Validators.areEmailsValid(emails)
                      ? null
                      : 'Enter emails in valid format.',
                  onSaved: (emails) =>
                      _emails = emails.replaceAll(' ', '').trim(),
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('CANCEL'),
                  onPressed: () => Navigator.pop(context),
                ),
                CVFlatButton(
                  key: addButtonGlobalKey,
                  triggerFunction: onAddGroupMemberPressed,
                  context: context,
                  buttonText: 'ADD',
                ),
              ],
            ),
          );
        });
  }

  Future<void> onDeleteGroupMemberPressed(String groupMemberId) async {
    var _dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Remove Group Member',
      description: 'Are you sure you want to remove this group member?',
      confirmationTitle: 'REMOVE',
    );

    if (_dialogResponse.confirmed) {
      _dialogService.showCustomProgressDialog(title: 'Removing');

      await _model.deleteGroupMember(groupMemberId);

      _dialogService.popDialog();

      if (_model.isSuccess(_model.DELETE_GROUP_MEMBER)) {
        SnackBarUtils.showDark('Group Member Removed');
      } else if (_model.isError(_model.DELETE_GROUP_MEMBER)) {
        SnackBarUtils.showDark(
            _model.errorMessageFor(_model.DELETE_GROUP_MEMBER));
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
              title: '+ Add',
              onPressed: onAddPressed,
              padding: const EdgeInsets.symmetric(horizontal: 4),
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
      title: 'Delete Assignment',
      description: 'Are you sure you want to delete this assignment?',
      confirmationTitle: 'DELETE',
    );

    if (_dialogResponse.confirmed) {
      _dialogService.showCustomProgressDialog(title: 'Deleting Assignment');

      await _model.deleteAssignment(assignmentId);

      _dialogService.popDialog();

      if (_model.isSuccess(_model.DELETE_ASSIGNMENT)) {
        SnackBarUtils.showDark('Assignment Deleted');
      } else if (_model.isError(_model.DELETE_ASSIGNMENT)) {
        SnackBarUtils.showDark(
            _model.errorMessageFor(_model.DELETE_ASSIGNMENT));
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
      title: 'Reopen Assignment',
      description: 'Are you sure you want to reopen this assignment?',
      confirmationTitle: 'REOPEN',
    );

    if (_dialogResponse.confirmed) {
      _dialogService.showCustomProgressDialog(title: 'Reopening Assignment');

      await _model.reopenAssignment(assignmentId);

      _dialogService.popDialog();

      if (_model.isSuccess(_model.REOPEN_ASSIGNMENT)) {
        SnackBarUtils.showDark('Assignent Reopened');
      } else if (_model.isError(_model.REOPEN_ASSIGNMENT)) {
        SnackBarUtils.showDark(
            _model.errorMessageFor(_model.REOPEN_ASSIGNMENT));
      }
    }
  }

  Future<void> onStartAssignmentPressed(String assignmentId) async {
    var _dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Start Assignment',
      description: 'Are you sure you want to start working on this assignment?',
      confirmationTitle: 'START',
    );

    if (_dialogResponse.confirmed) {
      _dialogService.showCustomProgressDialog(title: 'Starting Assignment');

      await _model.startAssignment(assignmentId);

      _dialogService.popDialog();

      if (_model.isSuccess(_model.START_ASSIGNMENT)) {
        SnackBarUtils.showDark('Project Created');
      } else {
        SnackBarUtils.showDark(_model.errorMessageFor(_model.START_ASSIGNMENT));
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
        appBar: AppBar(title: Text('Group Details')),
        body: Builder(builder: (context) {
          var _items = <Widget>[];

          _items.add(_buildHeader());

          _items.add(SizedBox(height: 36));

          _items.add(
            _buildSubHeader(
              title: 'Members',
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
              title: 'Assignments',
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
