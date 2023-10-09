import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:workmanager/workmanager.dart';
import 'package:path/path.dart';


class User {
  String id;
  User._(this.id);

  static User? _instance;

  static User getInstance() {
    if (_instance == null) {
      _instance = User._("initialId");
    }
    return _instance!;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
    };
  }

  void setId(String newId) {
    id = newId;
  }

  Future<Database> _openDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'database_user.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY)',
        );
      },
    );
  }

 static Future<Map<String, dynamic>?> getUserId(Database db) async {

    final List<Map<String, dynamic>> maps = await db.query(
        'users');
    if (maps.isNotEmpty) {
      return {
        'id': maps[0]['id'],
      };
    } else {
      return null;
    }
  }

  String generateRandomId() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (i) => random.nextInt(256));
    final hash = md5.convert(bytes);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    print('${hash.toString()}-$timestamp');
    return '${hash.toString()}-$timestamp';
  }

  void saveUserIdToLocalStorage(User user, Database db) {
     db.insert(
      'users',
      user.toMap(),
    );
  }
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final User user = User.getInstance();
    final Database db = await user._openDatabase();
    if (inputData?['user'] != '') {

      user.id = inputData?['user'];
      final Map<String, dynamic?>? data = await User.getUserId(db);
      if (data == null) {
        user.saveUserIdToLocalStorage(user, db);
      }
    } else{
      final Map<String, dynamic?>? data = await User.getUserId(db);
      if (data != null) {
        user.id = data['id'];
      } else {
          final String newUniqueId = user.generateRandomId();
          user.id = newUniqueId;
          user.saveUserIdToLocalStorage(user, db);
      }
    }
    return Future.value(true);
  });
}



void startUserService(user) {
  Workmanager().initialize(callbackDispatcher);
  Workmanager().registerOneOffTask(
    "set-user",
    "simpleTask",
    inputData: <String, dynamic>{'user': user},
  );
}

