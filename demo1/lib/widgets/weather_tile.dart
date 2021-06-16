import 'package:flutter/material.dart';

class WeatherTile extends StatelessWidget {
  IconData iconwea;
  String title;
  String subtitle;
  WeatherTile(
      {required this.iconwea, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Icon(iconwea, color: Colors.purple)],
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: Color(0xff9e9e9e)),
      ),
    );
  }
}
