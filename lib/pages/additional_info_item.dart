import 'package:flutter/material.dart';

class AdditionalInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const AdditionalInfoItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      child: Column(
        children: [
          const SizedBox(height:10),
          Icon(icon,size: 35,),
          const SizedBox(height:7),
          Text(label),
          const SizedBox(height:7),
          Text(value,style:const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }
}

