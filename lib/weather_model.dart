class WeatherModel {
  final String cidade;
  final int temperatura;
  final bool chuva;
  final int vento;

  WeatherModel({
    required this.cidade,
    required this.temperatura,
    required this.chuva,
    required this.vento,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cidade: json['cidade'],
      temperatura: json['temperatura'],
      chuva: json['chuva'],
      vento: json['vento_kmh'],
    );
  }
}
