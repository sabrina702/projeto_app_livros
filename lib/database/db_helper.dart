import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;

  // Nome e versão do banco
  static const String _dbName = 'livros.db';
  static const int _dbVersion = 3;

  // ---------- TABELA LIVROS ----------
  static const String tableBooks = 'books';
  static const String colId = 'id';
  static const String colTitle = 'title';
  static const String colAuthor = 'author';
  static const String colPages = 'pages';
  static const String colStatus = 'status';
  static const String colUserId = 'idUsuario';

  // ---------- TABELA USUÁRIOS ----------
  static const String tableUsers = 'usuarios';
  static const String colUserName = 'nome';
  static const String colUserEmail = 'email';
  static const String colUserPassword = 'senha';

  // ---------- TABELA RESENHAS ----------
  static const String tableResenha = 'resenha';

  // ---------- GET DATABASE ----------
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
      onUpgrade: _onUpgrade,
    );
  }

  // Criar tabelas
  static Future<void> _onCreate(Database db, int version) async {
    // TABELA LIVROS
    await db.execute('''
      CREATE TABLE $tableBooks(
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colTitle TEXT NOT NULL,
        $colAuthor TEXT NOT NULL,
        $colPages INTEGER NOT NULL,
        $colStatus TEXT NOT NULL,
        $colUserId INTEGER NOT NULL
      )
    ''');

    // TABELA RESENHAS
    await db.execute('''
      CREATE TABLE $tableResenha(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nomeLivro TEXT NOT NULL,
        descricao TEXT NOT NULL,
        avaliacao REAL NOT NULL,
        idUsuario INTEGER NOT NULL
      )
    ''');

    // TABELA USUÁRIOS
    await db.execute('''
      CREATE TABLE $tableUsers(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        $colUserName TEXT NOT NULL,
        $colUserEmail TEXT NOT NULL UNIQUE,
        $colUserPassword TEXT NOT NULL
      )
    ''');
  }

  // Atualizar banco quando aumentar versão
  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Cria tabela usuários se não existia
      await db.execute('''
        CREATE TABLE IF NOT EXISTS $tableUsers(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          $colUserName TEXT NOT NULL,
          $colUserEmail TEXT NOT NULL UNIQUE,
          $colUserPassword TEXT NOT NULL
        )
      ''');
    }

    if (oldVersion < 3) {
      // Adiciona coluna idUsuario em books
      await db.execute('''
        ALTER TABLE $tableBooks ADD COLUMN $colUserId INTEGER NOT NULL DEFAULT 1
      ''');

      // Adiciona coluna idUsuario em resenha
      await db.execute('''
        ALTER TABLE $tableResenha ADD COLUMN idUsuario INTEGER NOT NULL DEFAULT 1
      ''');
    }
  }

  // --------- CRUD LIVROS -----------
  static Future<int> insertBook(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert(tableBooks, row);
  }

  static Future<List<Map<String, dynamic>>> getBooks() async {
    final db = await database;
    return await db.query(tableBooks);
  }

  static Future<int> updateBook(Map<String, dynamic> row) async {
    final db = await database;
    int id = row[colId];
    return await db.update(
      tableBooks,
      row,
      where: '$colId = ?',
      whereArgs: [id],
    );
  }

  static Future<int> deleteBook(int id) async {
    final db = await database;
    return await db.delete(
      tableBooks,
      where: '$colId = ?',
      whereArgs: [id],
    );
  }

  // --------- CRUD USUÁRIOS -----------
  static Future<int> insertUser(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert(tableUsers, row);
  }

  static Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query(tableUsers);
  }

  static Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final result = await db.query(
      tableUsers,
      where: '$colUserEmail = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty ? result.first : null;
  }

  static Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete(
      tableUsers,
      where: '$colId = ?',
      whereArgs: [id],
    );
  }

  // --------- CRUD RESENHAS -----------
  static Future<int> insertResenha(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert(tableResenha, row);
  }

  static Future<List<Map<String, dynamic>>> getResenhas() async {
    final db = await database;
    return await db.query(tableResenha);
  }

  static Future<int> updateResenha(Map<String, dynamic> row) async {
    final db = await database;
    int id = row['id'];
    return await db.update(
      tableResenha,
      row,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> deleteResenha(int id) async {
    final db = await database;
    return await db.delete(
      tableResenha,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
