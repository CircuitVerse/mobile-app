import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/widget_previews.dart';

class BitwiseOperatorsWidget extends StatefulWidget {
  @Preview(name: 'Bitwise Operators Simulator')
  const BitwiseOperatorsWidget({super.key});

  @override
  State<BitwiseOperatorsWidget> createState() => _LogicTableWidgetState();
}

class _LogicTableWidgetState extends State<BitwiseOperatorsWidget> {
  final List<int> placeValues = [128, 64, 32, 16, 8, 4, 2, 1];
  final List<int> bitsA = [0, 0, 0, 0, 0, 0, 0, 0];
  final List<int> bitsB = [0, 0, 0, 0, 0, 0, 0, 0];

  int _selectedGate = 2; // 0 = AND, 1 = OR, 2 = XOR

  final List<Map<String, String>> gates = [
    {'name': 'AND', 'icon': 'assets/icons/IB/AND_GATE.svg'},
    {'name': 'OR', 'icon': 'assets/icons/IB/OR_GATE.svg'},
    {'name': 'XOR', 'icon': 'assets/icons/IB/XOR_GATE.svg'},
  ];

  int get decimalA {
    int v = 0;
    for (int i = 0; i < bitsA.length; i++) v += bitsA[i] * placeValues[i];
    return v;
  }

  int get decimalB {
    int v = 0;
    for (int i = 0; i < bitsB.length; i++) v += bitsB[i] * placeValues[i];
    return v;
  }

  int get decimalResult {
    switch (_selectedGate) {
      case 0:
        return decimalA & decimalB;
      case 1:
        return decimalA | decimalB;
      case 2:
      default:
        return decimalA ^ decimalB;
    }
  }

  List<int> get resultBits {
    final r = decimalResult;
    return List.generate(8, (i) => (r >> (7 - i)) & 1);
  }

  void _toggleA(int i) => setState(() => bitsA[i] = bitsA[i] == 0 ? 1 : 0);
  void _toggleB(int i) => setState(() => bitsB[i] = bitsB[i] == 0 ? 1 : 0);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Layout mirrors binary_simulator.dart:
          // 1 label col + 8 bit cols + 1 decimal col = 10 cols
          const int totalColumns = 10;
          final double cellWidth = constraints.maxWidth / totalColumns;
          const double headerHeight = 30.0;
          const double bitHeight = 50.0;
          const double gateRowHeight = 70.0;
          const double gateSelectorHeight = 28.0;

          final List<int> rb = resultBits;

          return Container(
            decoration: BoxDecoration(
              color: const Color(0xff2d2a35),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //------------------------------------------------------
                // HEADER ROW (no left label, 8 place values + Decimal)
                //------------------------------------------------------
                Row(
                  children: [
                    // Empty top-left corner (label column)
                    SizedBox(
                      width: cellWidth,
                      height: headerHeight,
                      child: const DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color(0xff2d2a35),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    // Place value headers
                    for (int i = 0; i < placeValues.length; i++)
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
                    // Decimal header
                    Container(
                      width: cellWidth,
                      height: headerHeight,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Color(0xff2d2a35),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
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
                  ],
                ),

                //------------------------------------------------------
                // "BINARY" SECTION: label + row A + gate selector + row B
                //------------------------------------------------------
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Rotated "Binary" label spanning rows A & B
                      Container(
                        width: cellWidth,
                        color: const Color(0xff2d2a35),
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

                      // 8 bit columns (rows A + gate selector row + row B stacked)
                      for (int i = 0; i < placeValues.length; i++)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Row A bit cell
                            GestureDetector(
                              onTap: () => _toggleA(i),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: cellWidth,
                                height: bitHeight,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  border: Border.all(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 150),
                                  child: Text(
                                    bitsA[i].toString(),
                                    key: ValueKey('a$i${bitsA[i]}'),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Gate selector row (empty for bit columns)
                            Container(
                              width: cellWidth,
                              height: gateSelectorHeight,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                border: Border.all(color: Colors.grey.shade400),
                              ),
                            ),
                            // Row B bit cell
                            GestureDetector(
                              onTap: () => _toggleB(i),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: cellWidth,
                                height: bitHeight,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  border: Border.all(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 150),
                                  child: Text(
                                    bitsB[i].toString(),
                                    key: ValueKey('b$i${bitsB[i]}'),
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

                      // Decimal column: value A + gate selector (XOR label) + value B
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Decimal A
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: cellWidth,
                            height: bitHeight,
                            decoration: const BoxDecoration(
                              color: Color(0xff58d68d),
                            ),
                            alignment: Alignment.center,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 150),
                              child: Text(
                                decimalA.toString(),
                                key: ValueKey(decimalA),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          // Gate selector label (shows active gate name)
                          Container(
                            width: cellWidth,
                            height: gateSelectorHeight,
                            color: Colors.lightBlue,
                            alignment: Alignment.center,
                            child: Text(
                              gates[_selectedGate]['name']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // Decimal B
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: cellWidth,
                            height: bitHeight,
                            decoration: const BoxDecoration(
                              color: Color(0xff58d68d),
                            ),
                            alignment: Alignment.center,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 150),
                              child: Text(
                                decimalB.toString(),
                                key: ValueKey(decimalB),
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
                  ),
                ),

                //------------------------------------------------------
                // GATE SELECTOR ROW (AND / OR / XOR icons)
                //------------------------------------------------------
                SizedBox(
                  height: gateRowHeight,
                  child: Row(
                    children: [
                      // Left label spacer
                      SizedBox(width: cellWidth),
                      // 3 gate sections, each spanning ~2.67 bit columns
                      for (int g = 0; g < gates.length; g++)
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedGate = g),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color:
                                    _selectedGate == g
                                        ? Colors.lightBlue
                                        : const Color(0xff1e1b26),
                                border: Border(
                                  right:
                                      g < gates.length - 1
                                          ? const BorderSide(
                                            color: Color(0xff2d2a35),
                                            width: 2,
                                          )
                                          : BorderSide.none,
                                ),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  gates[g]['icon']!,
                                  width: cellWidth * 2.5,
                                  height: gateRowHeight * 0.6,
                                ),
                              ),
                            ),
                          ),
                        ),
                      // Decimal spacer
                      SizedBox(width: cellWidth),
                    ],
                  ),
                ),

                //------------------------------------------------------
                // ANSWER ROW
                //------------------------------------------------------
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Rotated "Answer" label
                      Container(
                        width: cellWidth,
                        decoration: const BoxDecoration(
                          color: Color(0xff2d2a35),
                          border: Border(
                            top: BorderSide(color: Colors.lightBlue, width: 2),
                            left: BorderSide(color: Colors.lightBlue, width: 2),
                            bottom: BorderSide(
                              color: Colors.lightBlue,
                              width: 2,
                            ),
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                          ),
                        ),
                        child: Center(
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: Text(
                              "Answer",
                              style: const TextStyle(
                                color: Colors.tealAccent,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // 8 answer bit cells
                      for (int i = 0; i < 8; i++)
                        Container(
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
                              rb[i].toString(),
                              key: ValueKey('r$i${rb[i]}'),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),

                      // Decimal result
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: cellWidth,
                        height: bitHeight,
                        decoration: const BoxDecoration(
                          color: Color(0xff58d68d),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 150),
                          child: Text(
                            decimalResult.toString(),
                            key: ValueKey(decimalResult),
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
