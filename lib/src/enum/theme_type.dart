enum ThemeType {
  defaultMode, darkMode
}

extension ThemeTypeExtension on ThemeType {
  String get convertText {
    switch (this) {
      case ThemeType.defaultMode:
        return "defaultMode";
      case ThemeType.darkMode:
        return "darkMode";
      default:
        return "defaultMode";
    }
  }
}
