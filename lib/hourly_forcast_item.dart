import 'package:flutter/material.dart';

class HourlyForecastItem extends StatelessWidget {
  final IconData iconData;
  final String time;
  final String temperature;
  const HourlyForecastItem({super.key, required this.iconData, required this.time, required this.temperature});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child:  Column(
          children: [
            Text(
              time,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 8.0,
            ),
            Icon(
              iconData,
              size: 32,
            ),
            const SizedBox(
              height: 8.0,
            ),
            Text(temperature),
          ],
        ),
      ),
    );
  }
}