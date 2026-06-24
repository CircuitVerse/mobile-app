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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Binary Label
          Container(
            width: 40,
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xff2d2a35),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5)),
            ),
            child: Center(
              child: RotatedBox(
                quarterTurns: 3,
                child: Text(
                  "Binary",
                  style: TextStyle(
                    color: Colors.tealAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          for (int i = 0; i < placeValues.length; i++)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 30,
                  alignment: Alignment.center,
                  color: const Color(0xff2d2a35),
                  child: Text(
                    placeValues[i].toString(),
                    style: TextStyle(
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
                    width: 40,
                    height: 50,
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
                        style: TextStyle(
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

          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 30,
                alignment: Alignment.center,

                decoration: const BoxDecoration(
                  color: Color(0xff2d2a35),
                  borderRadius: BorderRadius.only(topRight: Radius.circular(5)),
                ),
                child: Text(
                  "Decimal",
                  style: TextStyle(
                    color: Colors.tealAccent,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: 60,
                height: 50,
                decoration: const BoxDecoration(
                  color: Color(0xff58d68d),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  decimalValue.toString(),
                  key: ValueKey(decimalValue),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),

          /// Decimal Cell
        ],
      ),
    );
  }
}
