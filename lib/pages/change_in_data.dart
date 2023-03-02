import 'package:flutter/material.dart';

class StockChange {
  static Widget getChangeWidget(double currentPrice, double previousPrice) {
    final change = ((currentPrice - previousPrice) / previousPrice) * 100;
    final isPositive = change >= 0;

    return Row(
      children: [
        Text(
          '${change.toStringAsFixed(2)}%',
          style: TextStyle(
            color: isPositive ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        Icon(
          isPositive ? Icons.arrow_drop_up : Icons.arrow_drop_down,
          color: isPositive ? Colors.green : Colors.red,
        ),
      ],
    );
  }
}
