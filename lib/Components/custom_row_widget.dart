import 'package:flutter/material.dart';

class CustomRow extends StatelessWidget {
  const CustomRow({
    required this.item,
    required this.title,
  });

  final String? item;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title ?? '',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                  fontWeight: FontWeight.w600)),
          Text(item ?? '',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w600))
        ],
      ),
    );
  }
}
