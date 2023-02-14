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
    _chartData = ApiService().fetchStockData(widget.stockCode, null);
  }

  ButtonStyle selectedButtonColor = ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.green.shade50),
      foregroundColor: MaterialStateProperty.all(Colors.green),
      padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
      textStyle: MaterialStateProperty.all(
          const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)));
  ButtonStyle notSelectedButtonColor = ButtonStyle(
      foregroundColor: MaterialStateProperty.all(Colors.black54),
      padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
      textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 18)));
  int _selected = 0;
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

                  return Column(
                    children: [
                      SfCartesianChart(
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
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            onPressed: () => setState(() {
                              _selected = 0;
                              _chartData = ApiService()
                                  .fetchStockData(widget.stockCode, 0);
                            }),
                            style: _selected == 0
                                ? selectedButtonColor
                                : notSelectedButtonColor,
                            child: const Text("D"),
                          ),
                          OutlinedButton(
                              onPressed: () => setState(() {
                                    _selected = 1;
                                    _chartData = ApiService()
                                        .fetchStockData(widget.stockCode, 1);
                                  }),
                              style: _selected == 1
                                  ? selectedButtonColor
                                  : notSelectedButtonColor,
                              child: const Text("W")),
                          OutlinedButton(
                              onPressed: () => setState(() {
                                    _selected = 2;
                                    _chartData = ApiService()
                                        .fetchStockData(widget.stockCode, 2);
                                  }),
                              style: _selected == 2
                                  ? selectedButtonColor
                                  : notSelectedButtonColor,
                              child: const Text("M")),
                        ],
                      ),
                    ],
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
