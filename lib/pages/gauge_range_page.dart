import 'package:flutter/material.dart';
import 'package:flutter_application_2/charts/gauge_range.dart';
import 'package:flutter_application_2/services/api_service.dart';
import 'package:flutter_application_2/model/gauge_model.dart';

class GaugeRangePage extends StatelessWidget {
  GaugeRangePage({Key? key}) : super(key: key);
  final Future<Sentiment> futureSentiment = ApiService().getSentiment();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20), // Add space at the top
          const Card(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                "General Market Sentiment",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Divider(), // Add a separating line
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: FutureBuilder<Sentiment>(
                  future: futureSentiment,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return GaugeRangeWidget(snapshot.data!.data[0]);
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
