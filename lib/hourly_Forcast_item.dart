import 'package:flutter/material.dart';

class HourlyForcast extends StatelessWidget {
  const HourlyForcast(
      {super.key, required this.time, required this.icon, required this.fern});
  final String time;
  final IconData icon;
  final String fern;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child:  Column(
          children: [
            Text(
              time,
              style:const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
           const SizedBox(
              height: 8,
            ),
            Icon(
             icon,
              size: 25,
            ),
           const SizedBox(
              height: 8,
            ),
            Text(
              fern,
              style:const TextStyle(
                fontSize: 20,
              ),
            )
          ],
        ),
      ),
    );
  }
}
