abstract class IbContent {
  IbContent({required this.content});
  String content;
}

class IbTocItem extends IbContent {
  IbTocItem({required super.content, required this.leading, this.items});

  final String leading;
  final List<IbTocItem>? items;
}

class IbMd extends IbContent {
  IbMd({required super.content});
}
