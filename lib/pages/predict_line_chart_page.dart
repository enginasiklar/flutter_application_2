import 'package:flutter/material.dart';
import '../charts/predict_line_chart.dart';
import '../model/line_model.dart';
import '../services/api_service.dart';

class PredictLineDataPage extends StatelessWidget {
  const PredictLineDataPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
            child: FutureBuilder<List<LineData>>(
                future: ApiService().getLineData(),
                builder: (
                  BuildContext context,
                  AsyncSnapshot snapshot,
                ) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [CircularProgressIndicator()]);
                  }
                  return Column(children: [
                    PredictLineDataWidget(
                        points: snapshot.data, showCloseData: true),
                    const SizedBox(height: 10),
                    PredictLineDataWidget(
                        points: snapshot.data, showCloseData: false),
                  ]);
                })),
      ),
    );
  }
}
