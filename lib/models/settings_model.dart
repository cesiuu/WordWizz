class SettingsModel {
  bool isDarkMode;
  String language;
  double fontSize;
  bool notificationsEnabled;

  SettingsModel({
    required this.isDarkMode,
    required this.language,
    required this.fontSize,
    required this.notificationsEnabled,
  });
}
