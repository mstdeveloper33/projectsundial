import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/journal_entry_model.dart';

class SQLiteService {
  Database? _database;

  Future<void> init() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'journal.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE journal_entries(id INTEGER PRIMARY KEY AUTOINCREMENT, text TEXT, mood TEXT, date TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> saveJournalEntry(JournalEntry entry) async {
    if (entry.id == null) {
      await _database?.insert(
        'journal_entries',
        entry.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      await _database?.update(
        'journal_entries',
        entry.toJson(),
        where: 'id = ?',
        whereArgs: [entry.id],
      );
    }
  }

  Future<List<JournalEntry>> getJournalEntries() async {
    final List<Map<String, dynamic>> maps = await _database?.query('journal_entries') ?? [];
    return List.generate(maps.length, (i) {
      return JournalEntry.fromJson(maps[i]);
    });
  }

  Future<void> deleteJournalEntry(int id) async {
    await _database?.delete(
      'journal_entries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
