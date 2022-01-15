import 'package:flutter/foundation.dart';
import 'package:mobile_app/enums/view_state.dart';

class BaseModel extends ChangeNotifier {
  final Map<String, ViewState> _viewStates = <String, ViewState>{};
  final Map<String, String> _errorMessages = <String, String>{};

  ViewState stateFor(String key) => _viewStates[key] ?? ViewState.Idle;

  void setStateFor(String key, ViewState viewState) {
    _viewStates[key] = viewState;
    notifyListeners();
  }

  String errorMessageFor(String key) => _errorMessages[key] ?? '';

  void setErrorMessageFor(String key, String error) {
    _errorMessages[key] = error;
    notifyListeners();
  }

  bool isIdle(String key) => _viewStates[key] == ViewState.Idle;

  bool isBusy(String key) => _viewStates[key] == ViewState.Busy;

  bool isError(String key) => _viewStates[key] == ViewState.Error;

  bool isSuccess(String? key) {
    if (key == null) return false;
    return _viewStates[key] == ViewState.Success;
  }
}
