import 'package:flutter/material.dart';

class AdditionalInfoItem extends StatelessWidget {
  final IconData iconData;
  final String label;
  final String value;

  const AdditionalInfoItem({
    super.key,
    required this.iconData,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          iconData,
          size: 32,
        ),
        const SizedBox(
          height: 8.0,
        ),
        Text(label),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
