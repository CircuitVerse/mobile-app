import 'package:flutter/material.dart';
import 'package:mobile_app/cv_theme.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/viewmodels/onboarding/onboarding_viewmodel.dart';

class OnboardingView extends StatelessWidget {
  static const String id = 'onboarding_view';

  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<OnboardingViewModel>(
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        body: Stack(
          children: [
            PageView(
              controller: model.pageController,
              onPageChanged: model.onPageChanged,
              children: [
                _buildPage(
                  context,
                  title: 'Welcome to CircuitVerse',
                  description:
                      'Design, simulate, and share digital logic circuits with ease. Your complete digital circuit design lab in your pocket.',
                  imagePath: 'assets/images/homepage/fullAdder.png',
                  backgroundColor: CVTheme.primaryColorShadow,
                ),
                _buildPage(
                  context,
                  title: 'Interactive Circuit Simulator',
                  description:
                      'Build circuits with logic gates, flip-flops, and more. Watch your designs come to life with real-time simulation.',
                  imagePath: 'assets/images/homepage/combinational-analysis.png',
                  backgroundColor: const Color(0xFFF5F9FF),
                ),
                _buildPage(
                  context,
                  title: 'Learn & Collaborate',
                  description:
                      'Join groups, complete assignments, and collaborate with others. Perfect for students and educators.',
                  imagePath: 'assets/images/teachers/groups_en.png',
                  backgroundColor: const Color(0xFFFFF8F5),
                ),
                _buildPage(
                  context,
                  title: 'Create & Share',
                  description:
                      'Export your circuits, embed them anywhere, and share your projects with the community.',
                  imagePath: 'assets/images/homepage/embed.png',
                  backgroundColor: CVTheme.primaryColorShadow,
                ),
              ],
            ),
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  4,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: model.currentPage == index ? 24 : 8,
                    decoration: BoxDecoration(
                      color: model.currentPage == index
                          ? CVTheme.primaryColor
                          : CVTheme.lightGrey,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: model.currentPage == index
                          ? [
                              BoxShadow(
                                color: CVTheme.primaryColor.withValues(alpha: 0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : [],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (model.currentPage > 0)
                    TextButton(
                      onPressed: model.previousPage,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_back_ios,
                            size: 16,
                            color: CVTheme.primaryColorDark,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Back',
                            style: TextStyle(
                              color: CVTheme.primaryColorDark,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    const SizedBox(width: 80),
                  if (model.currentPage < 3)
                    TextButton(
                      onPressed: model.skip,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: CVTheme.grey,
                          fontSize: 16,
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 80),
                  ElevatedButton(
                    onPressed: model.currentPage == 3
                        ? model.finish
                        : model.nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CVTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 4,
                      shadowColor: CVTheme.primaryColor.withValues(alpha: 0.4),
                    ),
                    child: Row(
                      children: [
                        Text(
                          model.currentPage == 3 ? 'Get Started' : 'Next',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (model.currentPage < 3) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward_ios, size: 16),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(
    BuildContext context, {
    required String title,
    required String description,
    required String imagePath,
    required Color backgroundColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            backgroundColor,
            backgroundColor.withValues(alpha: 0.8),
          ],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          Expanded(
            flex: 3,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: CVTheme.primaryColor.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: CVTheme.primaryHeading(context),
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 16,
                    color: CVTheme.textColor(context).withValues(alpha: 0.7),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 150),
        ],
      ),
    );
  }
}
