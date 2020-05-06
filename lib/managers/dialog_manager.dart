import 'package:flutter/material.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/dialog_models.dart';
import 'package:mobile_app/services/dialog_service.dart';

class DialogManager extends StatefulWidget {
  final Widget child;
  DialogManager({Key key, this.child}) : super(key: key);

  _DialogManagerState createState() => _DialogManagerState();
}

class _DialogManagerState extends State<DialogManager> {
  DialogService _dialogService = locator<DialogService>();

  @override
  void initState() {
    super.initState();
    _dialogService.registerDialogListener(_showDialog);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _showDialog(DialogRequest request) {
    bool isConfirmationDialog = request.cancelTitle != null;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => request.description == null
          ? SimpleDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      Text(request.title, style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              ],
            )
          : AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              title: Text(
                request.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(request.description),
              actions: <Widget>[
                if (isConfirmationDialog)
                  FlatButton(
                    child: Text(
                      request.cancelTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      _dialogService.dialogComplete(
                        DialogResponse(confirmed: false),
                      );
                    },
                  ),
                FlatButton(
                  child: Text(
                    request.buttonTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    _dialogService.dialogComplete(
                      DialogResponse(confirmed: true),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
