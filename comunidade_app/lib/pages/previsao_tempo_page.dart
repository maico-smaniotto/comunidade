import 'package:comunidade_app/models/clima.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import '../config.dart';

class PrevisaoTempoPage extends StatefulWidget {
  const PrevisaoTempoPage({super.key});

  @override
  State<StatefulWidget> createState() => _PrevisaoTempoPageState();
}

class _PrevisaoTempoPageState extends State<PrevisaoTempoPage> {
  ClimaAtual? climaAtual;

  PrevisaoDia? previsaoHoje;
  List<PrevisaoHora> horasHoje = [];
  
  PrevisaoDia? previsaoAmanha;
  List<PrevisaoHora> horasAmanha = [];
  
  PrevisaoDia? previsaoDepoisDeAmanha;
  List<PrevisaoHora> horasDepoisDeAmanha = [];

  final ScrollController _scrollControllerHoje = ScrollController();
  final ScrollController _scrollControllerAmanhaEDepois = ScrollController();
  static const double itemHorarioLargura = 90;
  static const double itemHorarioMargem = 5;

  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarPrevisao();
  }

  @override
  void dispose() {
    _scrollControllerHoje.dispose();
    super.dispose();
  }

  Future<void> carregarPrevisao() async {
    try {
      final response = await http.get(Uri.parse('${AppConfig.apiBaseUrl}/tempo'));

      if (response.statusCode != 200) {
        throw Exception('Não foi possível buscar a previsão do tempo');
      }

      final data = json.decode(response.body);

      final atual = ClimaAtual.fromJson(data['current']);
      final hoje = PrevisaoDia.fromJson(data['forecast']['forecastday'][0]);
      final listaHorasHoje = (data['forecast']['forecastday'][0]['hour'] as List)
        .map((e) => PrevisaoHora.fromJson(e))
        .toList();
      final amanha = PrevisaoDia.fromJson(data['forecast']['forecastday'][1]);
      final listaHorasAmanha = (data['forecast']['forecastday'][1]['hour'] as List)
        .map((e) => PrevisaoHora.fromJson(e))
        .toList();

      final depoisDeAmanha = PrevisaoDia.fromJson(data['forecast']['forecastday'][2]);
      final listaHorasDepoisDeAmanha = (data['forecast']['forecastday'][2]['hour'] as List)
        .map((e) => PrevisaoHora.fromJson(e))
        .toList();

      setState(() {
        climaAtual = atual;
        previsaoHoje = hoje;
        horasHoje = listaHorasHoje;
        previsaoAmanha = amanha;
        horasAmanha = listaHorasAmanha;
        previsaoDepoisDeAmanha = depoisDeAmanha;
        horasDepoisDeAmanha = listaHorasDepoisDeAmanha;
        carregando = false;
      });

      // Espera o primeiro frame ser renderizado + atraso de alguns ms para então rolar a lista posicionando na hora desejada
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration(milliseconds: 100), () {

          if (_scrollControllerHoje.hasClients) {
            // Posiciona na hora atual
            final agora = DateTime.now();
            final posicaoHora = agora.hour;

            _scrollControllerHoje.animateTo(
              posicaoHora * (itemHorarioLargura + itemHorarioMargem * 2),
              duration: Duration(milliseconds: 500),
              curve: Curves.easeOut,
            );
          }

          if (_scrollControllerAmanhaEDepois.hasClients) {
            // Posiciona às 7 da manhã
            final posicaoHora = 7;

            _scrollControllerAmanhaEDepois.jumpTo(
              posicaoHora * (itemHorarioLargura + itemHorarioMargem * 2),
            );
          }
        });
      }); 
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Erro: $e');
      }
      setState(() {
        carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String diaDeHojeExtenso = previsaoHoje != null 
      ? 'Hoje, ${DateFormat('dd \'de\' MMMM', 'pt_BR').format(previsaoHoje!.data.toLocal())}' 
      : '';
    String diaDeAmanhaExtenso = previsaoAmanha != null
      ? 'Amanhã, ${DateFormat('dd \'de\' MMMM', 'pt_BR').format(previsaoAmanha!.data.toLocal())}'
      : '';
    String diaDepoisDeAmanhaExtenso = previsaoDepoisDeAmanha != null
      ? DateFormat('EEEE, dd \'de\' MMMM', 'pt_BR').format(previsaoDepoisDeAmanha!.data)
      : '';
    if (diaDepoisDeAmanhaExtenso != '') {
      diaDepoisDeAmanhaExtenso = diaDepoisDeAmanhaExtenso[0].toUpperCase() + diaDepoisDeAmanhaExtenso.substring(1);
    }    

    return Scaffold(
      appBar: AppBar(title: const Text('Previsão do Tempo'),),
      body: carregando
        ? const Center(child: CircularProgressIndicator())
        : climaAtual == null
          ? const Center(child: Text('Erro ao carregar dados'))
          : Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [                
                  Text('Agora', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Container(
                    width: 360,
                    margin: const EdgeInsets.symmetric(horizontal: 45),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),                      
                    ),
                    child: Row(
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
                    )
                  ),
                  
                  // Dia de Hoje
                  const SizedBox(height: 30),
                  Text(diaDeHojeExtenso, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(previsaoHoje!.condicao.icone),
                      const SizedBox(width: 10),
                      Column(
                        children: [
                          Text('Mín: ${previsaoHoje!.minTemp}°C'),
                          Text('Máx: ${previsaoHoje!.maxTemp}°C'),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('De hora em hora', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      controller: _scrollControllerHoje,
                      scrollDirection: Axis.horizontal,
                      itemCount: horasHoje.length,
                      itemBuilder: (_, i) {
                        final h = horasHoje[i];
                        return Container(
                          height: 180,
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
                    ).build(context)
                  ),

                  // Dia de Amanhã
                  const SizedBox(height: 30),
                  Text(diaDeAmanhaExtenso, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(previsaoAmanha!.condicao.icone),
                      const SizedBox(width: 10),
                      Column(
                        children: [
                          Text('Mín: ${previsaoAmanha!.minTemp}°C'),
                          Text('Máx: ${previsaoAmanha!.maxTemp}°C'),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('De hora em hora', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      controller: _scrollControllerAmanhaEDepois,
                      scrollDirection: Axis.horizontal,
                      itemCount: horasAmanha.length,
                      itemBuilder: (_, i) {
                        final h = horasAmanha[i];
                        return Container(
                          height: 180,
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
                    ).build(context)
                  ),

                  // Depois de Amanhã
                  const SizedBox(height: 30),
                  Text(diaDepoisDeAmanhaExtenso, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(previsaoDepoisDeAmanha!.condicao.icone),
                      const SizedBox(width: 10),
                      Column(
                        children: [
                          Text('Mín: ${previsaoDepoisDeAmanha!.minTemp}°C'),
                          Text('Máx: ${previsaoDepoisDeAmanha!.maxTemp}°C'),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('De hora em hora', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      controller: _scrollControllerAmanhaEDepois,
                      scrollDirection: Axis.horizontal,
                      itemCount: horasDepoisDeAmanha.length,
                      itemBuilder: (_, i) {
                        final h = horasDepoisDeAmanha[i];
                        return Container(
                          height: 180,
                          width: itemHorarioLargura,
                          margin: const EdgeInsets.symmetric(horizontal: itemHorarioMargem),
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
                    ).build(context)
                  ),
                ],
              ),
            )
          )
    );
  }
}