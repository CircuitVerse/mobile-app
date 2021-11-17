class Links {
  String self;
  String first;
  dynamic prev;
  dynamic next;
  String last;
  Links({
    this.self,
    this.first,
    this.prev,
    this.next,
    this.last,
  });


  factory Links.fromJson(Map<String, dynamic> json) => Links(
        self: json['self'],
        first: json['first'],
        prev: json['prev'],
        next: json['next'],
        last: json['last'],
      );
}
