import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Todo {
  int id;
  String itemid;
  String messageType;

  Todo({this.id, this.itemid ,this.messageType});

  Map<String, dynamic> toMap() {
    return {'id': id, 'item_id': itemid, 'message_type': messageType};
  }
}


class DatabaseHelper {
  static final _databaseName = "notificDB.db";
  static final _databaseVersion = 1;

  static final table = 'notifications_table';
  static final columnId = 'id';
  static final columnitemId = 'item_id';
  static final columnTitle = 'message_type';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnitemId FLOAT NOT NULL,
            $columnTitle FLOAT NOT NULL
          )
          ''');
  }

  Future<int> insert(Todo todo) async {
    Database db = await instance.database;
    var res = await db.insert(table, todo.toMap());
    print('RETURN INSERT'+res.toString());
    return res;
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    var res = await db.query(table, orderBy: "$columnId DESC");
    return res;
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnitemId = ?', whereArgs: [id]);
  }

  Future clearTable() async {
    Database db = await instance.database;
    return await db.rawQuery("DELETE FROM $table");
  }
}

