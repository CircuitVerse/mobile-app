import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:mobile_app/cv_theme.dart';
import 'package:mobile_app/config/environment_config.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/collaborators.dart';
import 'package:mobile_app/models/projects.dart';
import 'package:mobile_app/services/dialog_service.dart';
import 'package:mobile_app/ui/components/cv_flat_button.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/ui/views/profile/profile_view.dart';
import 'package:mobile_app/ui/views/projects/edit_project_view.dart';
import 'package:mobile_app/ui/views/projects/project_preview_fullscreen_view.dart';
import 'package:mobile_app/utils/snackbar_utils.dart';
import 'package:mobile_app/utils/validators.dart';
import 'package:mobile_app/viewmodels/projects/project_details_viewmodel.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class ProjectDetailsView extends StatefulWidget {
  const ProjectDetailsView({Key? key, required this.project}) : super(key: key);

  static const String id = 'project_details_view';
  final Project project;

  @override
  _ProjectDetailsViewState createState() => _ProjectDetailsViewState();
}

class _ProjectDetailsViewState extends State<ProjectDetailsView> {
  final DialogService _dialogService = locator<DialogService>();
  late ProjectDetailsViewModel _model;
  final _formKey = GlobalKey<FormState>();
  late String _emails;
  late Project _recievedProject;
  final GlobalKey<CVFlatButtonState> addButtonGlobalKey =
      GlobalKey<CVFlatButtonState>();

  @override
  void initState() {
    super.initState();
    _recievedProject = widget.project;
  }

  void onShareButtonPressed() {
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    var URL =
        'https://circuitverse.org/users/${widget.project.relationships.author.data.id}/projects/${widget.project.id}';
    Share.share(URL,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }

  Widget _buildShareActionButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: IconButton(
        onPressed: onShareButtonPressed,
        icon: const Icon(Icons.share),
        tooltip: 'Share',
      ),
    );
  }

  Widget _buildProjectPreview() {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        border: Border.all(color: CVTheme.grey),
        color: Colors.white,
      ),
      child: ClipRRect(
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            PhotoView.customChild(
              backgroundDecoration: const BoxDecoration(
                color: Colors.white,
              ),
              initialScale: 1.0,
              child: FadeInImage.memoryNetwork(
                height: 100,
                width: 50,
                placeholder: kTransparentImage,
                image: EnvironmentConfig.CV_API_BASE_URL.substring(
                        0, EnvironmentConfig.CV_API_BASE_URL.length - 7) +
                    _recievedProject.attributes.imagePreview.url,
              ),
            ),
            Material(
              color: CVTheme.primaryColor,
              child: IconButton(
                onPressed: () {
                  Get.toNamed(
                    ProjectPreviewFullScreen.id,
                    arguments: _recievedProject,
                  );
                },
                icon: const Icon(
                  Icons.fullscreen,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarsComponent() {
    return Row(
      children: <Widget>[
        const Icon(Icons.star, color: Colors.yellow, size: 18),
        Text(' ${_model.starCount} Stars'),
      ],
    );
  }

  Widget _buildViewsComponent() {
    return Row(
      children: <Widget>[
        const Icon(Icons.visibility, size: 18),
        Text(' ${_recievedProject.attributes.view} Views'),
      ],
    );
  }

  Widget _buildProjectHeader(String title) {
    return Container(
      padding: const EdgeInsets.all(4),
      color: CVTheme.primaryColor,
      width: double.infinity,
      child: Text(
        title,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
            ),
      ),
    );
  }

  Widget _buildProjectNameHeader() {
    return Column(
      children: <Widget>[
        _buildProjectHeader(_recievedProject.attributes.name),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            _buildStarsComponent(),
            const SizedBox(width: 8),
            _buildViewsComponent(),
          ],
        ),
      ],
    );
  }

  Widget _buildProjectDetailComponent(String heading, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
          children: <TextSpan>[
            TextSpan(
              text: '$heading : ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: description,
              style: const TextStyle(fontSize: 18),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProjectAuthor() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
          children: <TextSpan>[
            const TextSpan(
              text: 'Author : ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () => Get.toNamed(ProfileView.id,
                    arguments: _recievedProject.relationships.author.data.id),
              text: _recievedProject.attributes.authorName,
              style: const TextStyle(
                fontSize: 18,
                decoration: TextDecoration.underline,
                color: CVTheme.primaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProjectDescription() {
    return (_recievedProject.attributes.description ?? '') != ''
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Description :',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                ),
                Html(
                  data: _recievedProject.attributes.description ?? '',
                  style: {'body': Style(fontSize: FontSize(18))},
                )
              ],
            ),
          )
        : Container();
  }

  Future<void> onForkProjectPressed() async {
    var _dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Fork Project',
      description: 'Are you sure you want to fork this project?',
      confirmationTitle: 'FORK',
    );

    if (_dialogResponse?.confirmed ?? false) {
      _dialogService.showCustomProgressDialog(title: 'Forking');

      await _model.forkProject(_recievedProject.id);

      _dialogService.popDialog();

      if (_model.isSuccess(_model.FORK_PROJECT)) {
        await Get.toNamed(ProjectDetailsView.id,
            arguments: _model.forkedProject);
      } else if (_model.isError(_model.FORK_PROJECT)) {
        SnackBarUtils.showDark(
          'Error',
          _model.errorMessageFor(_model.FORK_PROJECT),
        );
      }
    }
  }

  Widget _buildForkProjectButton() {
    return InkWell(
      onTap: onForkProjectPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        decoration: BoxDecoration(
          color: CVTheme.primaryColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset('assets/icons/fork_project.png', width: 12),
            const SizedBox(width: 4),
            Text(
              'Fork',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onStarProjectPressed() async {
    await _model.toggleStarForProject(_recievedProject.id);

    if (_model.isSuccess(_model.TOGGLE_STAR)) {
      SnackBarUtils.showDark(
        'Project ${_model.isProjectStarred ? 'Starred' : 'Unstarred'}',
        'You have successfully ${_model.isProjectStarred ? 'stared' : 'unstarred'} the project',
      );
    } else if (_model.isError(_model.TOGGLE_STAR)) {
      SnackBarUtils.showDark(
        'Error',
        _model.errorMessageFor(_model.TOGGLE_STAR),
      );
    }
  }

  Widget _buildStarProjectButton() {
    return InkWell(
      onTap: onStarProjectPressed,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: CVTheme.primaryColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          _model.isProjectStarred ? Icons.star : Icons.star_border,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> onAddCollaboratorsPressed(BuildContext context) async {
    if (Validators.validateAndSaveForm(_formKey)) {
      FocusScope.of(context).requestFocus(FocusNode());
      Navigator.pop(context);

      _dialogService.showCustomProgressDialog(title: 'Adding');

      await _model.addCollaborators(_recievedProject.id, _emails);

      _dialogService.popDialog();

      if (_model.isSuccess(_model.ADD_COLLABORATORS) &&
          _model.addedCollaboratorsSuccessMessage.isNotEmpty) {
        SnackBarUtils.showDark(
          'Collaborators Added',
          _model.addedCollaboratorsSuccessMessage,
        );
      } else if (_model.isError(_model.ADD_COLLABORATORS)) {
        SnackBarUtils.showDark(
          'Error',
          _model.errorMessageFor(_model.ADD_COLLABORATORS),
        );
      }
    }
  }

  void showAddCollaboratorsDialog() {
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
                const Text(
                  'Add Collaborators',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Enter Email IDs separated by commas. Users need to be registered already on the platform. Note that collaboration is not real time as of now. Every save overwrites the previous data.',
                  style: Theme.of(context).textTheme.bodyLarge,
                )
              ],
            ),
            content: Form(
              key: _formKey,
              child: TextFormField(
                maxLines: 5,
                onChanged: (emailValue) {
                  addButtonGlobalKey.currentState
                      ?.setDynamicFunction(emailValue.isNotEmpty);
                },
                autofocus: true,
                decoration: CVTheme.textFieldDecoration.copyWith(
                  hintText: 'Email Ids',
                ),
                validator: (emails) => Validators.areEmailsValid(emails)
                    ? null
                    : 'Enter emails in valid format.',
                onSaved: (emails) =>
                    _emails = emails!.replaceAll(' ', '').trim(),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('CANCEL'),
              ),
              CVFlatButton(
                key: addButtonGlobalKey,
                triggerFunction: onAddCollaboratorsPressed,
                context: context,
                buttonText: 'ADD',
              ),
            ],
          );
        });
  }

  Widget _buildAddCollaboratorsButton() {
    return GestureDetector(
      onTap: showAddCollaboratorsDialog,
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.add),
          Text('Add A Collaborator'),
        ],
      ),
    );
  }

  Future<void> onEditProjectPressed() async {
    var _updatedProject =
        await Get.toNamed(EditProjectView.id, arguments: _recievedProject);
    if (_updatedProject is Project) {
      setState(() {
        _recievedProject = _updatedProject;
      });
    }
  }

  Widget _buildEditButton() {
    return InkWell(
      onTap: onEditProjectPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: CVTheme.primaryColorDark),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.edit, size: 16),
            const SizedBox(width: 4),
            Text('Edit', style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }

  Future<void> onDeleteProjectPressed() async {
    var _dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Delete Project',
      description: 'Are you sure you want to delete this project?',
      confirmationTitle: 'DELETE',
    );

    if (_dialogResponse?.confirmed ?? false) {
      _dialogService.showCustomProgressDialog(title: 'Deleting Project');

      await _model.deleteProject(_recievedProject.id);

      _dialogService.popDialog();

      if (_model.isSuccess(_model.DELETE_PROJECT)) {
        Get.back(result: true);
        SnackBarUtils.showDark(
          'Project Deleted',
          'Project is successfully deleted.',
        );
      } else if (_model.isError(_model.DELETE_PROJECT)) {
        SnackBarUtils.showDark(
          'Error',
          _model.errorMessageFor(_model.DELETE_PROJECT),
        );
      }
    }
  }

  Widget _buildDeleteButton() {
    return InkWell(
      onTap: onDeleteProjectPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: CVTheme.primaryColorDark),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.delete, size: 16),
            const SizedBox(width: 4),
            Text('Delete', style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }

  Future<void> onDeleteCollaboratorPressed(Collaborator collaborator) async {
    var _dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Delete Collaborator',
      description: 'Are you sure you want to delete this collaborator?',
      confirmationTitle: 'DELETE',
    );

    if (_dialogResponse?.confirmed ?? false) {
      _dialogService.showCustomProgressDialog(title: 'Deleting..');

      await _model.deleteCollaborator(_model.project!.id, collaborator.id);

      _dialogService.popDialog();

      if (_model.isSuccess(_model.DELETE_COLLABORATORS)) {
        SnackBarUtils.showDark(
          'Collaborator Deleted',
          'Collaborator was successfully deleted.',
        );
      } else if (_model.isError(_model.DELETE_COLLABORATORS)) {
        SnackBarUtils.showDark(
          'Error',
          _model.errorMessageFor(_model.DELETE_COLLABORATORS),
        );
      }
    }
  }

  Widget _buildCollaborator(Collaborator collaborator) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () =>
                  Get.toNamed(ProfileView.id, arguments: collaborator.id),
              child: Text(
                collaborator.attributes.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      decoration: TextDecoration.underline,
                      color: CVTheme.highlightText(context),
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
          if (_model.project!.hasAuthorAccess)
            IconButton(
              padding: const EdgeInsets.all(0),
              icon: const Icon(Icons.delete_outline),
              color: CVTheme.red,
              onPressed: () => onDeleteCollaboratorPressed(collaborator),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<ProjectDetailsViewModel>(
      onModelReady: (model) {
        _model = model;
        _model.receivedProject = _recievedProject;
        // initialize collaborators & isStarred for the project..
        _model.collaborators = _recievedProject.collaborators;
        _model.isProjectStarred = _recievedProject.attributes.isStarred;
        _model.starCount = _recievedProject.attributes.starsCount;

        _model.fetchProjectDetails(_recievedProject.id);
      },
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async {
          // Check whether the state (i.e starred or not) is changed
          final bool isChanged = model.receivedProject!.attributes.isStarred ^
              _recievedProject.attributes.isStarred;
          Get.back(
            result: isChanged ? model.receivedProject : null,
          );
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Project Details'),
            actions: [
              _buildShareActionButton(),
            ],
          ),
          body: Builder(
            builder: (context) {
              var _projectAttrs = _recievedProject.attributes;
              var _items = <Widget>[];

              // Adds project preview..
              _items.add(_buildProjectPreview());

              _items.add(const SizedBox(height: 16));

              // Adds Project Name, Star & View count..
              _items.add(_buildProjectNameHeader());

              // Adds Project attributes..
              _items.add(
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildProjectAuthor(),
                      _buildProjectDetailComponent(
                        'Project Access Type',
                        _projectAttrs.projectAccessType,
                      ),
                      _buildProjectDescription(),
                      const Divider(height: 32),
                      Wrap(
                        spacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                          if (!_recievedProject.hasAuthorAccess &&
                              model.isLoggedIn)
                            _buildForkProjectButton(),
                          if (model.isLoggedIn) _buildStarProjectButton(),
                          if (_recievedProject.hasAuthorAccess)
                            _buildAddCollaboratorsButton(),
                        ],
                      ),
                      const Divider(height: 32),
                      if (_recievedProject.hasAuthorAccess)
                        Wrap(
                          spacing: 8,
                          children: <Widget>[
                            _buildEditButton(),
                            _buildDeleteButton(),
                          ],
                        ),
                    ],
                  ),
                ),
              );

              if (_model.isSuccess(_model.FETCH_PROJECT_DETAILS) &&
                  _model.collaborators.isNotEmpty) {
                _items.add(const Divider());

                _items.add(_buildProjectHeader('Collaborators'));

                for (var collaborator in _model.collaborators) {
                  _items.add(
                    _buildCollaborator(collaborator),
                  );
                }
              }
              return ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(16),
                children: _items,
              );
            },
          ),
        ),
      ),
    );
  }
}
