import 'package:flutter/material.dart';

class IbChapter {
  final String id;
  final String value;
  final String navOrder;
  final String prev;
  final String next;
  final List<IbChapter> items;

  IbChapter({
    @required this.id,
    @required this.value,
    @required this.navOrder,
    this.prev,
    this.next,
    this.items,
  });
}
