import 'package:flutter/material.dart';
import 'package:mobile_app/cv_theme.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mobile_app/services/API/country_institute_api.dart';

class CVTypeAheadField extends StatelessWidget {
  /// Creates a [TextField] that is specifically styled for CircuitVerse.
  ///
  /// When a [TextInputType] is not specified, it defaults to [TextInputType.text]
  ///
  /// When `maxLines` is not specified, it defaults to 1
  const CVTypeAheadField({
    required this.label,
    this.type = TextInputType.text,
    this.action = TextInputAction.next,
    this.maxLines = 1,
    this.validator,
    this.onSaved,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 8,
    ),
    this.focusNode,
    this.onFieldSubmitted,
    required this.countryInstituteObject,
    this.controller,
    required this.toggle,
    Key? key,
  }) : super(key: key);

  final String label;
  final TextEditingController? controller;
  final TextInputType type;
  final TextInputAction action;
  final int maxLines;
  final String? Function(String?)? validator;
  final Function(String?)? onSaved;
  final Function? onFieldSubmitted;
  final EdgeInsets padding;
  final FocusNode? focusNode;
  final CountryInstituteAPI countryInstituteObject;
  final String toggle;

  static const String COUNTRY = 'country';
  static const String EDUCATIONAL_INSTITUTE = 'educational institute';

  @override
  Widget build(BuildContext context) {
    String? text;

    return Padding(
      padding: padding,
      child: FutureBuilder(
        builder: (context, projectSnap) {
          if (projectSnap.connectionState == ConnectionState.none &&
              projectSnap.hasData) {
            return Container();
          }
          return TypeAheadFormField(
            textFieldConfiguration: TextFieldConfiguration(
              decoration: CVTheme.textFieldDecoration.copyWith(
                labelText: label,
                labelStyle: TextStyle(
                  color: CVTheme.textColor(context),
                ),
              ),
              controller: controller,
              textInputAction: action,
              focusNode: focusNode,
              style: TextStyle(
                color: CVTheme.textColor(context),
              ),
              maxLines: maxLines,
              keyboardType: type,
              autofocus: true,
            ),
            suggestionsCallback: (pattern) async {
              try {
                if (toggle == COUNTRY) {
                  return await countryInstituteObject.getCountries(
                    pattern,
                  );
                }
                if (toggle == EDUCATIONAL_INSTITUTE) {
                  return await countryInstituteObject.getInstitutes(
                    pattern,
                  );
                }
                //// If there is need of some other API Fetch add another if condition
                return [
                  if (pattern == '') 'No suggestions found' else pattern,
                ];
              } catch (e) {
                return [
                  if (pattern == '') 'No suggestions found' else pattern,
                ];
              }
            },
            transitionBuilder: (context, suggestionsBox, controller) {
              return suggestionsBox;
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion as String),
              );
            },
            onSuggestionSelected: (value) {
              if (value != '') {
                controller?.text = value as String;
              }
            },
            onSaved: (value) {
              onSaved!(
                (value == '') ? (text ?? 'N.A') : value,
              );
            },
          );
        },
      ),
    );
  }
}
