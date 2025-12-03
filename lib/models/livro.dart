class Livro {
  int? id;
  String titulo;
  String autor;
  int paginas;
  String status;
  int idUsuario; // NOVO

  Livro({
    this.id,
    required this.titulo,
    required this.autor,
    required this.paginas,
    required this.status,
    required this.idUsuario,
  });

  // Converter objeto para Map (para salvar no banco)
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'title': titulo,
      'author': autor,
      'pages': paginas,
      'status': status,
      'idUsuario': idUsuario, // NOVO
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  // Converter Map do banco para objeto
  factory Livro.fromMap(Map<String, dynamic> map) {
    return Livro(
      id: map['id'],
      titulo: map['title'],
      autor: map['author'],
      paginas: map['pages'],
      status: map['status'],
      idUsuario: map['idUsuario'], // NOVO
    );
  }
}
