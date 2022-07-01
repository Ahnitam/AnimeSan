class UnlogedException implements Exception {
  final String cause;
  UnlogedException({this.cause = ""});
}
