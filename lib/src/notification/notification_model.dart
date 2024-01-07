class NotificationModel {
  String _title;
  String _text;

  NotificationModel(String title, String text)
      : _title = title,
        _text = text;

  String get title => _title;

  set title(String title) {
    _title = title;
  }

  String get text => _text;

  set text(String text) {
    _text = text;
  }
}
