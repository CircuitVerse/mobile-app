class Links {
  factory Links.fromJson(Map<String, dynamic> json) => Links(
        self: json['self'],
        first: json['first'],
        prev: json['prev'],
        next: json['next'],
        last: json['last'],
      );

  Links({
    required this.self,
    required this.first,
    required this.last,
    this.prev,
    this.next,
  });
  String self;
  String first;
  dynamic prev;
  dynamic next;
  String last;
}
