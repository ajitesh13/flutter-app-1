class AppConstants {
  static const appName = 'Shanatani';
  static const packageName = 'com.shanatani.app';
  static const publisherName = 'Shanatani Digital';
  static const premiumInterestMessage =
      "We've recorded your interest. Premium access will be available soon.";
}

bool isSameDate(DateTime? a, DateTime? b) {
  if (a == null || b == null) {
    return false;
  }

  return a.year == b.year && a.month == b.month && a.day == b.day;
}

DateTime onlyDate(DateTime dateTime) =>
    DateTime(dateTime.year, dateTime.month, dateTime.day);
