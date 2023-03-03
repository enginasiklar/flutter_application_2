import 'package:flutter/material.dart';
import '../charts/predict_line_chart.dart';
import '../model/line_model.dart';
import '../services/api_service.dart';

// ignore: must_be_immutable
class PredictLineDataPage extends StatelessWidget {
  PredictLineDataPage({super.key});

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
            Widget showCloseDataFalse = PredictLineDataWidget(
                points: snapshot.data, showCloseData: false);
            Widget showCloseDataTrue = PredictLineDataWidget(
                points: snapshot.data, showCloseData: true);
            return StatefulBuilder(
              builder: (BuildContext context, setState) {
                return Column(
                  children: [
                    closeViewed ? showCloseDataTrue : showCloseDataFalse,
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Show close price"),
                        Switch(
                          value: closeViewed,
                          onChanged: (value) => setState(
                            () {
                              closeViewed = !closeViewed;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
