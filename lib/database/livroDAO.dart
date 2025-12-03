import 'package:projeto_app_livros/database/db_helper.dart';
import '../models/livro.dart';

class LivroDAO {
  // Inserir livro
  static Future<int> insert(Livro livro) async {
    try {
      return await DBHelper.insertBook(livro.toMap());
    } catch (e) {
      // Retorna -1 em caso de erro
      print("Erro ao inserir livro: $e");
      return -1;
    }
  }

  // Buscar todos os livros
  static Future<List<Livro>> getAll() async {
    try {
      final result = await DBHelper.getBooks();
      return result.map((map) => Livro.fromMap(map)).toList();
    } catch (e) {
      print("Erro ao buscar livros: $e");
      return [];
    }
  }

  // Atualizar livro
  static Future<int> update(Livro livro) async {
    try {
      return await DBHelper.updateBook(livro.toMap());
    } catch (e) {
      print("Erro ao atualizar livro: $e");
      return -1;
    }
  }

  // Deletar livro
  static Future<int> delete(int id) async {
    try {
      return await DBHelper.deleteBook(id);
    } catch (e) {
      print("Erro ao deletar livro: $e");
      return -1;
    }
  }
}
