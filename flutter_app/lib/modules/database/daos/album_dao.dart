import 'package:sqflite/sqflite.dart';

import '../db_helper.dart';
import '../models/album_model.dart';

class AlbumDao {
  //插入专辑
  static Future<int> insertOrReplace(AlbumModel album) async {
    final db = await DatabaseHelper().database;

    final id = await db.insert(
      't_album',
      album.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return id; // 返回自增的uid
  }

  //删除专辑前，先将所有专辑下的所有歌曲绑定的专辑ID设置为0，再删除专辑
  static Future<void> delete(int uid) async {
    final db = await DatabaseHelper().database;
    await db.update(
      't_track',
      {'album_id': 0},
      where: 'album_id = ?',
      whereArgs: [uid],
    );
    await db.delete(
      't_album',
      where: 'uid = ?',
      whereArgs: [uid],
    );
  }

  static Future<void> deleteAll() async {
    final db = await DatabaseHelper().database;
    await db.delete('t_album');
  }

  //更新专辑
  static Future<void> update(AlbumModel album) async {
    final db = await DatabaseHelper().database;
    await db.update(
      't_album',
      album.toMap(),
      where: 'uid = ?',
      whereArgs: [album.uid],
    );
  }

  //获取所有专辑
  static Future<List<AlbumModel>> queryAll() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(
      't_album',
      orderBy: 'uid DESC',
    );
    return List.generate(maps.length, (i) {
      return AlbumModel.fromMap(maps[i]);
    });
  }

  //获取所有专辑
  static Future<List<AlbumModel>> queryAllByName(String name) async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(
      't_album',
      where: 'name LIKE ?',
      whereArgs: ['%$name%'],
      orderBy: 'uid DESC',
    );
    return List.generate(maps.length, (i) {
      return AlbumModel.fromMap(maps[i]);
    });
  }

  //通过ID获取专辑对象
  static Future<AlbumModel?> queryById(int? uid) async {
    if (uid == null) {
      return null;
    }
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(
      't_album',
      where: 'uid = ?',
      whereArgs: [uid],
    );
    if (maps.isNotEmpty) {
      return AlbumModel.fromMap(maps.first);
    }
    return null;
  }

  //通过名称获取专辑对象
  static Future<AlbumModel?> queryByName(String? name) async {
    if (name == null) {
      return null;
    }
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(
      't_album',
      where: 'name = ?',
      whereArgs: [name],
    );
    if (maps.isNotEmpty) {
      return AlbumModel.fromMap(maps.first);
    }
    return null;
  }
}
