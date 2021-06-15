class Failure implements Exception {
  final String message;

  Failure(this.message);

  @override
  String toString() => message;
}
