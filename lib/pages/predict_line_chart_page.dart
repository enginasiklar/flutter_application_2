import 'package:flutter/material.dart';
import '../charts/predict_line_chart.dart';
import '../model/line_model.dart';
import '../services/api_service.dart';

class PredictLineDataPage extends StatefulWidget {
  const PredictLineDataPage({super.key});

  @override
  State<PredictLineDataPage> createState() => _PredictLineDataPageState();
}

class _PredictLineDataPageState extends State<PredictLineDataPage> {
  bool closeViewed = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Center(
        child: FutureBuilder<List<LineData>>(
            future: ApiService().getLineData(),
            builder: (
              BuildContext context,
              AsyncSnapshot snapshot,
            ) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              return Column(children: [
                closeViewed
                    ? PredictLineDataWidget(
                        points: snapshot.data, showCloseData: true)
                    : PredictLineDataWidget(
                        points: snapshot.data, showCloseData: false),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Show close price"),
                    Switch(
                      value: closeViewed,
                      onChanged: (value) => setState(() {
                        closeViewed = !closeViewed;
                      }),
                    ),
                  ],
                ),
              ]);
            }),
      ),
    );
  }
}
