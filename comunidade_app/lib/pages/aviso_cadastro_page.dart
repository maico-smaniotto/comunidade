import 'package:comunidade_app/models/aviso.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class AvisoCadastroPage extends StatefulWidget {
  final Aviso? aviso;
  
  const AvisoCadastroPage({super.key, this.aviso});  

  @override
  State<AvisoCadastroPage> createState() => _AvisoCadastroPageState();
}

class _AvisoCadastroPageState extends State<AvisoCadastroPage> {

  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  DateTime? _validadeSelecionada;
  bool _salvando = false;

  bool get isEdicao => widget.aviso != null;

  @override
  void initState() {    
    super.initState();
    if (isEdicao) {
      _tituloController.text = widget.aviso!.titulo;
      _descricaoController.text = widget.aviso!.descricao;
      _validadeSelecionada = widget.aviso!.validade;
    }
  }

  Future<void> _enviarAviso() async {
    if (!_formKey.currentState!.validate() || _validadeSelecionada == null) return;

    setState(() {
      _salvando = true;
    });

    final aviso = Aviso(
      id: widget.aviso?.id, 
      cadastro: widget.aviso?.cadastro, 
      validade: _validadeSelecionada!, 
      titulo: _tituloController.text, 
      descricao: _descricaoController.text
    );

    final url = isEdicao
      ? 'http://10.0.2.2:8081/api/avisos/${aviso.id}'
      : 'http://10.0.2.2:8081/api/avisos';

    final response = isEdicao
      ? await http.put(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(aviso.toJson()),
        )
      : await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(aviso.toJson()),
        );

    // Após o await verificar se o widget ainda está na árvore, pois já pode ter sido destruído
    // e poderia ocorrer erro ao no setSate() ou ao acessar o context
    if (!mounted) return;

    setState(() {
      _salvando = false;
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Aviso salvo com sucesso.')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao cadastrar: ${response.body}')),
      );
    }

  }

  Future<void> _selecionarDataValidade() async {
    final data = await showDatePicker(
      context: context, 
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(), 
      lastDate: DateTime.now().add(const Duration(days: 365))
    );
    if (data != null) {
      setState(() {
        _validadeSelecionada = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEdicao ? "Editar Aviso" : "Novo Aviso"),),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) => value == null || value.isEmpty ? 'Informe o Título' : null,
              ),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                maxLines: 10,
              ),
              const SizedBox(height: 16,),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _validadeSelecionada == null
                      ? 'Validade: não informada'
                      : 'Validade: ${DateFormat('dd/MM/yyyy', 'pt_BR').format(_validadeSelecionada!)}'                      
                    )
                  ),
                  TextButton.icon(
                    onPressed: _selecionarDataValidade, 
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('Selecionar'),
                  )
                ],
              ),
              const SizedBox(height: 20,),
              ElevatedButton.icon(
                onPressed: _salvando ? null : _enviarAviso,
                icon: Icon(isEdicao ? Icons.save : Icons.send),
                label: Text('Salvar'),
              )
            ],
          )
        ),
      ),
    );
  }
}