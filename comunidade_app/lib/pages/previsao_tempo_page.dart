import 'package:comunidade_app/models/clima.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PrevisaoTempoPage extends StatefulWidget {
  const PrevisaoTempoPage({super.key});

  @override
  State<StatefulWidget> createState() => _PrevisaoTempoPageState();
}

class _PrevisaoTempoPageState extends State<PrevisaoTempoPage> {
  ClimaAtual? climaAtual;
  PrevisaoDia? previsaoDia;
  List<PrevisaoHora> horas = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarPrevisao();
  }

  Future<void> carregarPrevisao() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8081/api/tempo'));

      if (response.statusCode != 200) {
        throw Exception('Não foi possível buscar a previsão do tempo');
      }

      final data = json.decode(response.body);

      final atual = ClimaAtual.fromJson(data['current']);
      final dia = PrevisaoDia.fromJson(data['forecast']['forecastday'][0]);
      final listaHoras = (data['forecast']['forecastday'][0]['hour'] as List)
        .map((e) => PrevisaoHora.fromJson(e))
        .toList();

      setState(() {
        climaAtual = atual;
        previsaoDia = dia;
        horas = listaHoras;
        carregando = false;
      });  
    } catch (e) {
      print('Erro: $e');
      setState(() {
        carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Previsão do Tempo'),),
      body: carregando
        ? const Center(child: CircularProgressIndicator())
        : climaAtual == null
          ? const Center(child: Text('Erro ao carregar dados'))
          : Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Agora', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(climaAtual!.condicao.icone),
                    const SizedBox(width: 10),
                    Column(
                      children: [
                        Text('${climaAtual!.tempC.toStringAsFixed(1)}°C', style: const TextStyle(fontSize: 32)),
                        Text(climaAtual!.condicao.texto),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Text('Hoje', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(previsaoDia!.condicao.icone),
                    const SizedBox(width: 10),
                    Column(
                      children: [
                        Text('Mín: ${previsaoDia!.minTemp}°C'),
                        Text('Máx: ${previsaoDia!.maxTemp}°C'),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Text('Próximas horas', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: horas.length,
                    itemBuilder: (_, i) {
                      final h = horas[i];
                      return Container(
                        width: 90,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(h.hora, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Image.network(h.condicao.icone),
                            Text('${h.temp.toStringAsFixed(1)}°C'),
                          ],
                        ),
                      );
                    },
                  )
                )
              ],
            ),
          )
    );
  }
}