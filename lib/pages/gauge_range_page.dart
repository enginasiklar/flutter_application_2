import 'package:flutter/material.dart';
import 'package:flutter_application_2/charts/gauge_range.dart';
import 'package:flutter_application_2/services/api_service.dart';
import 'package:flutter_application_2/model/gauge_model.dart';

class GaugeRangePage extends StatelessWidget {
  GaugeRangePage({super.key});
  final Future<Sentiment> futureAlbum = ApiService().getSentiment();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: FutureBuilder<Sentiment>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GaugeRangeWidget(snapshot.data!.data[0]);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              // By default, show a loading spinner.
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
