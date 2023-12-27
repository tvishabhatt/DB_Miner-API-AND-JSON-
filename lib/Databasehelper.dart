


import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseHelper {
  static final DataBaseHelper _instance = DataBaseHelper._internal();
  late Database _database;
  String TableName = 'quotes';

  factory DataBaseHelper() => _instance;

  DataBaseHelper._internal();

  Future<void> initializeDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'quotes.db');

    _database = await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $TableName (
        id INTEGER PRIMARY KEY,
        category TEXT NOT NULL,
        quote TEXT  NOT NULL,
        author TEXT  NOT NULL
      )
    ''');

    String jsonString = await rootBundle.loadString('assets/category.json');
    Map<String, dynamic> data = json.decode(jsonString);

    data.forEach((category, quotes) {
      if (quotes is List) {
        quotes.forEach((quote) async {
          if(quote['quote']!=null){
            await db.insert('quotes', {'category': category, 'quote': quote['quote'],'author': quote['author']});
          }
        });
      }
    });
  }
  Future<List<Map<String, dynamic>>> queryAllCategory() async {
    return await _database.query(TableName);
  }
  Future<List<Map<String, dynamic>>> getQuotesByCategory(String category) async {
    try {

      if (_database == null || !_database.isOpen) {

        return [];
      }

      return await _database.query('quotes', where: 'category = ?', whereArgs: [category]);
    } catch (e) {

      print('Error in getQuotesByCategory: $e');
      return [];
    }

  }
}