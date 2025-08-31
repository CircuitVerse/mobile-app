import 'package:flutter/material.dart';
import 'package:mobile_app/cv_theme.dart';

class CVFlatButton extends StatefulWidget {
  const CVFlatButton({
    required Key key,
    required this.triggerFunction,
    required this.buttonText,
    this.context,
  }) : super(key: key);

  final Function triggerFunction;
  final String buttonText;
  final BuildContext? context;

  @override
  CVFlatButtonState createState() => CVFlatButtonState();
}

class CVFlatButtonState extends State<CVFlatButton>
    with SingleTickerProviderStateMixin {
  Function? dynamicFunction;
  bool isButtonActive = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _colorAnimation = ColorTween(
      begin: Colors.grey,
      end: Colors.grey.withAlpha(179),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void setDynamicFunction(bool isActive) {
    setState(() {
      dynamicFunction = isActive ? widget.triggerFunction : null;
      isButtonActive = isActive;

      // Update color animation based on active state
      _colorAnimation = ColorTween(
        begin: isActive ? CVTheme.primaryColor : Colors.grey,
        end:
            isActive
                ? CVTheme.primaryColor.withAlpha(179)
                : Colors.grey.withAlpha(179),
      ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
      );
    });
  }

  void _onTapDown(TapDownDetails details) {
    if (dynamicFunction != null) {
      _animationController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (dynamicFunction != null) {
      _animationController.reverse();
    }
  }

  void _onTapCancel() {
    if (dynamicFunction != null) {
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
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: TextButton(
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.all(
                    _colorAnimation.value,
                  ),
                  overlayColor: WidgetStateProperty.all(null),
                ),
                onPressed:
                    dynamicFunction == null
                        ? null
                        : () => dynamicFunction!.call(widget.context),
                child: Text(widget.buttonText),
              ),
            ),
          );
        },
      ),
    );
  }
}
