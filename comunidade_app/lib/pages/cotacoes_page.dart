import 'package:comunidade_app/models/cotacao.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CotacoesPage extends StatefulWidget {
  const CotacoesPage({super.key});

  @override
  State<CotacoesPage> createState() => _CotacoesPageState();
}

class _CotacoesPageState extends State<CotacoesPage> {
  Map<String, List<Cotacao>> cotacoesPorCooperativa = {};
  bool loading = true;

  @override
  void initState() {    
    super.initState();
    carregarCotacoes();
  }

  Future<void> carregarCotacoes() async {
    try {
      
      final response = await http.get(Uri.parse('http://10.0.2.2:8081/api/cotacoes'));
      if (response.statusCode != 200) {
        throw Exception('Não foi possível buscar cotações');
      }

      final List<dynamic> dados = json.decode(response.body);
      List<Cotacao> cotacoes = dados.map((e) => Cotacao.fromJson(e)).toList();

      final agrupado = <String, List<Cotacao>>{};
      for (var c in cotacoes) {
        agrupado.putIfAbsent(c.cooperativa, () => []).add(c);
      }
      setState(() {
        cotacoesPorCooperativa = agrupado;
        loading = false;
      });
    } catch (e) {
      print('Erro: $e');
      setState(() {
        loading = false;
      });
    }
  }

  String obterIcone(String produto) {
    if (produto.toLowerCase().contains('soja')) {
      return '🌱 '; 
    }
    if (produto.toLowerCase().contains('milho')) {
      return '🌽 '; 
    }
    if (produto.toLowerCase().contains('trigo')) {
      return '🌾 '; 
    }
    return '  ';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cotações'),
      ),
      body: loading
        ? const Center(child: CircularProgressIndicator(),)
        : ListView(
          children: cotacoesPorCooperativa.entries.map((entry) {
              return Card(
                margin: const EdgeInsets.all(10),
                child: ExpansionTile(
                  title: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold)),
                  initiallyExpanded: true,
                  children: entry.value.map((cotacao) {
                    return ListTile(
                      title: Text(obterIcone(cotacao.produto) + '${cotacao.produto} - R\$ ${cotacao.preco.toStringAsFixed(2)}'),
                      subtitle: Text('Atualizado em ${DateFormat('dd/MM/yyyy hh:mm').format(cotacao.atualizado.toLocal())}'),
                    );
                  }).toList(),
                ),
              );
            }).toList(),
        ),
    );    
  }
  

}