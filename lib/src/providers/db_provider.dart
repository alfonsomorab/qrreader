import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:qrreaderapp/src/models/scan_model.dart';
export 'package:qrreaderapp/src/models/scan_model.dart';

class DBProvider {

  static Database _database;

  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {

    if ( _database != null ) return _database;

    _database = await initDB();

    return _database;

  }

  initDB() async {

    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join( documentsDirectory.path , 'ScansDB.db' );

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db){},
      onCreate: (Database db, version) async {
        await db.execute(
          'CREATE TABLE Scans ('
          ' id INTEGER PRIMARY KEY,'
          ' type TEXT,'
          ' value TEXT'
          ')'
        );
      }
    );

  }

  // Create new rows

  newScanRow( ScanModel scanModel ) async {

    final db = await database;

    final res = await db.rawInsert(
      "INSERT Into Scans (id, value, type) "
      "VALUES ( ${ scanModel.id }, '${ scanModel.value }', '${ scanModel.type }' )"
    );
    
    return res;
  }
  
  // Other method to create new row (this is more easy)

  newScan( ScanModel scanModel ) async {
    
    final db = await database;
    
    final res = await db.insert('Scans', scanModel.toJson());

    return res;
    
  }

  // SELECT rows

  Future<ScanModel> getScanByID ( int id) async {
    final db = await database;
    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? ScanModel.fromJson( res.first ) : null;
  }

  Future<List<ScanModel>> getAllScans () async {
    final db = await database;
    final res = await db.query('Scans');
    return res.isNotEmpty ?
      res.map( (c) => ScanModel.fromJson(c) ).toList() : [];
  }

  Future<List<ScanModel>> getScanByType ( String type) async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Scans WHERE type='$type'");
    return res.isNotEmpty ?
      res.map( (c) => ScanModel.fromJson(c) ).toList() : [];
  }

  // UPDATE ROWS

  Future<int> updateScan( ScanModel scanModel ) async {
    
    final db = await database;
    final res = await db.update('Scans', scanModel.toJson(), where: 'id = ?', whereArgs: [scanModel.id]);
    return res;
  }

  // DELETE Row

  Future<int> deleteScan( int id) async {
    final db = await database;
    final res = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteAll() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Scans');
    return res;
  }



}