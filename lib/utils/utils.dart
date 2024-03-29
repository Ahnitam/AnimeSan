String? formatterNum(String? num) {
  return num == null
      ? null
      : (num.length <= 1)
          ? "0$num"
          : num;
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
