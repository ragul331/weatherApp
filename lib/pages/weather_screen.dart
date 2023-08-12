import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/pages/secrets.dart';
import 'additional_info_item.dart';
import 'hourly_forecast_item.dart';
import 'package:http/http.dart' as http;


class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String,dynamic>> weather;
  final String cityName = 'Karur';
  Future<Map<String,dynamic>> getCurrentWeather() async {
    try {

      final result = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey'),);
      final data = jsonDecode(result.body);
      if (data['cod'] != '200') {
        throw 'An unexpected error occurred';
      }
      return data;

    }
    catch(e)
    {
      throw e.toString();
    }
  }
  @override
  void initState() {
    super.initState();
    weather=getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Weather-$cityName',style: const TextStyle(
          fontWeight: FontWeight.bold,),
        ),
        centerTitle: true,
        actions:  [
          IconButton(onPressed: (){
            setState(() {
              weather=getCurrentWeather();
            });
          },
          icon: const Icon(Icons.refresh)
          ),
        ],
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context,snapshot)
        {
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if(snapshot.hasError)
            {
              return Center(child: Text(snapshot.error.toString()));
            }
          final data=snapshot.data!;
          final currentWeather=data['list'][0];
          final currentTemp=currentWeather['main']['temp'];
          final currentSky=currentWeather['weather'][0]['main'];
          final humidity=currentWeather['main']['humidity'];
          final windSpeed=currentWeather['wind']['speed'];
          final pressure=currentWeather['main']['pressure'];
               return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      //   Main Card
                      SizedBox(
                        width: double.infinity,
                        height: 200,
                        child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child:Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '$currentTemp°K',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 32,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Icon(
                                    currentSky=='Clouds' || currentSky=='Rain' ? Icons.cloud : Icons.sunny,
                                    size: 65,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '$currentSky',
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // Weather Info
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Hourly Forecast',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection:Axis.horizontal ,
                            itemCount: 5,
                            itemBuilder: (context,index){
                              final hourlyForecastItem=data['list'][index+1];
                              final time=DateTime.parse(hourlyForecastItem['dt_txt']);
                          return HourlyForecastItem(time: DateFormat.jm().format(time),
                              icon: data['list'][index+1]['weather'][0]['main']=='Clouds' || data['list'][index+1]['weather'][0]['main']=='Rain' ? Icons.cloud : Icons.sunny,
                              value: hourlyForecastItem['main']['temp'].toString());
                        }),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // Additional Info
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Additional Information',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          AdditionalInfoItem(
                            icon: Icons.water_drop,
                            label: 'Humidity',
                            value: '$humidity',
                          ),
                          AdditionalInfoItem(
                            icon: Icons.air,
                            label: 'Wind Speed',
                            value: '$windSpeed',
                          ),
                          AdditionalInfoItem(
                            icon: Icons.beach_access_rounded,
                            label: 'Pressure',
                            value: '$pressure',
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }),
    );
  }
}


