import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostDateView extends StatelessWidget {
  final DateTime dateTime;
  const PostDateView({
    super.key,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('d MMMM, yyyy, hh,mm a');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        formatter.format(dateTime),
      ),
    );
  }
}
