import 'package:comunidade_app/models/aviso.dart';
import 'package:comunidade_app/pages/aviso_cadastro_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart';

class AvisosPage extends StatefulWidget {
  final bool isAdmin;

  const AvisosPage({super.key, required this.isAdmin});

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
      
      final response = await http.get(Uri.parse('${AppConfig.apiBaseUrl}/avisos'));      
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

  void _abrirCadastro(BuildContext context, {Aviso? aviso}) {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => AvisoCadastroPage(
          aviso: aviso,
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avisos'),
        actions: [
          if (widget.isAdmin)
            IconButton(
              onPressed: () => _abrirCadastro(context), 
              icon: const Icon(Icons.add),
              tooltip: 'Novo Aviso',
            )
        ],
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
                trailing: widget.isAdmin
                  ? IconButton(
                      onPressed: () => _abrirCadastro(context, aviso: aviso), 
                      icon: const Icon(Icons.edit),
                    )
                  : null,
              ),
            );
          },
        ),
    );
  }

}