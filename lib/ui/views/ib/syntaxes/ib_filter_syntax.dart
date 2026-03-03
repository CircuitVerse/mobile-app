import 'package:markdown/markdown.dart' as md;

class IbFilterSyntax extends md.BlockSyntax {
  IbFilterSyntax() : super();

  @override
  md.Node? parse(md.BlockParser parser) {
    parser.advance();
    // Return a block placeholder instead of null for stack safety
    return md.Element('p', [md.Element.withTag('empty')]);
  }

  @override
  RegExp get pattern => RegExp(r'^(##\sTable\s[oO]f\s[cC]ontents)|(1.\sTOC)');
}
