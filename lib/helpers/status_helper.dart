import 'package:flutter/material.dart';

class StatusHelper {
  static Widget getStatusWidget(String status) {
    Color textColor = status.toLowerCase() == 'ativo' ? Colors.green : Colors.red;

    return Text(
      status,
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
