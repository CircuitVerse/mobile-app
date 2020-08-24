import 'package:html/parser.dart';

class StringUtils {
  static String parseHtmlString(String htmlString) {
    var document = parse(htmlString);
    var parsedString = parse(document.body.text).documentElement.text;
    return parsedString;
  }
}
