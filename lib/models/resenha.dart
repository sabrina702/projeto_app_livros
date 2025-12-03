class Resenha {
  int? id;
  String nomeLivro;
  String descricao;
  double avaliacao;
   int idUsuario; 

  Resenha({
    this.id,
    required this.nomeLivro,
    required this.descricao,
    required this.avaliacao,
    required this.idUsuario,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nomeLivro': nomeLivro,
      'descricao': descricao,
      'avaliacao': avaliacao,
      'idUsuario': idUsuario, 
    };
  }

  static Resenha fromMap(Map<String, dynamic> map) {
    return Resenha(
      id: map['id'],
      nomeLivro: map['nomeLivro'],
      descricao: map['descricao'],
      avaliacao: map['avaliacao'],
      idUsuario: map['idUsuario'],
    );
  }
}
