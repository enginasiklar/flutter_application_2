import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../model/stock_model.dart';
import '../services/api_service.dart';

//TODO more memory efficient graph data loading using the time constrained calling of api

class StockPage extends StatefulWidget {
  const StockPage(
      {super.key, required this.stockCode, required this.stockName});
  final String stockCode;
  final String stockName;
  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  late Future<List<StockData>> _chartData;
  final TrackballBehavior _trackballBehavior =
      TrackballBehavior(enable: true, activationMode: ActivationMode.singleTap);

  @override
  void initState() {
    super.initState();
    _chartData = ApiService().fetchStockData(widget.stockCode);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.stockName),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
                child: FutureBuilder<List<StockData>>(
              future: _chartData,
              builder: (BuildContext context,
                  AsyncSnapshot<List<StockData>> snapshot) {
                if (snapshot.hasData) {
                  List<StockData> chartSampleData = snapshot.data!.map((data) {
                    return StockData(
                        date: data.date,
                        lowPrice: data.lowPrice,
                        highPrice: data.highPrice,
                        openingPrice: data.openingPrice,
                        closingPrice: data.closingPrice);
                  }).toList();
                  return SfCartesianChart(
                    zoomPanBehavior: ZoomPanBehavior(
                        enableDoubleTapZooming: true, enablePanning: true),
                    title: ChartTitle(text: widget.stockCode),
                    trackballBehavior: _trackballBehavior,
                    series: <CandleSeries>[
                      CandleSeries<StockData, DateTime>(
                          dataSource: chartSampleData,
                          name: widget.stockCode,
                          xValueMapper: (StockData sales, _) => sales.date,
                          lowValueMapper: (StockData sales, _) =>
                              sales.lowPrice,
                          highValueMapper: (StockData sales, _) =>
                              sales.highPrice,
                          openValueMapper: (StockData sales, _) =>
                              sales.openingPrice,
                          closeValueMapper: (StockData sales, _) =>
                              sales.closingPrice)
                    ],
                    primaryXAxis: DateTimeAxis(
                        dateFormat: DateFormat.MMM(),
                        majorGridLines: const MajorGridLines(width: 0)),
                    primaryYAxis: NumericAxis(
                        numberFormat:
                            NumberFormat.simpleCurrency(decimalDigits: 0)),
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ))
          ],
        ),
      ),
    );
  }
}
