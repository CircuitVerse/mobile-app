import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

class BinaryConverterWidget extends StatefulWidget {
  @Preview(name: "Binary Converter")
  const BinaryConverterWidget({super.key});

  @override
  State<BinaryConverterWidget> createState() => _BinaryConverterWidgetState();
}

class _BinaryConverterWidgetState extends State<BinaryConverterWidget> {
  final List<int> placeValues = [128, 64, 32, 16, 8, 4, 2, 1];
  final List<int> bits = [0, 0, 0, 0, 0, 0, 0, 0];

  // 1 label col + 8 bit cols + 1 decimal col = 10 columns
  static const int _totalColumns = 10;

  int get decimalValue {
    int value = 0;
    for (int i = 0; i < bits.length; i++) {
      value += bits[i] * placeValues[i];
    }
    return value;
  }

  void toggleBit(int index) {
    setState(() {
      bits[index] = bits[index] == 0 ? 1 : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cellWidth = constraints.maxWidth / _totalColumns;
          final headerHeight = 30.0;
          final bitHeight = 50.0;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Binary label column
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: cellWidth,
                    height: headerHeight,
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        color: Color(0xff2d2a35),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: cellWidth,
                    height: bitHeight,
                    decoration: const BoxDecoration(
                      color: Color(0xff2d2a35),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                      ),
                    ),
                    child: Center(
                      child: RotatedBox(
                        quarterTurns: 3,
                        child: Text(
                          "Binary",
                          style: const TextStyle(
                            color: Colors.tealAccent,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Bit columns
              for (int i = 0; i < placeValues.length; i++)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: cellWidth,
                      height: headerHeight,
                      alignment: Alignment.center,
                      color: const Color(0xff2d2a35),
                      child: Text(
                        placeValues[i].toString(),
                        style: const TextStyle(
                          color: Colors.tealAccent,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => toggleBit(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: cellWidth,
                        height: bitHeight,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        alignment: Alignment.center,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 150),
                          child: Text(
                            bits[i].toString(),
                            key: ValueKey(bits[i]),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

              // Decimal column
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: cellWidth,
                    height: headerHeight,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xff2d2a35),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5),
                      ),
                    ),
                    child: const Text(
                      "Decimal",
                      style: TextStyle(
                        color: Colors.tealAccent,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: cellWidth,
                    height: bitHeight,
                    decoration: const BoxDecoration(
                      color: Color(0xff58d68d),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(5),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 150),
                      child: Text(
                        decimalValue.toString(),
                        key: ValueKey(decimalValue),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
