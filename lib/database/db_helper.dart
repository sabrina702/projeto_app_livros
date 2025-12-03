import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;

  // Nome do banco
  static const String _dbName = 'livros.db';
  static const int _dbVersion = 1;

  // Tabela livros
  static const String tableBooks = 'books';
  static const String colId = 'id';
  static const String colTitle = 'title';
  static const String colAuthor = 'author';
  static const String colPages = 'pages';
  static const String colStatus = 'status';

  // Getter para o banco
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Inicializar banco
  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  // Criar tabelas
  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableBooks(
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colTitle TEXT NOT NULL,
        $colAuthor TEXT NOT NULL,
        $colPages INTEGER NOT NULL,
        $colStatus TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE resenha (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nomeLivro TEXT NOT NULL,
        descricao TEXT NOT NULL,
        avaliacao REAL NOT NULL
      );
    ''');
  }

  // CRUD básico:

  // Inserir livro
  static Future<int> insertBook(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(tableBooks, row);
  }

  // Buscar todos os livros
  static Future<List<Map<String, dynamic>>> getBooks() async {
    Database db = await database;
    return await db.query(tableBooks);
  }

  // Atualizar livro
  static Future<int> updateBook(Map<String, dynamic> row) async {
    Database db = await database;
    int id = row[colId];
    return await db.update(tableBooks, row, where: '$colId = ?', whereArgs: [id]);
  }

  // Deletar livro
  static Future<int> deleteBook(int id) async {
    Database db = await database;
    return await db.delete(tableBooks, where: '$colId = ?', whereArgs: [id]);
  }
}
