import 'package:flutter/material.dart';
import 'package:mobile_app/cv_theme.dart';

class CVOutlineButton extends StatefulWidget {
  const CVOutlineButton({
    super.key,
    required this.title,
    this.onPressed,
    this.isBodyText = false,
    this.isPrimaryDark = false,
    this.leadingIcon,
    this.minWidth = 160,
    this.maxWidth = double.infinity,
    this.padding = const EdgeInsetsDirectional.symmetric(
      horizontal: 12,
      vertical: 10,
    ),
    this.fontSize,
  });

  final String title;
  final VoidCallback? onPressed;
  final bool isBodyText;
  final bool isPrimaryDark;
  final IconData? leadingIcon;
  final double minWidth;
  final double maxWidth;
  final EdgeInsetsDirectional padding;
  final double? fontSize;

  @override
  CVOutlineButtonState createState() => CVOutlineButtonState();
}

class CVOutlineButtonState extends State<CVOutlineButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _borderColorAnimation;
  late Animation<Color?> _textColorAnimation;

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

    _updateColorAnimations();
  }

  void _updateColorAnimations() {
    final primaryColor =
        widget.isPrimaryDark ? CVTheme.primaryColorDark : CVTheme.primaryColor;

    _borderColorAnimation = ColorTween(
      begin: primaryColor,
      end: primaryColor.withAlpha(153), // ~60% opacity
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _textColorAnimation = ColorTween(
      begin: primaryColor,
      end: primaryColor.withAlpha(179), // ~70% opacity
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(CVOutlineButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isPrimaryDark != widget.isPrimaryDark) {
      _updateColorAnimations();
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
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: widget.minWidth,
        maxWidth: widget.maxWidth,
      ),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: widget.padding,
                  side: BorderSide(
                    color:
                        _borderColorAnimation.value ??
                        (widget.isPrimaryDark
                            ? CVTheme.primaryColorDark
                            : CVTheme.primaryColor),
                    width: 2,
                  ),
                  foregroundColor:
                      _textColorAnimation.value ??
                      (widget.isPrimaryDark
                          ? CVTheme.primaryColorDark
                          : CVTheme.primaryColor),
                  overlayColor: null,
                ),
                onPressed: widget.onPressed ?? () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.leadingIcon != null)
                      Padding(
                        padding: const EdgeInsetsDirectional.only(end: 6),
                        child: Icon(widget.leadingIcon, size: 18),
                      ),
                    Flexible(
                      child: Text(
                        widget.title,
                        overflow: TextOverflow.ellipsis,
                        style: (widget.isBodyText
                                ? Theme.of(context).textTheme.bodyLarge
                                : Theme.of(context).textTheme.titleLarge)
                            ?.copyWith(fontSize: widget.fontSize),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
