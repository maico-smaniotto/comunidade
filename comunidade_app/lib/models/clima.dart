class CondicaoClima {
  final String texto;
  final String icone;

  CondicaoClima({
    required this.texto,
    required this.icone
  });

  factory CondicaoClima.fromJson(Map<String, dynamic> json) {
    return CondicaoClima(
      texto: obterCondicaoPorCodigo(json['code']) ?? json['text'], 
      icone: 'https:${json['icon']}',
    );
  }

  static String? obterCondicaoPorCodigo(int code) {
    return conditionCodeTranslations[code];
  }

  static const Map<int, String> conditionCodeTranslations = {
    1000: 'Ensolarado',
    1003: 'Parcialmente nublado',
    1006: 'Nublado',
    1009: 'Encoberto',
    1030: 'Névoa',
    1063: 'Possibilidade de chuva',
    1066: 'Possibilidade de neve',
    1069: 'Possibilidade de chuva congelante',
    1072: 'Possibilidade de garoa congelante',
    1087: 'Possibilidade de trovoadas',
    1114: 'Rajadas de neve',
    1117: 'Nevasca',
    1135: 'Nevoeiro',
    1147: 'Nevoeiro congelante',
    1150: 'Garoa fraca',
    1153: 'Garoa',
    1168: 'Garoa congelante fraca',
    1171: 'Garoa congelante',
    1180: 'Chuva fraca intermitente',
    1183: 'Chuva fraca',
    1186: 'Chuva moderada intermitente',
    1189: 'Chuva moderada',
    1192: 'Chuva forte intermitente',
    1195: 'Chuva forte',
    1198: 'Chuva congelante fraca',
    1201: 'Chuva congelante',
    1204: 'Chuva e neve fraca',
    1207: 'Chuva e neve',
    1210: 'Neve fraca intermitente',
    1213: 'Neve fraca',
    1216: 'Neve moderada intermitente',
    1219: 'Neve moderada',
    1222: 'Neve forte intermitente',
    1225: 'Neve forte',
    1237: 'Granizo',
    1240: 'Aguaceiros fracos',
    1243: 'Aguaceiros moderados ou fortes',
    1246: 'Aguaceiros intensos',
    1249: 'Aguaceiros com neve fraca',
    1252: 'Aguaceiros com neve forte',
    1255: 'Nevasca leve',
    1258: 'Nevasca forte',
    1261: 'Aguaceiros com granizo fraco',
    1264: 'Aguaceiros com granizo forte',
    1273: 'Trovoadas com chuva fraca',
    1276: 'Trovoadas com chuva forte',
    1279: 'Trovoadas com neve fraca',
    1282: 'Trovoadas com neve forte',
  };
}

class ClimaAtual {
  final double tempC;
  final CondicaoClima condicao;

  ClimaAtual({
    required this.tempC,
    required this.condicao
  });

  factory ClimaAtual.fromJson(Map<String, dynamic> json) {
    return ClimaAtual(
      tempC: json['temp_c'], 
      condicao: CondicaoClima.fromJson(json['condition'])
    );
  }
}

class PrevisaoDia {
  final DateTime data;
  final double maxTemp;
  final double minTemp;
  final CondicaoClima condicao;

  PrevisaoDia({
    required this.data,
    required this.maxTemp,
    required this.minTemp,
    required this.condicao
  });

  factory PrevisaoDia.fromJson(Map<String, dynamic> json) {
    return PrevisaoDia(
      data: DateTime.parse(json['date']),
      maxTemp: json['day']['maxtemp_c'], 
      minTemp: json['day']['mintemp_c'], 
      condicao: CondicaoClima.fromJson(json['day']['condition'])
    );
  }
}

class PrevisaoHora {
  final String hora;
  final double temp;
  final CondicaoClima condicao;

  PrevisaoHora({
    required this.hora,
    required this.temp,
    required this.condicao
  });

  factory PrevisaoHora.fromJson(Map<String, dynamic> json) {
    return PrevisaoHora(
      hora: json['time'].split(' ')[1], 
      temp: json['temp_c'], 
      condicao: CondicaoClima.fromJson(json['condition'])
    );
  }  
}