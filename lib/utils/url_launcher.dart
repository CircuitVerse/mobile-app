import 'package:url_launcher/url_launcher_string.dart';

Future<void> launchURL(String url) async {
  if (url.startsWith('mailto:')) {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: url.replaceAll('mailto:', ''),
    );

    if (await canLaunchUrlString(emailLaunchUri.toString())) {
      await launchUrlString(emailLaunchUri.toString());
    } else {
      throw 'Could not launch email client for $url';
    }
    return;
  }

  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    throw 'Could not launch $url';
  }
}

// Helper function for email links
Future<void> launchEmail(String email) async {
  await launchURL('mailto:$email');
}
