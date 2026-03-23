import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/services/local_storage_service.dart';
import 'package:mobile_app/ui/views/cv_landing_view.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';

class OnboardingViewModel extends BaseModel {
  final LocalStorageService _localStorageService =
      locator<LocalStorageService>();

  late PageController _pageController;
  PageController get pageController => _pageController;

  int _currentPage = 0;
  int get currentPage => _currentPage;

  void init() {
    _pageController = PageController();
  }

  void onPageChanged(int page) {
    _currentPage = page;
    notifyListeners();
  }

  void nextPage() {
    if (_currentPage < 3) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (_currentPage > 0) {
      _pageController.animateToPage(
        _currentPage - 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void skip() {
    _completeOnboarding();
  }

  void finish() {
    _completeOnboarding();
  }

  void _completeOnboarding() {
    _localStorageService.isFirstTimeLaunch = false;
    Get.offAllNamed(CVLandingView.id);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
