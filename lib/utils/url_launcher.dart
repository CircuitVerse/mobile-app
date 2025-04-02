import 'package:url_launcher/url_launcher_string.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

Future<void> launchURL(
  BuildContext context,
  String url, {
  int retryCount = 0,
}) async {
  const int maxRetryAttempts = 2;
  if (url.startsWith('mailto:')) {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      final email = url.replaceFirst('mailto:', '');
      Clipboard.setData(ClipboardData(text: email));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Email copied to clipboard: $email",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.grey[800],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 1),
          margin: const EdgeInsets.all(16),
        ),
      );
      await launchUrlString(
        'https://mail.google.com/mail/u/0/?fs=1&to=$email&tf=cm',
        mode: LaunchMode.externalApplication,
      );
    }
  } else {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else if (retryCount < maxRetryAttempts) {
      Clipboard.setData(ClipboardData(text: url));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Couldn't open $url. Copied to clipboard.",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
          action: SnackBarAction(
            label: "Retry",
            textColor: Colors.white,
            onPressed: () async {
              await launchURL(context, url, retryCount: retryCount + 1);
            },
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Failed to open the URL after several attempts.",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: Duration(seconds: 2),
          margin: EdgeInsets.all(16),
        ),
      );
    }
  }
}
