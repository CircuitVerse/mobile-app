import 'package:flutter/material.dart';
import 'package:mobile_app/ui/components/cv_outline_button.dart';
import 'package:mobile_app/ui/components/cv_subheader.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/ui/views/home/components/features.dart';
import 'package:mobile_app/ui/views/home/components/growing_community.dart';
import 'package:mobile_app/ui/views/projects/featured_projects_view.dart';
import 'package:mobile_app/viewmodels/cv_landing_viewmodel.dart';
import 'package:mobile_app/viewmodels/home/home_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/gen_l10n/app_localizations.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  static const String id = 'home_view';

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    Widget _buildHeader() {
      return Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 16,
          vertical: 32,
        ),
        child: Column(
          children: <Widget>[
            Text(
              AppLocalizations.of(context)!.home_header_title,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: -1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.home_header_subtitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    Widget _buildHomePageSketch() {
      return Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
        child: Image.asset(
          'assets/images/homepage/new-homepage-sketch.png',
          gaplessPlayback: true,
          fit: BoxFit.contain,
        ),
      );
    }

    Widget _buildTutorialsAndContestsButtons() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton.icon(
            onPressed: () {},
            label: Text('Tutorials', style: TextStyle(color: Colors.white)),
            icon: Icon(Icons.library_books, color: Colors.white, size: 26),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                const Color.fromARGB(255, 17, 159, 102),
              ),
              minimumSize: WidgetStateProperty.all(Size(150, 40)),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          SizedBox(width: 16),
          TextButton.icon(
            onPressed: () {},

            label: Text('Contests', style: TextStyle(color: Colors.white)),
            icon: Icon(Icons.emoji_events, color: Colors.white, size: 28),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                const Color.fromARGB(255, 17, 159, 102),
              ),
              minimumSize: WidgetStateProperty.all(Size(150, 40)),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      );
    }

    return BaseView<HomeViewModel>(
      builder:
          (context, model, child) => SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsetsDirectional.all(16),
              child: Column(
                children: <Widget>[
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildHomePageSketch(),
                  const SizedBox(height: 16),
                  _buildTutorialsAndContestsButtons(),
                  const SizedBox(height: 16),
                  GrowingCommunityCard(),
                  const SizedBox(height: 16),
                  FeaturesSection(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
    );
  }
}
