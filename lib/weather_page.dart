import 'dart:convert';

import 'package:clima_app/weather_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  late Future<List<WeatherModel>> weatherFuture;

  final String url =
      "https://raw.githubusercontent.com/matheusjferreira/back_clima/main/weather.json";

  Future<List<WeatherModel>> fetchWeather() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => WeatherModel.fromJson(e)).toList();
    } else {
      throw Exception("Erro ao carregar dados");
    }
  }

  @override
  void initState() {
    super.initState();
    weatherFuture = fetchWeather();
  }

  String getStatus(WeatherModel weather) {
    if (weather.vento > 40) {
      return "Alerta de vento forte";
    }

    if (weather.chuva && weather.vento > 20) {
      return "Risco moderado";
    }

    return "Condições normais";
  }

  IconData getWeatherIcon(bool chuva) {
    return chuva ? Icons.cloud : Icons.wb_sunny;
  }

  Color getCardColor(WeatherModel weather) {
    if (weather.vento > 40) return Colors.red.shade100;
    if (weather.chuva && weather.vento > 20) return Colors.orange.shade100;
    return Colors.green.shade100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Monitor Climático PI V UNIVESP")),
      body: FutureBuilder<List<WeatherModel>>(
        future: weatherFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Erro ao carregar dados"));
          }

          final cities = snapshot.data!;

          return ListView.builder(
            itemCount: cities.length,
            itemBuilder: (context, index) {
              final weather = cities[index];

              return Card(
                color: getCardColor(weather),
                elevation: 4,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Icon(
                    getWeatherIcon(weather.chuva),
                    size: 40,
                    color: Colors.orange,
                  ),
                  title: Text(
                    weather.cidade,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    "${weather.temperatura}°C | Vento: ${weather.vento} km/h\n${getStatus(weather)}",
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
