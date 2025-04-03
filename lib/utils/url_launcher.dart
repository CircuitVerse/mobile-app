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

  void showCustomSnackBar({
    required String message,
    Color backgroundColor = Colors.grey,
    Duration duration = const Duration(seconds: 2),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: duration,
        margin: const EdgeInsets.all(16),
        action: action,
      ),
    );
  }

  void showFallbackDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Notification"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  if (url.startsWith('mailto:')) {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      final email = url.replaceFirst('mailto:', '');
      Clipboard.setData(ClipboardData(text: email));
      showCustomSnackBar(
        message: "Email copied to clipboard: $email",
        backgroundColor: Colors.grey.shade800,
        duration: const Duration(seconds: 2),
      );
      final emailurl = 'https://mail.google.com/mail/u/0/?fs=1&to=$email&tf=cm';
      if (await canLaunchUrlString(emailurl)) {
        await launchUrlString(emailurl, mode: LaunchMode.externalApplication);
      } else {
        showFallbackDialog(context, "Failed to open the email client");
      }
    }
  } else if (url.startsWith('sms:')) {
    final Uri smsUri = Uri.parse(url);
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri, mode: LaunchMode.externalApplication);
    } else {
      final phone = url.replaceFirst('sms:', '');
      Clipboard.setData(ClipboardData(text: phone));
      showCustomSnackBar(
        message: "Phone number copied to clipboard: $phone",
        backgroundColor: Colors.grey.shade800,
        duration: const Duration(seconds: 2),
      );
    }
  } else {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    } else if (retryCount < maxRetryAttempts) {
      Clipboard.setData(ClipboardData(text: url));
      if (ScaffoldMessenger.of(context).mounted) {
        showCustomSnackBar(
          message: "Couldn't open $url. Copied to clipboard.",
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: "Retry",
            textColor: Colors.white,
            onPressed: () async {
              await launchURL(context, url, retryCount: retryCount + 1);
            },
          ),
        );
      } else {
        showFallbackDialog(context, "Failed to open the URL");
      }
    } else {
      if (ScaffoldMessenger.of(context).mounted) {
        showCustomSnackBar(
          message: "Failed to open the URL after several attempts.",
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 2),
        );
      } else {
        showFallbackDialog(
          context,
          "Failed to open the URL after several attempts.",
        );
      }
    }
  }
}
