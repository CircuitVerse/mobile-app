import 'package:url_launcher/url_launcher_string.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

Future<void> launchURL(BuildContext context, String url) async {
  if (url.startsWith('mailto:')) {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      final email = url.replaceFirst('mailto:', '');
      Clipboard.setData(ClipboardData(text: email));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Email copied to clipboard: $email"),
          duration: Duration(seconds: 1),
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Failed to open the URL: $url",
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
              await launchURL(context, url);
            },
          ),
        ),
      );
    }
  }
}
