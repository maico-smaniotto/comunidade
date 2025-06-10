class Aviso {
  final String id;
  final DateTime cadastro;
  final DateTime validade;
  final String titulo;
  final String descricao;

  Aviso({
    required this.id,
    required this.cadastro,
    required this.validade,
    required this.titulo,
    required this.descricao
  });

  factory Aviso.fromJson(Map<String, dynamic> json) {
    return Aviso(
      id: json['id'], 
      cadastro: DateTime.parse(json['cadastro']), 
      validade: DateTime.parse(json['validade']), 
      titulo: json['titulo'], 
      descricao: json['descricao'],
    );
  }

}