import 'package:flutter/foundation.dart';
import 'package:mobile_app/enums/view_state.dart';

class BaseModel extends ChangeNotifier {
  ViewState _state = ViewState.Idle;

  ViewState get state => _state;

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  String _errorMessage = '';

  String get errorMessage => _errorMessage;

  void setErrorMessage(String errorMessage) {
    _errorMessage = errorMessage;
    notifyListeners();
  }

  bool get isIdle => state == ViewState.Idle;

  bool get isBusy => state == ViewState.Busy;

  bool get isError => state == ViewState.Error;

  bool get isSuccess => state == ViewState.Success;
}
