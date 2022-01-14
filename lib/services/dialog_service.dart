import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/models/dialog_models.dart';

class DialogService {
  late Completer<DialogResponse>? _dialogCompleter;

  Completer<DialogResponse>? get dialogCompleter => _dialogCompleter;

  void _showDialog(DialogRequest request) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        title: Text(
          request.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content:
            request.description != null ? Text(request.description!) : null,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              dialogComplete(DialogResponse(confirmed: true));
            },
            child: Text(
              request.buttonTitle!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(DialogRequest request) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        title: Text(
          request.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content:
            request.description != null ? Text(request.description!) : null,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              dialogComplete(DialogResponse(confirmed: false));
            },
            child: Text(
              request.cancelTitle!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              dialogComplete(DialogResponse(confirmed: true));
            },
            child: Text(
              request.buttonTitle!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showProgressDialog(DialogRequest request) {
    Get.dialog(
      SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const CircularProgressIndicator(),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    request.title,
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Calls the dialog listener and returns a Future that will wait for dialogComplete.
  Future<DialogResponse> showDialog({
    String? title,
    String? description,
    String buttonTitle = 'OK',
  }) {
    _dialogCompleter = Completer<DialogResponse>();
    title ??= 'Title';
    _showDialog(
      DialogRequest(
        title: title,
        description: description,
        buttonTitle: buttonTitle,
      ),
    );
    return _dialogCompleter!.future;
  }

  /// Shows a confirmation dialog
  Future<DialogResponse>? showConfirmationDialog({
    String? title,
    String? description,
    String confirmationTitle = 'OK',
    String cancelTitle = 'CANCEL',
  }) {
    _dialogCompleter = Completer<DialogResponse>();
    title ??= 'Title';
    _showConfirmationDialog(
      DialogRequest(
        title: title,
        description: description,
        buttonTitle: confirmationTitle,
        cancelTitle: cancelTitle,
      ),
    );
    return _dialogCompleter!.future;
  }

  void showCustomProgressDialog({String? title}) {
    title ??= 'Title';
    _showProgressDialog(
      DialogRequest(title: title),
    );
  }

  /// Completes the _dialogCompleter to resume the Future's execution call
  void dialogComplete(DialogResponse response) {
    Get.key.currentState?.pop();
    _dialogCompleter!.complete(response);
    _dialogCompleter = null;
  }

  void popDialog() {
    if (Get.key.currentState!.canPop()) {
      Get.key.currentState!.pop();
    }
  }
}
