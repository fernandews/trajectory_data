import 'package:crypto/crypto.dart';
import 'dart:math';

class User {
  String _id;
  static const String _initialId = "initialId";

  User._(this._id);
  static User? _instance;

  static User getUser() {
    _instance ??= User._(_initialId);
    return _instance!;
  }

  void setId(String newId) {
    _id = newId;
  }

  String getId() {
    return _id;
  }

  String getInitialId() {
    return _initialId;
  }

  String generateRandomId() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (i) => random.nextInt(256));
    final hash = md5.convert(bytes);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    _id = '${hash.toString()}-$timestamp';
    return '${hash.toString()}-$timestamp';
  }
}

