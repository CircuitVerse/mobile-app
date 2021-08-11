import 'package:flutter/material.dart';
import 'package:mobile_app/locale/language.dart';
import 'package:mobile_app/locale/locale.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguagePickerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        icon: Icon(
                Icons.language,
                color: Colors.white,
              ),
        items: AppLocalizations.supportedLocales.map(
          (locale) {
            final language = L10n.getLanguage(locale.languageCode);
            return DropdownMenuItem(
              value: locale,
              onTap: () {
                final provider =
                    Provider.of<LocaleProvider>(context, listen: false);

                provider.setLocale(locale);
              },
              child: Center(
                child: Text(
                  language,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            );
          },
        ).toList(),
        onChanged: (_) {},
      ),
    );
  }
}
