import 'package:flutter/material.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile(
      {super.key,
      required this.name,
      required this.value,
      this.onChanged,
      required this.time});

  final String name;
  final bool value;
  final String time;
  final void Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
      decoration: BoxDecoration(
          color: Colors.blue.withOpacity(.4),
          borderRadius: BorderRadius.circular(12.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(time)
            ],
          ),
          Switch.adaptive(value: value, onChanged: onChanged)
        ],
      ),
    );
  }
}
