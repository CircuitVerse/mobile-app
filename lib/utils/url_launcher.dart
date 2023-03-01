import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

void launchURL(String url) async {
  var str1 = 'mailto';
  if (url.startsWith(str1)) {
    final url = Uri.parse('mailto:support@circuitverse.org');
    await launchUrl(url);
  } else {
    await launchUrlString(url, mode: LaunchMode.externalApplication);
  }
}
