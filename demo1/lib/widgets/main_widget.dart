import 'package:flutter/material.dart';
import 'weather_tile.dart';

class MainWidget extends StatelessWidget {
  String location;
  final double temp;
  final double tempMin;
  final double tempMax;
  final String weather;
  final double humidity;
  final double windspeed;
  MainWidget({
    required this.location,
    required this.temp,
    required this.tempMin,
    required this.tempMax,
    required this.weather,
    required this.humidity,
    required this.windspeed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 4,
          width: MediaQuery.of(context).size.height,
          color: Color(0xfff1f1f1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${location.toString()}",
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w900),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Text(
                  "${temp.toInt().toString()}°",
                  style: TextStyle(
                      color: Colors.purple,
                      fontSize: 30.0,
                      fontWeight: FontWeight.w900),
                ),
              ),
              Text(
                  "High of ${tempMin.toInt().toString()}°, Low of ${tempMax.toInt().toString()}°",
                  style: TextStyle(
                      color: Color(0xff9e9e9e),
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600))
            ],
          ),
        ),
        Expanded(
            child: Padding(
          padding: EdgeInsets.all(20.0),
          child: ListView(
            children: [
              WeatherTile(
                  iconwea: Icons.thermostat_outlined,
                  title: "Temprature",
                  subtitle: "${temp.toInt().toString()}°"),
              WeatherTile(
                  iconwea: Icons.filter_drama_outlined,
                  title: "Weather",
                  subtitle: "${weather.toString()}"),
              WeatherTile(
                  iconwea: Icons.wb_sunny,
                  title: "Humidity",
                  subtitle: "${humidity.toString()}"),
              WeatherTile(
                  iconwea: Icons.waves_outlined,
                  title: "Wind Speed",
                  subtitle: "${windspeed.toInt().toString()} MPH"),
            ],
          ),
        ))
      ],
    );
  }
}
