import 'package:flutter/material.dart';
import 'package:mobile_app/ui/components/cv_subheader.dart';
import 'package:mobile_app/gen_l10n/app_localizations.dart';

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  Widget _buildCardImage(
    BuildContext context,
    String assetPath,
    String cardHeading,
    String cardDescription,
  ) {
    return Card(
      margin: const EdgeInsetsDirectional.symmetric(vertical: 12),
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: Column(
        children: <Widget>[
          Image.asset(assetPath, fit: BoxFit.fitWidth, height: 130),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              cardHeading,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              cardDescription,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CVSubheader(
          title: AppLocalizations.of(context)!.features_title,
          subtitle: AppLocalizations.of(context)!.features_subtitle,
        ),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 0.5,
          children: <Widget>[
            _buildCardImage(
              context,
              'assets/images/homepage/export-hd.png',
              AppLocalizations.of(context)!.feature1_title,
              AppLocalizations.of(context)!.feature1_description,
            ),
            _buildCardImage(
              context,
              'assets/images/homepage/combinational-analysis.png',
              AppLocalizations.of(context)!.feature2_title,
              AppLocalizations.of(context)!.feature2_description,
            ),
            _buildCardImage(
              context,
              'assets/images/homepage/testbench-timing-diagram.png',
              'Testbench & Timing Diagram',
              'Test your circuit using a testbench and validate its behavior with a timing diagram',
            ),
            _buildCardImage(
              context,
              'assets/images/homepage/embed.png',
              AppLocalizations.of(context)!.feature3_title,
              AppLocalizations.of(context)!.feature3_description,
            ),
            _buildCardImage(
              context,
              'assets/images/homepage/sub-circuit.png',
              AppLocalizations.of(context)!.feature4_title,
              AppLocalizations.of(context)!.feature4_description,
            ),
            _buildCardImage(
              context,
              'assets/images/homepage/multi-bit-bus.png',
              AppLocalizations.of(context)!.feature5_title,
              AppLocalizations.of(context)!.feature5_description,
            ),
          ],
        ),
      ],
    );
  }
}
