import 'package:projeto_app_livros/database/db_helper.dart';
import 'package:sqflite/sqflite.dart';
import '../models/resenha.dart';

class ResenhaDAO {
  static const String tableName = 'resenha';

  // Inserir resenha
  static Future<int> insert(Resenha resenha) async {
    final Database db = await DBHelper.database;
    return await db.insert(tableName, resenha.toMap());
  }

  // Buscar todas as resenhas
  static Future<List<Resenha>> findAll() async {
    final Database db = await DBHelper.database;
    final List<Map<String, dynamic>> result = await db.query(tableName);
    return result.map((map) => Resenha.fromMap(map)).toList();
  }

  // Atualizar resenha
  static Future<int> update(Resenha resenha) async {
    final Database db = await DBHelper.database;
    return await db.update(
      tableName,
      resenha.toMap(),
      where: "id = ?",
      whereArgs: [resenha.id],
    );
  }

  // Deletar resenha
  static Future<int> delete(int id) async {
    final Database db = await DBHelper.database;
    return await db.delete(
      tableName,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // Buscar resenhas de um usuário específico
  static Future<List<Resenha>> findAllByUsuario(int idUsuario) async {
    final Database db = await DBHelper.database;
    final List<Map<String, dynamic>> result = await db.query(
      tableName,
      where: 'idUsuario = ?',
      whereArgs: [idUsuario],
    );
    return result.map((map) => Resenha.fromMap(map)).toList();
  }
}
