import 'package:html/parser.dart';

class StringUtils {
  static String parseHtmlString(String htmlString) {
    var document = parse(htmlString);
    return parse(document.body!.text).documentElement!.text;
  }
}
