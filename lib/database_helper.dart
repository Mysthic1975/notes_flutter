import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'note.dart';

class DatabaseHelper {
  static const _databaseName = "notes_database.db";
  static const _databaseVersion = 1;

  static const table = 'notes';

  static const columnId = '_id';
  static const columnTitle = 'title';
  static const columnContent = 'content';

  // Singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Database reference
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Open the database
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnTitle TEXT NOT NULL,
            $columnContent TEXT NOT NULL
          )
          ''');
  }

  // Insert a note into the database
  Future<int> insert(Note note) async {
    Database db = await instance.database;
    return await db.insert(table, note.toMap());
  }

  // Get all notes from the database
  Future<List<Note>> getNotes() async {
    Database db = await instance.database;
    var notes = await db.query(table, orderBy: '$columnId ASC');
    return List.generate(notes.length, (i) {
      return Note(
        notes[i][columnTitle] as String,
        notes[i][columnContent] as String,
        id: notes[i][columnId] as int,
      );
    });
  }

  // Update a note in the database
  Future<int> update(Note note) async {
    Database db = await instance.database;
    return await db.update(table, note.toMap(),
        where: '$columnId = ?', whereArgs: [note.id]);
  }

  // Delete a note from the database
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}