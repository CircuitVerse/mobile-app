class Failure implements Exception {
  Failure(this.message);
  final String message;

  @override
  String toString() => message;
}
