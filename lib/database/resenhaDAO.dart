import 'package:projeto_app_livros/database/db_helper.dart';
import 'package:sqflite/sqflite.dart';
import '../models/resenha.dart';

class ResenhaDAO {
  static const String tableName = 'resenha';

  static Future<int> insert(Resenha resenha) async {
    final Database db = await DBHelper.database;
    return await db.insert(tableName, resenha.toMap());
  }

  static Future<List<Resenha>> findAll() async {
    final Database db = await DBHelper.database;
    final List<Map<String, dynamic>> result = await db.query(tableName);

    return result.map((map) => Resenha.fromMap(map)).toList();
  }

  static Future<int> update(Resenha resenha) async {
    final Database db = await DBHelper.database;
    return await db.update(
      tableName,
      resenha.toMap(),
      where: "id = ?",
      whereArgs: [resenha.id],
    );
  }

  static Future<int> delete(int id) async {
    final Database db = await DBHelper.database;
    return await db.delete(
      tableName,
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
