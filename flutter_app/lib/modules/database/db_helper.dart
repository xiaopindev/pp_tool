import 'package:flutter_app/pp_kits/common/logger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    await initDatabase();
    return _database!;
  }

  Future<void> initDatabase() async {
    await close();
    // 获取数据库文件的路径
    String path = join(await getDatabasesPath(), 'flutter_app.db');
    //数据库存储路径
    Logger.log('数据库存储路径: $path');

    // 打开数据库，如果数据库不存在则自动创建
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  // 创建表
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE t_demo (
        uid INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        artist TEXT,
        duration INTEGER,
        album_id INTEGER,
        file_path TEXT,
        file_url TEXT,
        is_favorited INTEGER
      )
    ''');
    //在下面增加更多
  }
}
