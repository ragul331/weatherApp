import 'package:flutter/material.dart';

class HourlyForecastItem extends StatelessWidget {
  final String time;
  final IconData icon;
  final String value;
  const HourlyForecastItem({super.key,
    required this.time,
    required this.icon,
    required this.value,
  }
      );

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation:6,
      child:  Container(
        height: 100,
        width: 100,
        padding: const EdgeInsets.all(8),
        child:  Column(
          children: [
            Text(time,style:const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),textAlign: TextAlign.center,
            maxLines: 1,overflow: TextOverflow.ellipsis,),
            const SizedBox(height: 8,),
            Icon(icon, size: 32,),
            const SizedBox(height: 8,),
            Text('$value °K',style: const TextStyle(fontSize: 14),),
          ],
        ),

      ),
    );
  }
}