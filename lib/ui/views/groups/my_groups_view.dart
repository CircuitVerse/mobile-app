import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/cv_theme.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/groups.dart';
import 'package:mobile_app/services/dialog_service.dart';
import 'package:mobile_app/ui/components/cv_add_icon_button.dart';
import 'package:mobile_app/ui/components/cv_primary_button.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/ui/views/groups/components/group_member_card.dart';
import 'package:mobile_app/ui/views/groups/components/group_mentor_card.dart';
import 'package:mobile_app/ui/views/groups/edit_group_view.dart';
import 'package:mobile_app/ui/views/groups/new_group_view.dart';
import 'package:mobile_app/utils/snackbar_utils.dart';
import 'package:mobile_app/viewmodels/groups/my_groups_viewmodel.dart';

class MyGroupsView extends StatefulWidget {
  static const String id = 'my_groups_view';

  @override
  _MyGroupsViewState createState() => _MyGroupsViewState();
}

class _MyGroupsViewState extends State<MyGroupsView> {
  final DialogService _dialogService = locator<DialogService>();
  MyGroupsViewModel _model;

  Widget _buildSubHeader({String title}) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headline5,
    );
  }

  Future<void> onCreateGroupPressed() async {
    var _result = await Get.toNamed(NewGroupView.id);

    if (_result is Group) _model.onGroupCreated(_result);
  }

  Future<void> onEditGroupPressed(Group group) async {
    var _result = await Get.toNamed(
      EditGroupView.id,
      arguments: group,
    );

    if (_result is Group) _model.onGroupUpdated(_result);
  }

  Future<void> onDeleteGroupPressed(String groupId) async {
    var _dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Delete Group',
      description: 'Are you sure you want to delete this group?',
      confirmationTitle: 'DELETE',
    );

    if (_dialogResponse.confirmed) {
      _dialogService.showCustomProgressDialog(title: 'Deleting Group');

      await _model.deleteGroup(groupId);

      _dialogService.popDialog();

      if (_model.isSuccess(_model.DELETE_GROUP)) {
        SnackBarUtils.showDark(
          'Group Deleted',
          'Group was successfully deleted.',
        );
      } else if (_model.isError(_model.DELETE_GROUP)) {
        SnackBarUtils.showDark(
          'Error',
          _model.errorMessageFor(_model.DELETE_GROUP),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<MyGroupsViewModel>(
      onModelReady: (model) {
        _model = model;
        _model.fetchMentoredGroups();
        _model.fetchMemberGroups();
      },
      builder: (context, model, child) => Scaffold(
        body: Builder(builder: (context) {
          var _items = <Widget>[];

          _items.add(
            Text(
              'Groups',
              style: Theme.of(context).textTheme.headline4.copyWith(
                    fontWeight: FontWeight.bold,
                    color: CVTheme.textColor(context),
                  ),
              textAlign: TextAlign.center,
            ),
          );

          _items.add(
            Center(
              child: CVPrimaryButton(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                title: '+ Make New Group',
                onPressed: onCreateGroupPressed,
              ),
            ),
          );

          _items.add(SizedBox(height: 24));

          _items.add(_buildSubHeader(title: 'Groups You Mentor'));

          if (_model.isSuccess(_model.FETCH_MENTORED_GROUPS)) {
            // creates GroupMentorCard corresponding to each mentor group
            _model.mentoredGroups.forEach((group) {
              _items.add(
                GroupMentorCard(
                  group: group,
                  onEdit: () => onEditGroupPressed(group),
                  onDelete: () => onDeleteGroupPressed(group.id),
                ),
              );
            });

            // Adds fetch more groups icon if link to next set exists
            if (_model?.previousMentoredGroupsBatch?.links?.next != null) {
              _items.add(
                CVAddIconButton(onPressed: _model.fetchMentoredGroups),
              );
            }
          }

          _items.add(SizedBox(height: 24));

          _items.add(_buildSubHeader(title: "Groups You're in"));

          if (_model.isSuccess(_model.FETCH_MEMBER_GROUPS)) {
            // creates GroupMemberCard corresponding to each member group
            _model.memberGroups.forEach((group) {
              _items.add(GroupMemberCard(group: group));
            });

            // Adds fetch more groups icon if link to next set exists
            if (_model?.previousMemberGroupsBatch?.links?.next != null) {
              _items.add(
                CVAddIconButton(onPressed: _model.fetchMemberGroups),
              );
            }
          }

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            children: _items,
          );
        }),
      ),
    );
  }
}
