class AppConfig {

  static const bool isProducao = bool.fromEnvironment('PRODUCAO');

  static String get apiBaseUrl {
    return isProducao
      ? 'https://comunidade-api.fly.dev/api'
      : 'http://10.0.2.2:8080';
  }
  
}