import 'package:flutter/material.dart';

class SimulationInputPage extends StatefulWidget {
  @override
  _SimulationInputPageState createState() => _SimulationInputPageState();
}

class _SimulationInputPageState extends State<SimulationInputPage> {
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController startingMoneyController = TextEditingController();

  bool showSections = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulation Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Regular:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: startDateController,
              decoration: const InputDecoration(
                labelText: 'Start Date',
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2001),
                  lastDate: DateTime.now(),
                );
                if (pickedDate == null) return;
                startDateController.text =
                "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
              },
            ),
            const SizedBox(height: 8),
            TextField(
              controller: endDateController,
              decoration: const InputDecoration(
                labelText: 'End Date',
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2001),
                  lastDate: DateTime.now(),
                );
                if (pickedDate == null) return;
                endDateController.text =
                "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
              },
            ),
            const SizedBox(height: 8),
            TextField(
              controller: startingMoneyController,
              decoration: const InputDecoration(
                labelText: 'Starting Money',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showSections = true;
                });
              },
              child: const Text('Submit'),
            ),
            if (showSections) ...[
              const SizedBox(height: 24),
              Text(
                'Algo:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Value: 0'),
            ],
          ],
        ),
      ),
    );
  }
}


/*
Future<void> runSimulation(DateTime startDate, DateTime endDate, double startingMoney) async {
  // Fetch stock data from the API
  final stockData = await fetchStockData(apiEndpoint, apiUsername, apiPassword);

  if (stockData != null) {
    // Set the recommendation settings with different thresholds
    final settings = [
      {'buy_threshold': 0.005, 'sell_threshold': 0.0075},
      {'buy_threshold': 0.01, 'sell_threshold': 0.015},
      {'buy_threshold': 0.015, 'sell_threshold': 0.022}
    ];

    // Initial total money and total stocks
    double totalMoney = startingMoney;
    double totalStocks = 0;

    double bestNetWorth = 0;
    Map<String, dynamic>? bestSettings;

    for (final setting in settings) {
      // Simulate the process for each setting
      final recommendations = getRecommendation(setting, stockData, totalMoney, totalStocks);

      // Calculate the final net worth
      final finalNetWorth = recommendations.last[5] as double;

      // Compare net worth to find the best performing setting
      if (finalNetWorth > bestNetWorth) {
        bestNetWorth = finalNetWorth;
        bestSettings = setting;
      }
    }

    // Print the best performing setting
    print("Best Performing Setting:");
    print("Buy Threshold: ${bestSettings['buy_threshold']}");
    print("Sell Threshold: ${bestSettings['sell_threshold']}");

    // Calculate the amount from buying at the start date and selling at the end date
    final startValue = stockData.first[2] as double;
    final endValue = stockData.last[3] as double;
    final amountFromStartToEnd = totalStocks * endValue;

    // Display the total money and amount calculated by buying at the start date and selling at the end date
    print("Total Money: $totalMoney");
    print("Amount from Start to End: $amountFromStartToEnd");
  }*/