import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'widgets/main_widget.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class WeatherInfo {
  final String location;
  final double temp;
  final double tempMin;
  final double tempMax;
  final String weather;
  final double humidity;
  final double windspeed;

  WeatherInfo({
    required this.location,
    required this.temp,
    required this.tempMin,
    required this.tempMax,
    required this.weather,
    required this.humidity,
    required this.windspeed,
  });
  factory WeatherInfo.fromJson(Map<String, dynamic> json) {
    return WeatherInfo(
        location: json['name'].toString(),
        temp: json['main']['temp'].toDouble(),
        tempMin: json['main']['temp_min'].toDouble(),
        tempMax: json['main']['temp_max'].toDouble(),
        weather: json['weather'][0]['description'],
        humidity: json['main']['humidity'].toDouble(),
        windspeed: json['wind']['speed'].toDouble());
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather XLR8',
        home: AnimatedSplashScreen(
            duration: 1000,
            splash: Image.asset('assets/ae.png'),
            nextScreen: MainScreen(),
            splashTransition: SplashTransition.fadeTransition,
            pageTransitionType: PageTransitionType.leftToRightWithFade,
            backgroundColor: Colors.white));
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isloaded = false;
  WeatherInfo weatherInfo = WeatherInfo(
      location: "location",
      temp: 45.5,
      tempMin: 45.5,
      tempMax: 42.5,
      weather: "weather",
      humidity: 23.5,
      windspeed: 10.5);
  void fetchweather(String zip) async {
    final zipCode = zip;
    final apiKey = "51d32ce79a288b804e9aedb040c720e5";
    final requestURL =
        "https://api.openweathermap.org/data/2.5/weather?q=${zipCode}&units=metric&appid=${apiKey}";

    final response = await http.get(Uri.parse(requestURL));
    if (response.statusCode == 200) {
      isloaded = true;
      weatherInfo = WeatherInfo.fromJson(jsonDecode(response.body));
      showOngoingNotification(
          weatherInfo.location, weatherInfo.temp, weatherInfo.windspeed);
      setState(() {});
    } else {
      throw Exception("Error loading the request");
    }
  }

  String cityName = "bhuj";

  TextEditingController contr = new TextEditingController();
  @override
  void initState() {
    super.initState();
    var androidSettings = AndroidInitializationSettings('app_icon');
    var iOSSettings = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    var initSetttings =
        InitializationSettings(android: androidSettings, iOS: iOSSettings);
    flutterLocalNotificationsPlugin.initialize(
      initSetttings,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Weather XLR8"),
          backgroundColor: Colors.purple[400],
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    cursorColor: Theme.of(context).cursorColor,
                    controller: contr,
                    maxLength: 20,
                    decoration: InputDecoration(
                      hintText: "Cityname",
                      labelText: 'City Name',
                      labelStyle: TextStyle(
                        color: Color(0xFF6200EE),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.check_circle),
                        onPressed: () {
                          cityName = contr.text.toString();
                          isloaded = false;
                          print('presed');
                          fetchweather(cityName);
                        },
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6200EE)),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    flex: 10,
                    child: isloaded
                        ? MainWidget(
                            location: weatherInfo.location,
                            temp: weatherInfo.temp,
                            tempMin: weatherInfo.tempMin,
                            tempMax: weatherInfo.tempMax,
                            weather: weatherInfo.weather,
                            humidity: weatherInfo.humidity,
                            windspeed: weatherInfo.windspeed,
                          )
                        : Center(child: Text("Loading..."))),
              ],
            ),
          ),
        ));
  }
}

// Future<void> showOngoingNotification(location, temp, windspeed) async {
//   const AndroidNotificationDetails androidNotificationDetails =
//       AndroidNotificationDetails(
//           'channel_id', 'Channel Name', 'Channel Description',
//           importance: Importance.high,
//           priority: Priority.high,
//           ongoing: true,
//           autoCancel: false);
//   const NotificationDetails notificationDetails =
//       NotificationDetails(android: androidNotificationDetails, iOS: null);
//   await flutterLocalNotificationsPlugin.show(
//     0,
//     location.toString(),
//     temp.toString(),
//     notificationDetails,
//   );
// }

Future<void> showOngoingNotification(location, temp, windspeed) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
          'your channel id', 'your channel name', 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          ongoing: true,
          autoCancel: false);
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, location.toString(), temp.toString(), platformChannelSpecifics);
}
