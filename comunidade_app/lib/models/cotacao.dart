class Cotacao {

  final String id;
  final DateTime data;
  final String cooperativa;
  final String produto;
  final double preco;
  final DateTime atualizado;

  Cotacao({
    required this.id,
    required this.data,
    required this.cooperativa,
    required this.produto,
    required this.preco,
    required this.atualizado
  });

  factory Cotacao.fromJson(Map<String, dynamic> json) {
    return Cotacao(
      id: json['id'], 
      data: DateTime.parse(json['data']), 
      cooperativa: json['cooperativa'], 
      produto: json['produto'], 
      preco: json['preco'], 
      atualizado: DateTime.parse(json['atualizado'])
    );
  }

}