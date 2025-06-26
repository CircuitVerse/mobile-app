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
import 'package:simple_chips_input/simple_chips_input.dart';
import 'package:mobile_app/gen_l10n/app_localizations.dart';

class GroupDetailsView extends StatefulWidget {
  const GroupDetailsView({super.key, required this.group});

  static const String id = 'group_details_view';
  final Group group;

  @override
  _GroupDetailsViewState createState() => _GroupDetailsViewState();
}

class _GroupDetailsViewState extends State<GroupDetailsView> {
  final DialogService _dialogService = locator<DialogService>();
  late GroupDetailsViewModel _model;
  final _formKey = GlobalKey<FormState>();
  String? _emails;
  late Group _recievedGroup;
  final GlobalKey<CVFlatButtonState> addButtonGlobalKey =
      GlobalKey<CVFlatButtonState>();
  // textformfield style for the email address textfield chips
  final TextFormFieldStyle _textFormFieldStyle = const TextFormFieldStyle(
    maxLines: 5,
    keyboardType: TextInputType.emailAddress,
    cursorColor: CVTheme.primaryColor,
    decoration: InputDecoration(
      hintText: 'Email IDs',
      hintStyle: TextStyle(color: CVTheme.primaryColor),
      border: InputBorder.none,
    ),
  );

  @override
  void initState() {
    super.initState();
    _recievedGroup = widget.group;
  }

  Widget _buildEditGroupButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
        backgroundColor: CVTheme.primaryColor,
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
          const Icon(Icons.edit, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            AppLocalizations.of(context)!.group_details_edit,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Colors.white),
          ),
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
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: CVTheme.textColor(context),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (_recievedGroup.isPrimaryMentor) ...[
              const SizedBox(width: 12),
              _buildEditGroupButton(),
            ],
          ],
        ),
        RichText(
          text: TextSpan(
            text:
                '${AppLocalizations.of(context)!.group_details_primary_mentor} : ',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            children: <TextSpan>[
              TextSpan(
                text: _recievedGroup.attributes.primaryMentorName,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> onAddMemberPressed(BuildContext context, bool isMentor) async {
    _formKey.currentState!.save();
    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.pop(context);

    _dialogService.showCustomProgressDialog(
      title: AppLocalizations.of(context)!.group_details_adding,
    );

    await _model.addMembers(_recievedGroup.id, _emails!, isMentor);

    _dialogService.popDialog();

    if (_model.isSuccess(_model.ADD_GROUP_MEMBERS) &&
        _model.addedMembersSuccessMessage.isNotEmpty) {
      SnackBarUtils.showDark(
        AppLocalizations.of(context)!.group_details_members_added,
        _model.addedMembersSuccessMessage,
      );
    } else if (_model.isError(_model.ADD_GROUP_MEMBERS)) {
      SnackBarUtils.showDark(
        AppLocalizations.of(context)!.group_details_error,
        _model.errorMessageFor(_model.ADD_GROUP_MEMBERS),
      );
    }
    setState(() => _emails = null);
  }

  void showAddMemberDialog({bool member = true}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                member
                    ? AppLocalizations.of(context)!.group_details_add_members
                    : AppLocalizations.of(context)!.group_details_add_mentors,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                AppLocalizations.of(
                  context,
                )!.group_details_add_members_description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          content: SimpleChipsInput(
            formKey: _formKey,
            widgetContainerDecoration: BoxDecoration(
              border: Border.all(color: CVTheme.primaryColor, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            chipContainerDecoration: BoxDecoration(
              color: CVTheme.primaryColor,
              borderRadius: BorderRadius.circular(50),
            ),
            textFormFieldStyle: _textFormFieldStyle,
            separatorCharacter: ',',
            createCharacter: ',',
            autoFocus: true,
            validateInput: true,
            validateInputMethod:
                (emails) =>
                    Validators.areEmailsValid(emails)
                        ? null
                        : AppLocalizations.of(
                          context,
                        )!.group_details_email_validation_error,
            onChanged: (emails) {
              addButtonGlobalKey.currentState?.setDynamicFunction(
                emails.isNotEmpty,
              );
            },
            onSaved: (emails) => _emails = emails.replaceAll(' ', '').trim(),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                AppLocalizations.of(
                  context,
                )!.group_details_cancel.toUpperCase(),
              ),
            ),
            CVFlatButton(
              key: addButtonGlobalKey,
              triggerFunction:
                  (context) => onAddMemberPressed(context, !member),
              context: context,
              buttonText:
                  AppLocalizations.of(context)!.group_details_add.toUpperCase(),
            ),
          ],
        );
      },
    );
  }

  Future<void> onDeleteGroupMemberPressed(String memberId, bool member) async {
    var _dialogResponse = await _dialogService.showConfirmationDialog(
      title:
          member
              ? AppLocalizations.of(context)!.group_details_remove_member
              : AppLocalizations.of(context)!.group_details_remove_mentor,
      description:
          member
              ? AppLocalizations.of(
                context,
              )!.group_details_remove_member_confirmation
              : AppLocalizations.of(
                context,
              )!.group_details_remove_mentor_confirmation,
      confirmationTitle:
          AppLocalizations.of(context)!.group_details_remove.toUpperCase(),
    );

    if (_dialogResponse?.confirmed ?? false) {
      _dialogService.showCustomProgressDialog(
        title: AppLocalizations.of(context)!.group_details_removing,
      );

      await _model.deleteGroupMember(memberId, member);

      _dialogService.popDialog();

      if (_model.isSuccess(_model.DELETE_GROUP_MEMBER)) {
        SnackBarUtils.showDark(
          member
              ? AppLocalizations.of(context)!.group_details_member_removed
              : AppLocalizations.of(context)!.group_details_mentor_removed,
          AppLocalizations.of(context)!.group_details_member_removed_success,
        );
      } else if (_model.isError(_model.DELETE_GROUP_MEMBER)) {
        SnackBarUtils.showDark(
          AppLocalizations.of(context)!.group_details_error,
          _model.errorMessageFor(_model.DELETE_GROUP_MEMBER),
        );
      }
    }
  }

  Widget _buildSubHeader({
    required String titleKey,
    VoidCallback? onAddPressed,
    bool extraCondition = false,
  }) {
    final title =
        {
          'mentors': AppLocalizations.of(context)!.group_details_mentors,
          'members': AppLocalizations.of(context)!.group_details_members,
          'assignments':
              AppLocalizations.of(context)!.group_details_assignments,
        }[titleKey] ??
        titleKey;

    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          if (_recievedGroup.isPrimaryMentor || extraCondition)
            CVPrimaryButton(
              title: '${AppLocalizations.of(context)!.group_details_add} +',
              onPressed: onAddPressed,
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
            ),
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
      title: AppLocalizations.of(context)!.group_details_delete_assignment,
      description:
          AppLocalizations.of(
            context,
          )!.group_details_delete_assignment_confirmation,
      confirmationTitle:
          AppLocalizations.of(context)!.group_details_delete.toUpperCase(),
    );

    if (_dialogResponse?.confirmed ?? false) {
      _dialogService.showCustomProgressDialog(
        title: AppLocalizations.of(context)!.group_details_deleting_assignment,
      );

      await _model.deleteAssignment(assignmentId);

      _dialogService.popDialog();

      if (_model.isSuccess(_model.DELETE_ASSIGNMENT)) {
        SnackBarUtils.showDark(
          AppLocalizations.of(context)!.group_details_assignment_deleted,
          AppLocalizations.of(
            context,
          )!.group_details_assignment_deleted_success,
        );
      } else if (_model.isError(_model.DELETE_ASSIGNMENT)) {
        SnackBarUtils.showDark(
          AppLocalizations.of(context)!.group_details_error,
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
      title: AppLocalizations.of(context)!.group_details_reopen_assignment,
      description:
          AppLocalizations.of(
            context,
          )!.group_details_reopen_assignment_confirmation,
      confirmationTitle:
          AppLocalizations.of(context)!.group_details_reopen.toUpperCase(),
    );

    if (_dialogResponse?.confirmed ?? false) {
      _dialogService.showCustomProgressDialog(
        title: AppLocalizations.of(context)!.group_details_reopening_assignment,
      );

      await _model.reopenAssignment(assignmentId);

      _dialogService.popDialog();

      if (_model.isSuccess(_model.REOPEN_ASSIGNMENT)) {
        SnackBarUtils.showDark(
          AppLocalizations.of(context)!.group_details_assignment_reopened,
          AppLocalizations.of(
            context,
          )!.group_details_assignment_reopened_success,
        );
      } else if (_model.isError(_model.REOPEN_ASSIGNMENT)) {
        SnackBarUtils.showDark(
          AppLocalizations.of(context)!.group_details_error,
          _model.errorMessageFor(_model.REOPEN_ASSIGNMENT),
        );
      }
    }
  }

  Future<void> onStartAssignmentPressed(String assignmentId) async {
    var _dialogResponse = await _dialogService.showConfirmationDialog(
      title: AppLocalizations.of(context)!.group_details_start_assignment,
      description:
          AppLocalizations.of(
            context,
          )!.group_details_start_assignment_confirmation,
      confirmationTitle:
          AppLocalizations.of(context)!.group_details_start.toUpperCase(),
    );

    if (_dialogResponse?.confirmed ?? false) {
      _dialogService.showCustomProgressDialog(
        title: AppLocalizations.of(context)!.group_details_starting_assignment,
      );

      await _model.startAssignment(assignmentId);

      _dialogService.popDialog();

      if (_model.isSuccess(_model.START_ASSIGNMENT)) {
        SnackBarUtils.showDark(
          AppLocalizations.of(context)!.group_details_project_created,
          AppLocalizations.of(context)!.group_details_project_created_success,
        );
      } else {
        SnackBarUtils.showDark(
          AppLocalizations.of(context)!.group_details_error,
          _model.errorMessageFor(_model.START_ASSIGNMENT),
        );
      }
    }
  }

  String role(bool isMember) {
    return isMember
        ? AppLocalizations.of(context)!.group_details_member
        : AppLocalizations.of(context)!.group_details_mentor;
  }

  Future<void> onEditGroupRole(String id, {bool member = true}) async {
    var _dialogResponse = await _dialogService.showConfirmationDialog(
      title:
          '${AppLocalizations.of(context)!.group_details_make} ${role(!member)}',
      description:
          '${AppLocalizations.of(context)!.group_details_are_you_sure_you_want_to} '
          '${member ? AppLocalizations.of(context)!.group_details_promote : AppLocalizations.of(context)!.group_details_demote} '
          '${AppLocalizations.of(context)!.group_details_this_group} ${role(member)} '
          '${AppLocalizations.of(context)!.group_details_to_a} ${role(!member)}?',
      confirmationTitle:
          AppLocalizations.of(context)!.group_details_yes.toUpperCase(),
    );

    if (_dialogResponse?.confirmed ?? false) {
      _dialogService.showCustomProgressDialog(
        title:
            member
                ? AppLocalizations.of(context)!.group_details_promoting
                : AppLocalizations.of(context)!.group_details_demoting,
      );

      await _model.updateMemberRole(id, member, _recievedGroup.id);

      _dialogService.popDialog();

      if (_model.isSuccess(_model.UPDATE_MEMBER_ROLE)) {
        SnackBarUtils.showDark(
          member
              ? AppLocalizations.of(context)!.group_details_promoted
              : AppLocalizations.of(context)!.group_details_demoted,
          AppLocalizations.of(context)!.group_details_member_updated_success,
        );
      } else if (_model.isError(_model.UPDATE_MEMBER_ROLE)) {
        SnackBarUtils.showDark(
          AppLocalizations.of(context)!.group_details_error,
          _model.errorMessageFor(_model.UPDATE_MEMBER_ROLE),
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
      builder:
          (context, model, child) => Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.group_details_title),
            ),
            body: Builder(
              builder: (context) {
                var _items = <Widget>[];

                _items.add(_buildHeader());
                _items.add(const SizedBox(height: 36));

                _items.add(
                  _buildSubHeader(
                    titleKey: 'mentors',
                    onAddPressed: () => showAddMemberDialog(member: false),
                  ),
                );

                if (_model.isSuccess(_model.FETCH_GROUP_DETAILS)) {
                  for (var mentor in _model.mentors) {
                    _items.add(
                      MemberCard(
                        member: mentor,
                        hasMentorAccess: _model.group.isPrimaryMentor,
                        onEditPressed:
                            () => onEditGroupRole(mentor.id, member: false),
                        onDeletePressed:
                            () => onDeleteGroupMemberPressed(mentor.id, false),
                      ),
                    );
                  }
                }

                _items.add(const SizedBox(height: 36));

                _items.add(
                  _buildSubHeader(
                    titleKey: 'members',
                    onAddPressed: showAddMemberDialog,
                  ),
                );

                if (_model.isSuccess(_model.FETCH_GROUP_DETAILS)) {
                  for (var member in _model.members) {
                    _items.add(
                      MemberCard(
                        member: member,
                        hasMentorAccess: _model.group.isPrimaryMentor,
                        onEditPressed: () => onEditGroupRole(member.id),
                        onDeletePressed:
                            () => onDeleteGroupMemberPressed(member.id, true),
                      ),
                    );
                  }
                }

                _items.add(const SizedBox(height: 36));

                _items.add(
                  _buildSubHeader(
                    titleKey: 'assignments',
                    onAddPressed: onAddAssignmentPressed,
                    extraCondition: _model.isMentor,
                  ),
                );

                if (_model.isSuccess(_model.FETCH_GROUP_DETAILS)) {
                  for (var assignment in _model.assignments) {
                    _items.add(
                      AssignmentCard(
                        assignment: assignment,
                        onDeletePressed:
                            () => onDeleteAssignmentPressed(assignment.id),
                        onEditPressed:
                            () => onEditAssignmentPressed(assignment),
                        onReopenPressed:
                            () => onReopenAssignmentPressed(assignment.id),
                        onStartPressed:
                            () => onStartAssignmentPressed(assignment.id),
                      ),
                    );
                  }
                }

                return ListView(
                  padding: const EdgeInsetsDirectional.all(8),
                  children: _items,
                );
              },
            ),
          ),
    );
  }
}
