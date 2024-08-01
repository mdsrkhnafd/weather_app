import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_info_item.dart';
import 'package:weather_app/secrets.dart';
import 'hourly_forcast_item.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {

  late double temp;

  late Future<Map<String , dynamic>> weather;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    weather = getCurrentWeather();
  }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String countryName = 'Pakistan';
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$countryName&appid=$openWeatherApiKey',
        ),
      );
      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw 'An unexpected error occurred';
      }

      return data;

      // else{
      //   print(data['list'][0]['main']['temp']);
      // }
    }
    catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {
            setState(() {

            });
          }, icon: const Icon(Icons.refresh))
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: weather,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive(),);
            }
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()),);
            }
            final data = snapshot.data!;
            final currentWeatherData = data['list'][0];
            final currentTemp = currentWeatherData['main']['temp'];
            final currentPressure = currentWeatherData['main']['pressure'];
            final currentHumidity = currentWeatherData['main']['humidity'];
            final currentWindSpeed = currentWeatherData['wind']['speed'];
            final currentSky = currentWeatherData['weather'][0]['main'];
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// main card
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  '$currentTemp K',
                                  style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 16.0,
                                ),
                                Icon(
                                  currentSky == 'Clouds' || currentSky == 'Rain'
                                      ? Icons.cloud
                                      : Icons.sunny,
                                  size: 64,
                                ),
                                const SizedBox(
                                  height: 16.0,
                                ),
                                Text(
                                  '$currentSky',
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Weather Forcast",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),

                  /// weather forecast card
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        final hourlyForecast = data['list'][index + 1];
                        final hourlySky = data['list'][index + 1]['weather'][0]['main'];
                        final hourlyTemp = hourlyForecast['main']['temp'].toString();
                        final time = DateTime.parse(hourlyForecast['dt_txt'].toString());
                        return HourlyForecastItem(
                          iconData: hourlySky ==
                              'Clouds' || hourlySky == 'Rain'
                              ? Icons.cloud
                              : Icons.sunny,
                          time: DateFormat.j().format(time),
                          temperature: hourlyTemp,
                        );
                      },),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Additional Information",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),

                  /// Additional Information
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditionalInfoItem(
                        iconData: Icons.water_drop,
                        label: 'Humidity',
                        value: currentHumidity.toString(),
                      ),
                      AdditionalInfoItem(
                        iconData: Icons.air,
                        label: 'Wind Speed',
                        value: currentWindSpeed.toString(),
                      ),
                      AdditionalInfoItem(
                        iconData: Icons.beach_access,
                        label: 'Pressure',
                        value: currentPressure.toString(),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
