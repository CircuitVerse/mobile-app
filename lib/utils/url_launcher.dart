import 'package:url_launcher/url_launcher_string.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

void launchURL(BuildContext context, String url) async {
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
      await Future.delayed(Duration(seconds: 1));
      await launchUrlString(
        'https://mail.google.com/mail/u/0/?fs=1&to=$email&tf=cm',
        mode: LaunchMode.externalApplication,
      );
    }
  } else {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    }
  }
}
