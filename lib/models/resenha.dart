class Resenha {
  int? id;
  String nomeLivro;
  String descricao;
  double avaliacao;

  Resenha({
    this.id,
    required this.nomeLivro,
    required this.descricao,
    required this.avaliacao,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nomeLivro': nomeLivro,
      'descricao': descricao,
      'avaliacao': avaliacao,
    };
  }

  static Resenha fromMap(Map<String, dynamic> map) {
    return Resenha(
      id: map['id'],
      nomeLivro: map['nomeLivro'],
      descricao: map['descricao'],
      avaliacao: map['avaliacao'],
    );
  }
}
