import 'package:flutter/material.dart';

class IbChapter {
  final String id;
  final String value;
  final String prev;
  final String next;
  final List<IbChapter> items;

  IbChapter({
    @required this.id,
    @required this.value,
    this.prev,
    this.next,
    this.items,
  });
}
