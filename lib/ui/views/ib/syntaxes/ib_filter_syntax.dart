import 'package:markdown/markdown.dart' as md;

class IbFilterSyntax extends md.BlockSyntax {
  IbFilterSyntax() : super();

  @override
  md.Node parse(md.BlockParser parser) {
    parser.advance();
    return null;
  }

  @override
  RegExp get pattern => RegExp(r'^(##\sTable\s[oO]f\s[cC]ontents)|(1.\sTOC)');
}
