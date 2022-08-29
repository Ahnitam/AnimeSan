class UnlogedException implements Exception {
  final String cause;
  UnlogedException({this.cause = ""}) : super();

  @override
  String toString() => "UnlogedException: $cause";
}
