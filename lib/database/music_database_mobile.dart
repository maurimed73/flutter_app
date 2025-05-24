import 'dart:convert';
import 'package:flutter_app/models/music_class_server.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class MusicDatabaseMobile {
  static final MusicDatabaseMobile instance = MusicDatabaseMobile._init();
  static Database? _database;

  MusicDatabaseMobile._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('music.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, fileName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE musics (
        title TEXT PRIMARY KEY,
        imageUrl TEXT,
        description TEXT,
        pdfUrl TEXT,
        linkUrl TEXT,
        backs TEXT
      )
    ''');
  }

  Future<void> insertMusic(MusicServer music) async {
    final db = await instance.database;
    await db.insert(
      'musics',
      music.toMap()..['backs'] = jsonEncode(music.backs),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<MusicServer>> getAllMusics() async {
    final db = await instance.database;
    final result = await db.query('musics');

    return result.map((map) {
      final backsString = map['backs'];
      return MusicServer.fromMap({
        ...map,
        'backs': backsString is String ? jsonDecode(backsString) : {},
      });
    }).toList();
  }

  Future<void> deleteAllMusics() async {
    final db = await instance.database;
    await db.delete('musics');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<bool> isMusicDownloaded(String title) async {
    final db = await instance.database;
    final result = await db.query(
      'musics',
      where: 'title = ?',
      whereArgs: [title],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<void> deleteMusicByTitle(String title) async {
    final db = await instance.database;

    await db.delete(
      'musics',
      where: 'title = ?',
      whereArgs: [title],
    );
  }
}
