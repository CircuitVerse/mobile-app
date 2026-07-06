import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widget_previews.dart';

class BinaryPixelGrid extends StatefulWidget {
  @Preview(name: 'Character Representation')
  const BinaryPixelGrid({super.key});

  @override
  State<BinaryPixelGrid> createState() => _BinaryPixelGridState();
}

class _BinaryPixelGridState extends State<BinaryPixelGrid> {
  static int rows = 8;
  static int cols = 8;
  static double cellSize = 42;

  final List<TextEditingController> controllers = List.generate(
    rows,
    (_) => TextEditingController(),
  );

  final List<int> values = List.filled(rows, 0);

  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _showError() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Please enter a number between 0 and 255.'),
          duration: Duration(seconds: 2),
        ),
      );
  }

  void _onValueChanged(String text, int row) {
    if (text.isEmpty) {
      setState(() {
        values[row] = 0;
      });
      return;
    }

    final value = int.tryParse(text);

    if (value == null) return;

    if (value < 0 || value > 255) {
      _showError();

      controllers[row].clear();

      setState(() {
        values[row] = 0;
      });

      return;
    }

    setState(() {
      values[row] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Column headers
        Row(
          children: [
            SizedBox(width: cellSize + 8),
            ...List.generate(cols, (col) {
              final value = 1 << (7 - col);

              return SizedBox(
                width: cellSize,
                child: Center(
                  child: Text(
                    value.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }),
          ],
        ),

        SizedBox(height: 8),

        // Rows
        Column(
          children: List.generate(rows, (row) {
            return Padding(
              padding: EdgeInsets.only(bottom: 2),
              child: Row(
                children: [
                  SizedBox(
                    width: cellSize,
                    height: cellSize,
                    child: TextField(
                      controller: controllers[row],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: (value) => _onValueChanged(value, row),
                    ),
                  ),

                  SizedBox(width: 8),

                  ...List.generate(cols, (col) {
                    final bit = (values[row] >> (7 - col)) & 1;

                    return Container(
                      width: cellSize,
                      height: cellSize,
                      decoration: BoxDecoration(
                        color: bit == 1 ? Colors.black : Colors.grey.shade300,
                        border: Border.all(color: Colors.grey.shade500),
                      ),
                    );
                  }),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}
