import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_information.dart';
import 'package:weather_app/hourly_Forcast_item.dart';
import 'package:http/http.dart' as http;

class WeatherAppPage extends StatefulWidget {
  const WeatherAppPage({super.key});

  @override
  State<WeatherAppPage> createState() => _WeatherAppPageState();
}

class _WeatherAppPageState extends State<WeatherAppPage> {
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'London';
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=1ece80ac5c4a6cc464ff89b41b0f3c38',
        ),
      );

      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw 'An Unexpected error occurred';
      }

      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    
                  });
                },
                icon: const Icon(Icons.refresh))
          ],
          centerTitle: true,
          title: const Text(
            'Weather Checker',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Center(
          child: FutureBuilder(
            future: getCurrentWeather(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator.adaptive();
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }

              final data = snapshot.data!;
              final currentWeatherData = data['list'][0];
              final currentTemp = currentWeatherData['main']['temp'];
              final currentSky = currentWeatherData['weather'][0]['main'];
              final currentPressure = currentWeatherData['main']['pressure'];
              final currentWindSpeed = currentWeatherData['wind']['speed'];
              final currentHumidity = currentWeatherData['main']['humidity'];
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
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
                                    height: 10,
                                  ),
                                  Icon(
                                    currentSky == 'Clouds' ||
                                            currentSky == 'Rain'
                                        ? Icons.cloud
                                        : Icons.sunny,
                                    size: 64,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    currentSky,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
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
                   const Column(
                      children: [
                         Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Hourly Forcast',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                         SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 130,
                    
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context , index){
                            final hourlyForcast = data['list'][index + 1];
                            final hourlyTemp = hourlyForcast['main']['temp'].toString();
                            final hourlySky = data['list'][index + 1]['weather'][0]['main'];
                            final time = DateTime.parse(hourlyForcast['dt_txt'].toString());
                            return HourlyForcast(
                            time: DateFormat.j().format(time), 
                            icon: hourlySky == 'Clouds' || hourlySky == 'Rain'? Icons.cloud : Icons.sunny, 
                            fern: hourlyTemp);
                        }
                      
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Additional Information',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            AdditionalInformation(
                              icon: Icons.water_drop,
                              label: 'Humdity',
                              value: currentHumidity.toString(),
                            ),
                            AdditionalInformation(
                              icon: Icons.air,
                              label: 'Wind Speed',
                              value: currentWindSpeed.toString(),
                            ),
                            AdditionalInformation(
                              icon: Icons.beach_access,
                              label: 'Pressure',
                              value: currentPressure.toString(),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }
}
