import 'package:flutter/material.dart';

class ThemeToggleButton extends StatelessWidget {
  final bool isDark;
  final VoidCallback onToggle;

  const ThemeToggleButton({
    super.key,
    required this.isDark,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final double scale = MediaQuery.of(context).textScaleFactor;

    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        width: 64 * scale.clamp(1.0, 1.2),
        height: 34 * scale.clamp(1.0, 1.2),
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade200,

          // 🔥 WHITE BORDER (BOTH THEMES)
          border: Border.all(color: Colors.white, width: 1.5),

          // 🌫️ Soft shadow for depth
          boxShadow: [
            BoxShadow(
              color:
                  isDark
                      ? Colors.black.withOpacity(0.6)
                      : Colors.grey.withOpacity(0.5),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
          alignment: isDark ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,

              // ✨ Knob glow
              boxShadow: [
                BoxShadow(
                  color:
                      isDark
                          ? Colors.blueAccent.withOpacity(0.4)
                          : Colors.orange.withOpacity(0.4),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Icon(
              isDark ? Icons.nightlight_round : Icons.wb_sunny,
              size: 16,
              color: isDark ? Colors.black : Colors.orange,
            ),
          ),
        ),
      ),
    );
  }
}
