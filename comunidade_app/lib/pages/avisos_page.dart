import 'package:comunidade_app/models/aviso.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AvisosPage extends StatefulWidget {
  const AvisosPage({super.key});

  @override
  State<AvisosPage> createState() => _AvisosPageState();
}

class _AvisosPageState extends State<AvisosPage> {
  List<Aviso> avisos = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    carregarAvisos();
  }

  Future<void> carregarAvisos() async {
    try {
      
      final response = await http.get(Uri.parse('http://10.0.2.2:8081/api/avisos'));      
      if (response.statusCode != 200) {
        throw Exception('Não foi possível buscar avisos');        
      }

      final List<dynamic> dados = json.decode(response.body);
      setState(() {
        avisos = dados.map((e) => Aviso.fromJson(e)).toList();
        loading = false;
      });
      
    } catch (e) {      
      if (kDebugMode) {
        debugPrint('Erro: $e');
      }
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avisos'),
      ),
      body: loading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
          itemCount: avisos.length,
          itemBuilder: (context, index) {
            final aviso = avisos[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(aviso.titulo),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(aviso.descricao),
                    const SizedBox(height: 4),
                    Text(
                      'Válido até: ${aviso.validade.toLocal().toString().split(" ")[0]}',
                      style: const TextStyle(fontSize: 12),
                    )
                  ],
                ),
              ),
            );
          },
        ),
    );
  }

}