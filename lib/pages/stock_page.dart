import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../model/stock_model.dart';
import '../services/api_service.dart';

//TODO list available stocks when clicked into the box, zoom-out func, better starting position, remove the right part

class stockPage extends StatefulWidget {
  const stockPage({super.key});

  @override
  _stockPageState createState() => _stockPageState();
}

class _stockPageState extends State<stockPage> {
  late Future<List<StockData>> _chartData;
  final TrackballBehavior _trackballBehavior = TrackballBehavior(
      enable: true, activationMode: ActivationMode.singleTap);
  String _stockCode = 'AAPL'; // default stock code

  @override
  void initState() {
    super.initState();
    _chartData = ApiService().fetchStockData(_stockCode);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Column(
              children: <Widget>[
          Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  decoration: InputDecoration(labelText: 'Enter stock code'),
                  onChanged: (value) {
                    _stockCode = value;
                  },
                ),
              ),
              ElevatedButton(
                child: Text('Submit'),
                onPressed: () {
                  setState(() {
                    _chartData = ApiService().fetchStockData(_stockCode);
                  });
                },
              )
            ],
          ),
        ),
        Expanded(
            child: FutureBuilder<List<StockData>>(
              future: _chartData,
              builder: (BuildContext context, AsyncSnapshot<List<StockData>> snapshot) {
                if (snapshot.hasData) {
                  List<StockData> chartSampleData = snapshot.data!.map((data) {
                    return StockData(
                        date: data.date,
                        lowPrice: data.lowPrice,
                        highPrice: data.highPrice,
                        openingPrice: data.openingPrice,
                        closingPrice: data.closingPrice
                    );
                  }).toList();
                  return SfCartesianChart(
                    zoomPanBehavior: ZoomPanBehavior(
                        enableDoubleTapZooming: true,
                        enablePanning: true),
                    title: ChartTitle(text: _stockCode),
                    legend: Legend(isVisible: true),
                    trackballBehavior: _trackballBehavior,
                    series: <CandleSeries>[
                      CandleSeries<StockData, DateTime>(
                          dataSource: chartSampleData,
                          name: _stockCode,
                          xValueMapper: (StockData sales, _) => sales.date,
                          lowValueMapper: (StockData sales, _) => sales.lowPrice,
                          highValueMapper: (StockData sales, _) => sales.highPrice,
                          openValueMapper: (StockData sales, _) => sales.openingPrice,
                          closeValueMapper: (StockData sales, _) => sales.closingPrice)
                    ],
                    primaryXAxis: DateTimeAxis(
                        dateFormat: DateFormat.MMM(),
                        majorGridLines: MajorGridLines(width: 0)),
                    primaryYAxis: NumericAxis(
                        numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0)),
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return CircularProgressIndicator();
              },
            ))])));
  }
}



