import 'dart:convert';
import 'dart:async';
//import 'package:flutter/material.dart';
import 'package:trajectory_data/src/geolocationv0/geolocation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//estabelece a conexão com o banco de dados
Future<Database> _openDatabase() async {
  final databasePath = await getDatabasesPath();
  final path = join(databasePath, 'geolocation.db');
  return openDatabase(
    path,
    version: 1,
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE geolocations(id INTEGER PRIMARY KEY AUTOINCREMENT, user INTEGER, datetime TEXT, trajectory TEXT)',
      );
    },
  );
}

//inicia a conexão com o banco e faz a inserção dos dados na tabela
Future<void> _insertData(Geolocation geolocation) async {
  final Database db = await _openDatabase();
  await db.insert(
    'geolocations',
    geolocation.toMap(),
  );
}

//Faz a inserção dos dados no SQLite
Future<void> insertDataInBackground(Geolocation newGeolocation) {
  return _insertData(newGeolocation);
}




