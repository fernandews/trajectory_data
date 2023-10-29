import 'package:crypto/crypto.dart';
import 'dart:async';
import 'dart:math';
import 'package:sqflite/sqflite.dart';
import 'package:workmanager/workmanager.dart';

class User {
  String id;

  User._(this.id);
  static User? _instance;

  static User getUser() {
    _instance ??= User._("initialId");
    return _instance!;
  }

  void setId(String newId) {
    id = newId;
  }

  String getId() {
    return id;
  }

  String generateRandomId() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (i) => random.nextInt(256));
    final hash = md5.convert(bytes);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${hash.toString()}-$timestamp';
  }

  void saveUserIdToLocalStorage(User user, Database db) {
    db.insert(
      'users',
      { 'id': id },
    );
  }
}

