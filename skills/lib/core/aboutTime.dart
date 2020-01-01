class AboutTime {
  static DateTime changeMonth(DateTime month, int change) {
    return DateTime(month.year, month.month + change);
  }
}
