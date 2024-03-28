enum NotificationType {
  signal, calendar, common
}

extension NotificationTypeExtension on NotificationType {
  String get convertText {
    switch (this) {
      case NotificationType.signal:
        return "SIGNAL";
      case NotificationType.calendar:
        return "CALENDAR";
      case NotificationType.common:
        return "COMMON";
      default:
        return "";
    }
  }
}
