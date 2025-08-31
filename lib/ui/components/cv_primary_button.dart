import 'package:flutter/material.dart';
import 'package:mobile_app/cv_theme.dart';

class CVPrimaryButton extends StatefulWidget {
  const CVPrimaryButton({
    required this.title,
    this.onPressed,
    this.isBodyText = false,
    this.isPrimaryDark = false,
    this.padding = const EdgeInsetsDirectional.all(8),
    this.textStyle,
    super.key,
  });

  final String title;
  final VoidCallback? onPressed;
  final bool isBodyText;
  final bool isPrimaryDark;
  final EdgeInsetsGeometry padding;
  final TextStyle? textStyle;

  // Small button variant constructor
  factory CVPrimaryButton.small({
    required String title,
    VoidCallback? onPressed,
    bool isPrimaryDark = false,
  }) {
    return CVPrimaryButton(
      title: title,
      onPressed: onPressed,
      isPrimaryDark: isPrimaryDark,
      padding: const EdgeInsetsDirectional.symmetric(
        vertical: 6,
        horizontal: 12,
      ),
      textStyle: const TextStyle(
        fontSize: 14,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  @override
  CVPrimaryButtonState createState() => CVPrimaryButtonState();
}

class CVPrimaryButtonState extends State<CVPrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  late Animation<Color?> _backgroundColorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _elevationAnimation = Tween<double>(begin: 2.0, end: 6.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _updateColorAnimation();
  }

  void _updateColorAnimation() {
    final primaryColor =
        widget.isPrimaryDark ? CVTheme.primaryColorDark : CVTheme.primaryColor;

    _backgroundColorAnimation = ColorTween(
      begin: primaryColor,
      end: primaryColor.withAlpha(204), // ~80% opacity for pressed state
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(CVPrimaryButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isPrimaryDark != widget.isPrimaryDark) {
      _updateColorAnimation();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null) {
      _animationController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onPressed != null) {
      _animationController.reverse();
    }
  }

  void _onTapCancel() {
    if (widget.onPressed != null) {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: widget.padding,
                backgroundColor:
                    _backgroundColorAnimation.value ??
                    (widget.isPrimaryDark
                        ? CVTheme.primaryColorDark
                        : CVTheme.primaryColor),
                elevation: _elevationAnimation.value,
                overlayColor: null,
              ),
              onPressed: widget.onPressed ?? () {},
              child: Text(
                widget.title,
                style:
                    widget.textStyle ??
                    (widget.isBodyText
                        ? Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(color: Colors.white)
                        : Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(color: Colors.white)),
              ),
            ),
          );
        },
      ),
    );
  }
}
