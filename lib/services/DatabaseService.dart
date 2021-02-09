import 'package:munchkin_counter/models/Player.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  var databasesPath;
  String path;
  Database database;

  static final String TABLE_NAME = "Players";
  void initDatabase() async {
    databasesPath = await getDatabasesPath();
    path = join(databasesPath, 'players.db');
    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE $TABLE_NAME (id INTEGER PRIMARY KEY, name TEXT, level INTEGER, stuff INTEGER, sex INTEGER, color INTEGER, gameName TEXT)');
    });
  }

  Future<int> addPlayer(MyPlayer player) async {
    database = await openDatabase(path);
    var result = await database.insert(
      TABLE_NAME,
      player.toMap(),
    );

    return result;
  }

  Future<int> getCount() async {
    database = await openDatabase(path);
    var count = Sqflite.firstIntValue(
        await database.rawQuery('SELECT COUNT(*) FROM $TABLE_NAME'));

    return count;
  }

  Future<List<Map<String, dynamic>>> getbyGame(String game) async {
    List<Map<String, dynamic>> result = [];
    result = await database.query(TABLE_NAME,
        columns: null, where: 'gameName = ?', whereArgs: [game]);

    return result;
  }

  Future<int> removePlayer(int id) {
    return database.delete(TABLE_NAME, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updatePlayer(MyPlayer player) {
    return database.update(TABLE_NAME, player.toMap(),
        where: "id = ?", whereArgs: [player.id]);
  }
}
