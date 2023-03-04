import 'package:flutter/material.dart';

class IbPopQuizButton extends StatefulWidget {
  const IbPopQuizButton({
    required this.content,
    required this.isCorrect,
    Key? key,
  }) : super(key: key);

  final String content;
  final bool isCorrect;

  @override
  IbPopQuizButtonState createState() => IbPopQuizButtonState();
}

class IbPopQuizButtonState extends State<IbPopQuizButton> {
  bool _isPressed = false;

  Color? _getTextColor() {
    if (_isPressed) {
      return Colors.white;
    }

    return Theme.of(context).textTheme.bodyLarge?.color;
  }

  Color? _getBorderColor() {
    if (_isPressed) {
      if (widget.isCorrect) {
        return Colors.green[400];
      } else {
        return Colors.red[400];
      }
    }

    return Theme.of(context).textTheme.bodyLarge?.color;
  }

  IconData getTheRightIcon() {
    return widget.isCorrect ? Icons.done : Icons.close;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => setState(() {
        _isPressed = !_isPressed;
      }),
      child: Container(
        margin: const EdgeInsets.only(top: 5.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: _isPressed ? _getBorderColor() : null,
          border: Border.all(
            color: _getBorderColor() ?? const Color(0xFF000000),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.content,
              style: TextStyle(color: _getTextColor(), fontSize: 16),
            ),
            if (_isPressed)
              Container(
                height: 19,
                width: 19,
                decoration: BoxDecoration(
                  color: _getTextColor(),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: _getBorderColor() ?? const Color(0xFF000000),
                  ),
                ),
                child: Icon(
                  getTheRightIcon(),
                  size: 16,
                  color: _getBorderColor(),
                ),
              )
            else
              Container(),
          ],
        ),
      ),
    );
  }
}
