import 'package:PadsBuga/models/music_class_server.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class KitDatabaseMobile {
  static final KitDatabaseMobile instance = KitDatabaseMobile._init();
  static Database? _database;

  KitDatabaseMobile._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('padsbuga.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, fileName);

    return await openDatabase(path, version: 3, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE kit (
        title TEXT PRIMARY KEY,
        imageUrl TEXT,
        description TEXT,
        refstorage TEXT,
        sound1Nome TEXT,
        sound2Nome TEXT,
        sound3Nome TEXT,
        sound4Nome TEXT,
        sound1Patch TEXT,
        sound2Patch TEXT,
        sound3Patch TEXT,
        sound4Patch TEXT,
        sound1Volume REAL,
        sound2Volume REAL,
        sound3Volume REAL,
        sound4Volume REAL,
        isLoop1 INTEGER,
        isLoop2 INTEGER,
        isLoop3 INTEGER,
        isLoop4 INTEGER
      )
    ''');
  }

  Future<void> insertMusic(KitServer music) async {
    final db = await instance.database;
    await db.insert(
      'kit',
      music.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<KitServer>> getAllMusics() async {
    final db = await instance.database;
    final result = await db.query('kit');

    return result.map((map) {
      return KitServer.fromJson({
        ...map,
      });
    }).toList();
  }

  Future<void> deleteAllMusics() async {
    final db = await instance.database;
    await db.delete('kit');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<bool> isMusicDownloaded(String title) async {
    final db = await instance.database;
    final result = await db.query(
      'kit',
      where: 'title = ?',
      whereArgs: [title],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<void> deleteMusicByTitle(String title) async {
    final db = await instance.database;

    await db.delete(
      'kit',
      where: 'title = ?',
      whereArgs: [title],
    );
    print(db.path.contains('isLoop'));
  }

  Future<void> updateMusicParam({
    required String title,
    required String campo,
    required dynamic valor,
  }) async {
    final db = await instance.database;

    await db.update(
      'kit',
      {campo: valor},
      where: 'title = ?',
      whereArgs: [title],
    );
  }
}
