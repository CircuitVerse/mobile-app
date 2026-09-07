import 'package:flutter/material.dart';

/// Card-shaped row used for Home, About, Guidelines and Exit.
class NavbarTile extends StatelessWidget {
  const NavbarTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isSelected = false,
    this.tint = const Color(0xFF12A150),
    this.tintSurface = const Color(0xFFE7F6EE),
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isSelected;

  /// Icon colour. Defaults to the book's green; the Exit row overrides it so
  /// leaving the book does not look like another destination inside it.
  final Color tint;
  final Color tintSurface;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? tintSurface : Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: tintSurface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: tint),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Icon(Icons.chevron_right, size: 20, color: Color(0xFF6B7280)),
            ],
          ),
        ),
      ),
    );
  }
}
