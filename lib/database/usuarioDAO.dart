import 'package:projeto_app_livros/database/db_helper.dart';
import 'package:projeto_app_livros/models/usuario.dart';
import 'package:sqflite/sqflite.dart';

class UsuarioDAO {
  // Inserir novo usuário
  static Future<int> inserirUsuario(Usuario usuario) async {
    final db = await DBHelper.database;

    return await db.insert(
      DBHelper.tableUsers,
      usuario.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Buscar usuário pelo email (para verificar se já existe)
  static Future<Usuario?> buscarPorEmail(String email) async {
    final db = await DBHelper.database;

    final result = await db.query(
      DBHelper.tableUsers,
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      return Usuario.fromMap(result.first);
    }
    return null;
  }

  // Login: verificar email + senha
  static Future<Usuario?> login(String email, String senha) async {
    final db = await DBHelper.database;

    final result = await db.query(
      DBHelper.tableUsers,
      where: 'email = ? AND senha = ?',
      whereArgs: [email, senha],
    );

    if (result.isNotEmpty) {
      return Usuario.fromMap(result.first);
    }
    return null;
  }

  // Buscar todos os usuários (opcional)
  static Future<List<Usuario>> getUsuarios() async {
    final db = await DBHelper.database;

    final result = await db.query(DBHelper.tableUsers);

    return result.map((e) => Usuario.fromMap(e)).toList();
  }

  // Atualizar usuário
  static Future<int> atualizarUsuario(Usuario usuario) async {
    final db = await DBHelper.database;

    return await db.update(
      DBHelper.tableUsers,
      usuario.toMap(),
      where: 'id = ?',
      whereArgs: [usuario.id],
    );
  }

  // Deletar usuário
  static Future<int> deletarUsuario(int id) async {
    final db = await DBHelper.database;

    return await db.delete(
      DBHelper.tableUsers,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
