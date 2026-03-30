import 'package:flutter/material.dart';
import 'package:mobile_app/ib_theme.dart';
import 'package:mobile_app/models/ib/new_ib_drawer_data.dart';
import 'package:theme_provider/theme_provider.dart';

class NewIbDrawerFooter extends StatelessWidget {
  final NewIbDrawerMetadata? metadata;
  
  const NewIbDrawerFooter({super.key, this.metadata});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor.withAlpha(128),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (metadata != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                metadata!.copyright,
                style: TextStyle(
                  fontSize: 11,
                  color: IbTheme.textColor(context).withAlpha(128),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (metadata != null)
                Text(
                  '${metadata!.totalChapters} chapters',
                  style: TextStyle(
                    fontSize: 12,
                    color: IbTheme.textColor(context).withAlpha(128),
                  ),
                )
              else
                Text(
                  'v1.0.0',
                  style: TextStyle(
                    fontSize: 12,
                    color: IbTheme.textColor(context).withAlpha(128),
                  ),
                ),
              Container(
                decoration: BoxDecoration(
                  color: IbTheme.getPrimaryColor(context).withAlpha(26),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  icon: Icon(
                    Theme.of(context).brightness == Brightness.dark
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_rounded,
                    size: 20,
                  ),
                  onPressed: () {
                    ThemeProvider.controllerOf(context).nextTheme();
                  },
                  tooltip: 'Toggle theme',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
