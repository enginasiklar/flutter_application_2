import 'package:flutter/material.dart';

class StockChangeWidget extends StatelessWidget {
  final double currentPrice;
  final double previousPrice;

  StockChangeWidget({required this.currentPrice, required this.previousPrice});

  @override
  Widget build(BuildContext context) {
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
