import 'package:flutter/material.dart';
import 'package:mobile_app/features/interactive-book/models/navbar.dart';
import 'package:mobile_app/features/interactive-book/services/offline.dart';

/// Download-for-offline card. Shows the cache size once content is stored and
/// switches to a live counter while a download is running.
class OfflineModeCard extends StatelessWidget {
  const OfflineModeCard({
    super.key,
    required this.library,
    required this.navbarData,
  });

  final OfflineLibrary library;
  final InteractiveBookNavbarModel navbarData;

  @override
  Widget build(BuildContext context) {
    final downloading = library.isDownloading;
    final hasContent = library.hasContent;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Color(0xFFE7F6EE),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                hasContent && !downloading
                    ? Icons.offline_pin_outlined
                    : Icons.cloud_download_outlined,
                size: 32,
                color: Color(0xFF12A150),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Offline Mode',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _subtitle(downloading, hasContent),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Color(0xFF6B7280),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _actionButton(context, downloading, hasContent),
                  const SizedBox(height: 4),
                  Text(
                    hasContent ? library.formattedSize : '—',
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(color: Color(0xFF6B7280)),
                  ),
                ],
              ),
            ],
          ),
          if (downloading) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: library.downloadProgress,
                minHeight: 6,
                backgroundColor: Color(0xFFDFE3E0),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF12A150),
                ),
              ),
            ),
          ],
          if (!downloading && library.error != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 15,
                  color: Color(0xFFE8842A),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    library.error!,
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(color: Color(0xFFE8842A)),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _subtitle(bool downloading, bool hasContent) {
    if (downloading) {
      return 'Downloading ${library.done} of ${library.total} pages…';
    }
    if (hasContent) {
      return 'Book saved on this device. Tap to remove.';
    }
    return 'Download content to access anytime, anywhere.';
  }

  Widget _actionButton(
    BuildContext context,
    bool downloading,
    bool hasContent,
  ) {
    if (downloading) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF12A150)),
        ),
      );
    }

    return OutlinedButton(
      onPressed:
          hasContent ? library.clear : () => library.downloadAll(navbarData),
      style: OutlinedButton.styleFrom(
        foregroundColor: Color(0xFF12A150),
        side: const BorderSide(color: Color(0xFF12A150)),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        hasContent ? 'Remove' : 'Download All',
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
      ),
    );
  }
}
