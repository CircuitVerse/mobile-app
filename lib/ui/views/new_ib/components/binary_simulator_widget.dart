import 'package:flutter/material.dart';
import 'package:mobile_app/ib_theme.dart';

class BinarySimulatorWidget extends StatefulWidget {
  const BinarySimulatorWidget({super.key});

  @override
  State<BinarySimulatorWidget> createState() => _BinarySimulatorWidgetState();
}

class _BinarySimulatorWidgetState extends State<BinarySimulatorWidget> {
  final List<bool> _bits = List.filled(8, false);
  final List<int> _bitValues = [128, 64, 32, 16, 8, 4, 2, 1];

  int get _decimalValue {
    int sum = 0;
    for (int i = 0; i < 8; i++) {
      if (_bits[i]) {
        sum += _bitValues[i];
      }
    }
    return sum;
  }

  void _toggleBit(int index) {
    setState(() {
      _bits[index] = !_bits[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: IbTheme.textColor(context).withAlpha(51),
        ),
      ),
      child: Column(
        children: [
          // Header row with bit values
          Row(
            children: [
              _buildSideLabel(context, 'Binary'),
              ..._bitValues.map((value) => _buildColumnHeader(context, value.toString())),
              _buildColumnHeader(context, 'Decimal', isResult: true),
            ],
          ),
          // Bit row with clickable buttons
          Row(
            children: [
              _buildSideLabel(context, ''),
              for (int i = 0; i < 8; i++)
                _buildBitCell(context, i),
              _buildResultCell(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSideLabel(BuildContext context, String text) {
    return Container(
      width: 50,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFF302d36),
        border: Border(
          right: BorderSide(
            color: IbTheme.textColor(context).withAlpha(51),
          ),
        ),
      ),
      child: Center(
        child: RotatedBox(
          quarterTurns: 3,
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF00e8b3),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColumnHeader(BuildContext context, String value, {bool isResult = false}) {
    return Expanded(
      flex: isResult ? 2 : 1,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF302d36),
          border: Border(
            right: BorderSide(
              color: IbTheme.textColor(context).withAlpha(51),
            ),
          ),
        ),
        child: Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF00e8b3),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildBitCell(BuildContext context, int index) {
    return Expanded(
      child: InkWell(
        onTap: () => _toggleBit(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFf1f1f1),
            border: Border(
              right: BorderSide(
                color: IbTheme.textColor(context).withAlpha(51),
              ),
            ),
          ),
          child: Text(
            _bits[index] ? '1' : '0',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF111111),
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultCell(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: const BoxDecoration(
          color: Color(0xFF5AEF9E),
        ),
        child: Text(
          _decimalValue.toString(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF111111),
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
