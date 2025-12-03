import 'package:projeto_app_livros/database/db_helper.dart';
import '../models/livro.dart';

class LivroDAO {
  /// Insere um livro no banco de dados
  static Future<int> insert(Livro livro) async {
    try {
      return await DBHelper.insertBook(livro.toMap());
    } catch (e) {
      print("Erro ao inserir livro: $e");
      return -1; // Código de erro
    }
  }

  /// Retorna todos os livros cadastrados
  static Future<List<Livro>> getAll() async {
    try {
      final result = await DBHelper.getBooks();
      return result.map((data) => Livro.fromMap(data)).toList();
    } catch (e) {
      print("Erro ao buscar livros: $e");
      return [];
    }
  }

  /// Atualiza os dados de um livro
  static Future<int> update(Livro livro) async {
    try {
      return await DBHelper.updateBook(livro.toMap());
    } catch (e) {
      print("Erro ao atualizar livro: $e");
      return -1;
    }
  }

  /// Deleta um livro com base no ID
  static Future<int> delete(int id) async {
    try {
      return await DBHelper.deleteBook(id);
    } catch (e) {
      print("Erro ao deletar livro: $e");
      return -1;
    }
  }

  /// Retorna livros filtrando pelo usuário logado
  static Future<List<Livro>> getAllByUsuario(int idUsuario) async {
    final db = await DBHelper.database;
    final result = await db.query(
      DBHelper.tableBooks,
      where: 'idUsuario = ?',
      whereArgs: [idUsuario],
    );
    return result.map((map) => Livro.fromMap(map)).toList();
  }
}
