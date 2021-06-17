import 'package:flutter/material.dart';

class IbChapter {
  final String id;
  final String value;
  final String navOrder;
  String prev;
  String next;
  final List<IbChapter> items;

  IbChapter({
    @required this.id,
    @required this.value,
    @required this.navOrder,
    this.prev,
    this.next,
    this.items,
  });

  set prevPage(String prev) => this.prev = prev;
  set nextPage(String next) => this.next = next;
}
