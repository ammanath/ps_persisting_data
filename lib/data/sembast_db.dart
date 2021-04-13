import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'dart:async';
import 'package:path_provider_windows/path_provider_windows.dart';
import 'package:path/path.dart';
import '../models/password.dart';

class SembastDb {
  DatabaseFactory dbFactory = databaseFactoryIo;
  Database _db;
  final store = intMapStoreFactory.store('passwords');

  SembastDb._privateConstructor();

  static final SembastDb _instance = SembastDb._privateConstructor();

  factory SembastDb() {
    return _instance;
  }

  Future<Database> init() async {
    if (_db == null) {
      _db = await _OpenDb();
    }
    return _db;
  }

  Future _OpenDb() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final dbPath = join(docsDir.path, 'pass.db');
    final db = await dbFactory.openDatabase(dbPath);
    return db;
  }

  Future<int> addPassword(Password pwd) async {
    int id = await store.add(_db, pwd.toMap());
    return id;
  }

  Future getPasswords() async {
    await init();
    final finder = Finder(sortOrders: [SortOrder('name')]);
    final snapshot = await store.find(_db, finder: finder);
    return snapshot.map((item) {
      final pwd = Password.fromMap(item.value);
      pwd.id = item.key;
      return pwd;
    }).toList();
  }

  Future updatePassword(Password pwd) async {
    final finder = Finder(filter: Filter.byKey(pwd.id));
    await store.update(_db, pwd.toMap(), finder: finder);
  }

  Future deletePassword(Password pwd) async {
    final finder = Finder(filter: Filter.byKey(pwd.id));
    await store.delete(_db, finder: finder);
  }

  Future deleteAll() async {
    await store.delete(_db);
  }
}
