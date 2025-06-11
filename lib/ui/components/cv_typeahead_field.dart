import 'package:flutter/material.dart';
import 'package:mobile_app/services/API/country_institute_api.dart';

class CVTypeAheadField extends StatefulWidget {
  /// Creates a [TextField] that is specifically styled for CircuitVerse.
  ///
  /// When a [TextInputStream not specified, it defaults to [TextInputType.text]
  ///
  /// When `maxLines` is not specified, it defaults to 1
  const CVTypeAheadField({
    required this.label,
    this.type = TextInputType.text,
    this.action = TextInputAction.next,
    this.maxLines = 1,
    this.validator,
    this.onSaved,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.focusNode,
    this.onFieldSubmitted,
    required this.countryInstituteObject,
    this.controller,
    required this.toggle,
    super.key,
  });

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
  _CVTypeAheadFieldState createState() => _CVTypeAheadFieldState();
}

class _CVTypeAheadFieldState extends State<CVTypeAheadField> {
  List<String> _suggestions = [];
  bool _isLoading = false;
  bool _showSuggestions = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onTextChanged);
    _removeOverlay();
    super.dispose();
  }

  void _onTextChanged() {
    final text = widget.controller?.text ?? '';
    if (text.length >= 2) {
      _fetchSuggestions(text);
    } else {
      _hideSuggestions();
    }
  }

  Future<void> _fetchSuggestions(String query) async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      List<String> suggestions;
      if (widget.toggle == CVTypeAheadField.COUNTRY) {
        suggestions = await widget.countryInstituteObject.getCountries(query);
      } else {
        suggestions = await widget.countryInstituteObject.getInstitutes(query);
      }

      if (mounted) {
        setState(() {
          _suggestions = suggestions;
          _isLoading = false;
          _showSuggestions = suggestions.isNotEmpty;
        });

        if (_showSuggestions) {
          _showOverlay();
        } else {
          _removeOverlay();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _suggestions = [];
          _isLoading = false;
          _showSuggestions = false;
        });
        _removeOverlay();
      }
    }
  }

  void _showOverlay() {
    _removeOverlay();

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            width: MediaQuery.of(context).size.width - 32,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: const Offset(0, 52),
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: _suggestions.length,
                    itemBuilder: (context, index) {
                      final suggestion = _suggestions[index];
                      return ListTile(
                        dense: true,
                        title: Text(suggestion),
                        onTap: () {
                          widget.controller?.removeListener(_onTextChanged);

                          widget.controller?.text = suggestion;
                          widget
                              .controller
                              ?.selection = TextSelection.fromPosition(
                            TextPosition(
                              offset: widget.controller?.text.length ?? 0,
                            ),
                          );

                          setState(() {
                            _showSuggestions = false;
                            _suggestions = [];
                          });
                          _removeOverlay();

                          Future.delayed(const Duration(milliseconds: 100), () {
                            widget.controller?.addListener(_onTextChanged);
                            widget.focusNode?.unfocus();
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _hideSuggestions() {
    setState(() {
      _showSuggestions = false;
      _suggestions = [];
    });
    _removeOverlay();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: CompositedTransformTarget(
        link: _layerLink,
        child: TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          validator: widget.validator,
          onSaved: widget.onSaved,
          textInputAction: widget.action,
          keyboardType: widget.type,
          maxLines: widget.maxLines,
          onFieldSubmitted: (_) {
            _hideSuggestions();
            widget.onFieldSubmitted?.call();
          },
          onTap: () {
            if ((widget.controller?.text.length ?? 0) >= 2) {
              _fetchSuggestions(widget.controller?.text ?? '');
            }
          },
          decoration: InputDecoration(
            labelText: widget.label,
            border: const OutlineInputBorder(),
            suffixIcon:
                _isLoading
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                    : (widget.controller?.text.isNotEmpty ?? false)
                    ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        widget.controller?.clear();
                        _hideSuggestions();
                      },
                    )
                    : null,
          ),
        ),
      ),
    );
  }
}
